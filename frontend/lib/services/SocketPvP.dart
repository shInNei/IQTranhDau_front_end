import 'dart:async';
import 'dart:convert';
import 'package:frontend/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  WebSocketChannel? _channel;
  final String _url = SERVER_URL; // Replace with your server URL
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();
  int? _playerId;
  String? _matchId;

  // Stream to listen for incoming messages
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  // Connect to WebSocket server
  void connect(int? playerId, String matchId) {
    _playerId = playerId;
    _matchId = matchId;
    _channel = WebSocketChannel.connect(
      Uri.parse('$_url?playerId=$playerId&matchId=$matchId'),
    );
    _channel!.stream.listen(
      (data) {
        final message = jsonDecode(data as String) as Map<String, dynamic>;
        _messageController.add(message);
      },
      onError: (error) {
        _messageController.addError(error);
      },
      onDone: () {
        _channel = null;
      },
    );
  }

  // Send score update
  void sendScoreUpdate(int score) {
    if (_channel == null || _playerId == null || _matchId == null) return;
    _channel!.sink.add(
      jsonEncode({
        'type': 'score_update',
        'playerId': _playerId,
        'matchId': _matchId,
        'score': score,
      }),
    );
  }

  // Send match completion
  void sendMatchComplete(int finalScore) {
    if (_channel == null || _playerId == null || _matchId == null) return;
    _channel!.sink.add(
      jsonEncode({
        'type': 'match_complete',
        'playerId': _playerId,
        'matchId': _matchId,
        'finalScore': finalScore,
      }),
    );
  }

  // Disconnect from WebSocket
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _messageController.close();
  }
}
