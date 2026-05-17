import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<int>>? fetchRatingHistory(String username) async {
  String url = "https://codeforces.com/api/user.rating?handle=$username";
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);
  List<int> ratingHistory = [];
  if (data["status"] == "OK") {
    for (var item in data["result"]) {
      ratingHistory.add(item["newRating"]);
    }
    return ratingHistory;
  } else {
    throw Exception('Profile doesn\'t exist');
  }
}
