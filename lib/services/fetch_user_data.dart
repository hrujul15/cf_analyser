import 'dart:convert';

import 'package:http/http.dart' as http;

// Fetch User data

Future<Profile> fetchProfile(String username) async {
  String url = "https://codeforces.com/api/user.info?handles=$username";
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);

  if (data["status"] == "OK") {
    return Profile.fromJson(data["result"][0]);
  } else {
    throw Exception('Profile doesn\'t exist');
    
  }
}

class Profile {
  int? lastOnlineTimeSeconds;
  int? rating;
  int? friendOfCount;
  String? titlePhoto;
  String? handle;
  String? avatar;
  String? firstName;
  int? contribution;
  String? organization;
  String? rank;
  int? maxRating;
  int? registrationTimeSeconds;
  String? maxRank;

  Profile({
    this.lastOnlineTimeSeconds,
    this.rating,
    this.friendOfCount,
    this.titlePhoto,
    this.handle,
    this.avatar,
    this.firstName,
    this.contribution,
    this.organization,
    this.rank,
    this.maxRating,
    this.registrationTimeSeconds,
    this.maxRank,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    lastOnlineTimeSeconds = json['lastOnlineTimeSeconds'];
    rating = json['rating'];
    friendOfCount = json['friendOfCount'];
    titlePhoto = json['titlePhoto'];
    handle = json['handle'];
    avatar = json['avatar'];
    firstName = json['firstName'];
    contribution = json['contribution'];
    organization = json['organization'];
    rank = json['rank'];
    maxRating = json['maxRating'];
    registrationTimeSeconds = json['registrationTimeSeconds'];
    maxRank = json['maxRank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lastOnlineTimeSeconds'] = lastOnlineTimeSeconds;
    data['rating'] = rating;
    data['friendOfCount'] = friendOfCount;
    data['titlePhoto'] = titlePhoto;
    data['handle'] = handle;
    data['avatar'] = avatar;
    data['firstName'] = firstName;
    data['contribution'] = contribution;
    data['organization'] = organization;
    data['rank'] = rank;
    data['maxRating'] = maxRating;
    data['registrationTimeSeconds'] = registrationTimeSeconds;
    data['maxRank'] = maxRank;
    return data;
  }
}
