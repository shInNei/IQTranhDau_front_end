import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/player.dart';
import 'package:frontend/models/room.dart';
import 'package:frontend/room.dart';
import 'services/auth_service.dart';

class SocketRomService {
  static final SocketRomService _instance = SocketRomService._internal();
  factory SocketRomService() => _instance;
  SocketRomService._internal();

  late Socket socket;
  bool _connected = false;

  Function(Room room)? _onRoomUpdateCallback;

  // ✅ Callback setter để RoomScreen có thể gán lại
  set onRoomUpdateCallback(Function(Room room) callback) {
    _onRoomUpdateCallback = callback;
  }

  /// ✅ Tách hàm setupListeners để luôn gán lại listener khi cần
  void setupListeners({
    Function(Room room)? onRoomUpdate,
    Function(dynamic)? onRoomList,
    Function(dynamic)? onRoomCreated,
    Function(dynamic)? onStartGame,
    Function(dynamic)? onRoomDestroyed,
    bool autoFetchRooms = true,
  }) {
    // 🎧 room_update
    socket.off('room_update');
    socket.on('room_update', (data) {
      try {
        final room = Room.fromJson(data);
        print('📥 room_update: ${room.id}');
        _onRoomUpdateCallback?.call(room);
        onRoomUpdate?.call(room);
      } catch (e) {
        print('❌ Failed to parse room_update: $e');
      }

      if (autoFetchRooms) getRooms();
    });

    // 🎧 room_list
    socket.off('room_list');
    socket.on('room_list', (data) {
      print('📥 room_list: $data');
      onRoomList?.call(data);
    });

    // 🎧 room_created
    socket.off('room_created');
    socket.on('room_created', (data) {
      print('📥 room_created: $data');
      onRoomCreated?.call(data);
    });

    // 🎧 start_game
    socket.off('start_game');
    socket.on('start_game', (data) {
      print('🚀 start_game: $data');
      onStartGame?.call(data);
    });

    // 🎧 room_destroyed
    socket.off('room_destroyed');
    socket.on('room_destroyed', (data) {
      print('🗑 room_destroyed: $data');
      onRoomDestroyed?.call(data);
    });

    if (autoFetchRooms) getRooms();
  }

  void connect({
    Function(Room room)? onRoomUpdate,
    required Function(dynamic) onStartGame,
    required Function(dynamic) onRoomDestroyed,
    required Function(dynamic) onRoomCreated,
    Function(dynamic)? onRoomList,
    String baseUrl = SERVER_URL,
    VoidCallback? onConnected,
  }) async {
    if (_connected) {
      setupListeners(onRoomUpdate: onRoomUpdate, onRoomList: onRoomList);

      /// 🛠️ BIND lại các sự kiện cần thiết vì `removeListeners()` đã xóa:
      socket.off('room_created');
      socket.on('room_created', onRoomCreated);

      socket.off('start_game');
      socket.on('start_game', onStartGame);

      socket.off('room_destroyed');
      socket.on('room_destroyed', onRoomDestroyed);
      print('⚠️ Already connected → setup listeners again');
      return;
    }
    print('🔌 Connecting to socket server at $baseUrl...');
    final token = await AuthService.getToken(); // Lấy token từ SharedPreferences

    if (token == null) {
      print('❌ Token không tồn tại');
      return;
    }

    socket = io(
      baseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {
          'token': token,
        },
      },
    );
    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to $baseUrl');
      _connected = true;
      if (onConnected != null) onConnected();
      setupListeners(onRoomUpdate: onRoomUpdate, onRoomList: onRoomList);
    });

    socket.on('room_created', onRoomCreated);
    socket.on('start_game', onStartGame);
    socket.on('room_destroyed', onRoomDestroyed);

    socket.onConnectError((err) {
      print('❌ Connect error: $err');
    });

    socket.onError((err) {
      print('❌ General socket error: $err');
    });
    socket.onDisconnect((_) {
      print('❌ Disconnected');
      _connected = false;
    });
  }

  void createRoom(String roomId, Player host) {
    if (!socket.connected) {
      print('❌ Cannot create room, socket not connected');
      return;
    }

    socket.emit('create_room', {
      'id': roomId,
      'host': host.toJson(),
    });
    print('📤 Emitted create_room: $roomId');
  }

  void joinRoom(String roomId, Player player) {
    if (!socket.connected) return;

    socket.emit('join_room', {
      'id': roomId,
      'user': player.toJson(),
    });
  }

  void leaveRoom(String roomId, int userId) {
    if (!socket.connected) return;

    socket.emit('leave_room', {
      'roomId': roomId,
      'userId': userId,
    });
  }

  void getRooms() {
    if (socket.connected) socket.emit('get_rooms');
  }

  /// ✅ Gọi khi muốn nhận room list bên ngoài
  void onRoomList(Function(dynamic) callback) {
    socket.off('room_list');
    socket.on('room_list', callback);
    getRooms();
  }

  /// ✅ Gọi khi muốn nhận room_update bên ngoài
  void onRoomUpdate(Function(dynamic) callback) {
    socket.off('room_update');
    socket.on('room_update', (data) {
      callback(data);
      getRooms();
    });
  }

  /// ✅ Dùng khi bấm vào phòng và đợi tham gia thành công
  void joinRoomAndWait({
    required String roomId,
    required Player player,
    required BuildContext context,
  }) {
    joinRoom(roomId, player);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    socket.once('room_update', (data) {
      Navigator.pop(context); // đóng loading

      if (data['error'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'])),
        );
        return;
      }

      final updatedRoom = Room.fromJson(data);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RoomScreen(room: updatedRoom),
        ),
      ).then((_) {
        final socketService = Provider.of<SocketRomService>(context, listen: false);
        socketService.getRooms();
      });
    });
  }

  void dispose() {
    if (_connected) {
      removeListeners(); // 👈 Gọi trước khi disconnect
      socket.disconnect();
      socket.dispose();
      _connected = false;
    }
  }

  void removeListeners() {
    socket.off('room_update');
    socket.off('start_game');
    socket.off('room_destroyed');
    socket.off('room_created');
    socket.off('room_list');
    socket.off('room_created');
  }
}
