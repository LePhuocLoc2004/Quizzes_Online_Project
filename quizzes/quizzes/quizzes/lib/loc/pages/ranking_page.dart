import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<dynamic> rankings = [];
  List<dynamic> top3 = [];
  String timeFilter = "all";

  @override
  void initState() {
    super.initState();
    fetchRanking();
  }

  Future<void> fetchRanking() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8081/api/ranking/index?timeFilter=$timeFilter"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        rankings = data['rankings'];
        top3 = data['top3'];
      });
    } else {
      throw Exception("Failed to load ranking data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Bộ lọc thời gian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: timeFilter,
                  items: const [
                    DropdownMenuItem(value: "all", child: Text("All Time")),
                    DropdownMenuItem(value: "week", child: Text("This Week")),
                    DropdownMenuItem(value: "month", child: Text("This Month")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      timeFilter = value!;
                      fetchRanking();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: fetchRanking,
                  child: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Top 3 xếp hạng
            top3.length >= 3 ? buildTop3Widget() : const Center(child: Text("No data")),

            const SizedBox(height: 20),

            // Danh sách xếp hạng
            Expanded(
              child: ListView.builder(
                itemCount: rankings.length,
                itemBuilder: (context, index) {
                  final rank = rankings[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: _getProfileImage(rank['profileImage']),
                    ),
                    title: Text(rank['username']),
                    subtitle: Text("Total Score: ${rank['totalScore']}"),
                    trailing: Text("#${index + 1}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Hàm kiểm tra và hiển thị ảnh từ **assets** nếu không có ảnh từ URL
  ImageProvider<Object> _getProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.startsWith("http")) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/');
    }
  }

  /// ✅ Hiển thị 3 người đứng đầu
  Widget buildTop3Widget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildRankBox(top3.length > 1 ? top3[1] : null, "2", Colors.grey[400]!),
        const SizedBox(width: 10),
        buildRankBox(top3.isNotEmpty ? top3[0] : null, "1", Colors.yellow[600]!),
        const SizedBox(width: 10),
        buildRankBox(top3.length > 2 ? top3[2] : null, "3", Colors.orange[400]!),
      ],
    );
  }

  /// ✅ Widget hiển thị ảnh top 3
  Widget buildRankBox(dynamic user, String rank, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: _getProfileImage(user?['profileImage']),
            ),
            const SizedBox(height: 8),
            Text(user?['username'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(user?['totalScore']?.toString() ?? "0"),
          ],
        ),
      ),
    );
  }
}
