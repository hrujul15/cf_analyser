import 'package:cfar/utils/graph.dart';
import 'package:flutter/material.dart';
import 'package:cfar/services/fetch_user_data.dart';
import 'package:cfar/utils/colors.dart';
import 'package:cfar/services/fetch_rating_history.dart';

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
  Future<List<int>>? rating;
  List<int> ratingHistory = [];
  int min(int a, int b) {
    if (a < b) {
      return a;
    } else {
      return b;
    }
  }

  @override
  void dispose() {
    _inputHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < 900;
    // print(isNarrow);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4CC9F0),
        title: Text(
          'CFAR - Codeforces Analyzer & Recommender',
          softWrap: true,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: isNarrow ? 13 : 22,
          ),
        ),
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
                      rating = fetchRatingHistory(value);
                    }
                  });

                  rating!.then((result) {
                    setState(() {
                      ratingHistory = result;
                    });
                  });
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
                    fontSize: isNarrow ? 13 : 20,
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
              // Display profile
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  2,
                                ), // keep slight rounding
                                child: Image.network(
                                  snapshot.data!.titlePhoto ??
                                      "https://userpic.codeforces.org/no-title.jpg",
                                  width: isNarrow ? 180 : 400,
                                  height: isNarrow ? 180 : 400,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: isNarrow ? 10 : 20),
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    coloredHandle(snapshot.data!, context),
                                    // const SizedBox(height: 10),

                                    // 2. Min Rating (placeholder logic)
                                    Row(
                                      children: [
                                        Text(
                                          "Current Rating: ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isNarrow ? 12 : 28,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data!.rating ?? "Unrated"}",
                                          style: TextStyle(
                                            color: getCFColor(
                                              snapshot.data!.rating,
                                            ),
                                            fontSize: isNarrow ? 12 : 28,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // 3. Max Rating
                                    Row(
                                      children: [
                                        Text(
                                          "Max Rating: ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isNarrow ? 12 : 28,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data!.maxRating ?? "Unrated"}",
                                          style: TextStyle(
                                            color: getCFColor(
                                              snapshot.data!.maxRating,
                                            ),
                                            fontWeight: FontWeight.w600,
                                            fontSize: isNarrow ? 12 : 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Recent Contests",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isNarrow ? 12 : 18,
                                      ),
                                    ),
                                    SizedBox(height: isNarrow ? 5 : 10),

                                    // 4. Last 5 contests (PLACEHOLDER CHIPS)
                                    Wrap(
                                      spacing: 8,
                                      children: List.generate(
                                        min(5, ratingHistory.length),
                                        (index) {
                                          int n = ratingHistory.length;
                                          List<String> values = [];
                                          for (int i = n - 1; i >= 1; --i) {
                                            int val =
                                                ratingHistory[i] -
                                                ratingHistory[i - 1];
                                            if (val > 0) {
                                              values.add("+$val");
                                            } else {
                                              values.add(val.toString());
                                            }
                                          }

                                          final val = values[index];
                                          final isPlus = val.startsWith("+");
                                          final isMinus = val.startsWith("-");

                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isNarrow ? 5 : 10,
                                              vertical: isNarrow ? 3 : 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isPlus
                                                  ? Colors.green[900]
                                                  : isMinus
                                                  ? Colors.red[900]
                                                  : Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              val,
                                              style: TextStyle(
                                                fontSize: isNarrow ? 8 : 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Graph
                          // FutureBuilder<List<int>>(
                          //   future: rating,
                          //   builder: (context, snapshot) {
                          //     if (!snapshot.hasData) {
                          //       return const CircularProgressIndicator();
                          //     }
                          //     // data = snapshot.data!;
                          //     return RatingGraph(ratingHistory: snapshot.data!);
                          //   },
                          // ),
                          // // Builder(builder: builder)
                          RatingGraph(ratingHistory: ratingHistory),
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
