import 'package:flutter/material.dart';

class RankedScreen extends StatefulWidget {
  final VoidCallback onBack;

  const RankedScreen({super.key, required this.onBack});

  @override
  State<RankedScreen> createState() => _RankedScreenState();
}

class _RankedScreenState extends State<RankedScreen> {
  List<Map<String, dynamic>> rankings = [];

  @override
  void initState() {
    super.initState();
    // Replace this with your actual API call
    fetchRankingData();
  }

  void fetchRankingData() async {
    // Simulated API response
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      rankings = [
        {"name": "Người tình mùa đông", "score": 27855, "title": "Thách Đấu"},
        {"name": "Mái ấm gia đình", "score": 13825, "title": "Cao Thủ"},
        {"name": "Chị Phiến", "score": 11212, "title": "Cao Thủ"},
        {"name": "Đời Mộng Du", "score": 10992, "title": "Cao Thủ"},
        {"name": "IC5555", "score": 10110, "title": "Cao Thủ"},
        {"name": "A Sin", "score": 10002, "title": "Cao Thủ"},
        {"name": "Thích Ăn Mặn", "score": 9992, "title": "Cao Thủ"},
        {"name": "Thiên Thu", "score": 9991, "title": "Cao Thủ"},
        {"name": "Đi Không Em", "score": 8001, "title": "Cao Thủ"},
      ];
      
    });
  }

  Widget _buildRankTile(int index, Map<String, dynamic> data) {
    final rank = index + 1;
    final isTop3 = rank <= 3;
    final colors = [
      Colors.greenAccent.shade400,
      Colors.amberAccent.shade700,
      Colors.deepOrangeAccent.shade200,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isTop3 ? colors[rank - 1] : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data["title"] ?? "Hạng chưa rõ",
                  style: TextStyle(color: Colors.purple, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Điểm tích lũy',
                style: TextStyle(
                  color: Colors.teal,
                  fontSize: 12,
                ),
              ),
              Text(
                '${data["score"]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

    @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.brown),
        onPressed: widget.onBack,
      ),
      title: const Text(
        'Bảng xếp hạng',
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    ),
    extendBodyBehindAppBar: true,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFDEEFFF), Color(0xFFEEF4FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea( // Automatically handles status bar spacing
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    '12356/200222', // <-- Replace with actual data later
                    style: TextStyle(
                      color: Colors.teal.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: rankings.length,
                itemBuilder: (context, index) =>
                    _buildRankTile(index, rankings[index]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}

