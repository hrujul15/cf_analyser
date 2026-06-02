import 'package:cfar/utils/stats.dart';
import 'package:cfar/utils/display_graph.dart';
import 'package:flutter/material.dart';
import 'package:cfar/services/user_info.dart';
import 'package:cfar/utils/display_user_data.dart';
import 'package:cfar/services/user_rating.dart';
import 'package:cfar/services/user_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputHandler = TextEditingController();
  Future<Profile>? futureProfile;
  Future<List<int>>? futureRating;
  Future<Status>? futureStatus;

  late Status status;
  Stats stats = Stats(
    averageSolvedRating: "0",
    successRate: "0.00",
    recentAverageSolvedRating: "0",
    recentSuccessRate: "0",
  );
  List<int> ratingHistory = [];

  @override
  void dispose() {
    _inputHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 1550;
    // medium = 1.5 -> Tablet mode, 1.0 -> Mobile
    double medium = 1;
    if (w < 1550 && w >= 900) {
      medium = 1.5;
    } else if (w < 900) {
      medium = 1.0;
    }
    // print(w);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CC9F0),
        title: Text(
          'Codeforces Profile',
          softWrap: true,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isNarrow ? 15 * medium : 22,
          ),
        ),
        // Take user input
        actions: [
          SizedBox(
            width: isNarrow ? 150 : 350,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: TextField(
                controller: _inputHandler,

                onSubmitted: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      futureProfile = fetchProfile(value);
                      futureRating = fetchRatingHistory(value);
                      futureStatus = fetchStatus(value);
                    }
                  });

                  futureRating!
                      .then((result) {
                        setState(() {
                          ratingHistory = result;
                        });
                      })
                      .catchError((e) {});

                  futureStatus!
                      .then((result) {
                        setState(() {
                          status = result;
                          stats = getStats(status);
                        });
                      })
                      .catchError((e) {});
                },
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: isNarrow ? 15 : 22,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  hintText: 'Enter username',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: isNarrow ? 13 * medium : 20,
                  ),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF0F1115),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              // Display futureProfile
              FutureBuilder<Profile>(
                future: futureProfile,
                builder: (context, snapshot) {
                  if (futureProfile == null) {
                    return Center(
                      child: const Text(
                        "Enter handle",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 1. PFP + Username row
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isNarrow ? 5 * medium : 24,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: Image.network(
                                    snapshot.data!.titlePhoto ??
                                        "https://userpic.codeforces.org/no-title.jpg",
                                    width: isNarrow ? 180 * medium : 400,
                                    height: isNarrow ? 180 * medium : 400,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                SizedBox(width: isNarrow ? 10 * medium : 20),

                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: isNarrow ? 5 * medium : 0,
                                      ),

                                      coloredHandle(snapshot.data!, context),
                                      // current rating
                                      coloredRating(
                                        "Current Rating",
                                        snapshot.data!.rating,
                                        isNarrow,
                                        w,
                                      ),
                                      // max rating
                                      coloredRating(
                                        "Max Rating",
                                        snapshot.data!.maxRating,
                                        isNarrow,
                                        w,
                                      ),

                                      const SizedBox(height: 8),

                                      // Recent contests
                                      recentContests(
                                        isNarrow,
                                        ratingHistory,
                                        w,
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isNarrow) SizedBox(width: 30),
                                if (!isNarrow)
                                  Flexible(
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 55),
                                        averageProblemRatingAndSuccessRate(
                                          "Avg Solved Rating",
                                          stats.averageSolvedRating,
                                          "Recent Avg Solved Rating",
                                          stats.recentAverageSolvedRating,
                                          false,
                                          isNarrow,
                                          medium,
                                        ),
                                        averageProblemRatingAndSuccessRate(
                                          "Overall Accuracy",
                                          stats.successRate,
                                          "Recent Accuracy",
                                          stats.recentSuccessRate,
                                          true,
                                          isNarrow,
                                          medium,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Graph
                          RatingGraph(ratingHistory: ratingHistory),

                          // average solved rating
                          if (isNarrow)
                            averageProblemRatingAndSuccessRate(
                              "Avg Solved Rating",
                              stats.averageSolvedRating,
                              "Recent Avg Solved Rating",
                              stats.recentAverageSolvedRating,
                              false,
                              isNarrow,
                              medium,
                            ),
                          if (isNarrow)
                            averageProblemRatingAndSuccessRate(
                              "Overall Accuracy",
                              stats.successRate,
                              "Recent Accuracy",
                              stats.recentSuccessRate,
                              true,
                              isNarrow,
                              medium,
                            ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
