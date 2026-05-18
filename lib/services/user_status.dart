import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Status> fetchStatus(String username) async {
  String url = "https://codeforces.com/api/user.status?handle=$username";
  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);

  if (data["status"] == "OK") {
    return Status.fromJson(data);
  } else {
    throw Exception('Profile doesn\'t exist');
  }
}

class Status {
  List<Result>? result;

  Status({this.result});

  Status.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Result {
  int? id;
  int? contestId;
  int? creationTimeSeconds;
  int? relativeTimeSeconds;
  Problem? problem;
  Author? author;
  String? programmingLanguage;
  String? verdict;
  String? testset;
  int? passedTestCount;
  int? timeConsumedMillis;
  int? memoryConsumedBytes;

  Result({
    this.id,
    this.contestId,
    this.creationTimeSeconds,
    this.relativeTimeSeconds,
    this.problem,
    this.author,
    this.programmingLanguage,
    this.verdict,
    this.testset,
    this.passedTestCount,
    this.timeConsumedMillis,
    this.memoryConsumedBytes,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contestId = json['contestId'];
    creationTimeSeconds = json['creationTimeSeconds'];
    relativeTimeSeconds = json['relativeTimeSeconds'];
    problem = json['problem'] != null
        ? Problem.fromJson(json['problem'])
        : null;
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    programmingLanguage = json['programmingLanguage'];
    verdict = json['verdict'];
    testset = json['testset'];
    passedTestCount = json['passedTestCount'];
    timeConsumedMillis = json['timeConsumedMillis'];
    memoryConsumedBytes = json['memoryConsumedBytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['contestId'] = contestId;
    data['creationTimeSeconds'] = creationTimeSeconds;
    data['relativeTimeSeconds'] = relativeTimeSeconds;
    if (problem != null) {
      data['problem'] = problem!.toJson();
    }
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['programmingLanguage'] = programmingLanguage;
    data['verdict'] = verdict;
    data['testset'] = testset;
    data['passedTestCount'] = passedTestCount;
    data['timeConsumedMillis'] = timeConsumedMillis;
    data['memoryConsumedBytes'] = memoryConsumedBytes;
    return data;
  }
}

class Problem {
  int? contestId;
  String? index;
  String? name;
  String? type;
  double? points;
  List<String>? tags;
  int? rating;

  Problem({
    this.contestId,
    this.index,
    this.name,
    this.type,
    this.points,
    this.tags,
    this.rating,
  });

  Problem.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    index = json['index'];
    name = json['name'];
    type = json['type'];
    points = json['points'];
    tags = json['tags'].cast<String>();
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contestId'] = contestId;
    data['index'] = index;
    data['name'] = name;
    data['type'] = type;
    data['points'] = points;
    data['tags'] = tags;
    data['rating'] = rating;
    return data;
  }
}

class Author {
  int? contestId;
  int? participantId;
  List<Members>? members;
  String? participantType;
  bool? ghost;
  int? room;
  int? startTimeSeconds;

  Author({
    this.contestId,
    this.participantId,
    this.members,
    this.participantType,
    this.ghost,
    this.room,
    this.startTimeSeconds,
  });

  Author.fromJson(Map<String, dynamic> json) {
    contestId = json['contestId'];
    participantId = json['participantId'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    participantType = json['participantType'];
    ghost = json['ghost'];
    room = json['room'];
    startTimeSeconds = json['startTimeSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contestId'] = contestId;
    data['participantId'] = participantId;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    data['participantType'] = participantType;
    data['ghost'] = ghost;
    data['room'] = room;
    data['startTimeSeconds'] = startTimeSeconds;
    return data;
  }
}

class Members {
  String? handle;

  Members({this.handle});

  Members.fromJson(Map<String, dynamic> json) {
    handle = json['handle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['handle'] = handle;
    return data;
  }
}
