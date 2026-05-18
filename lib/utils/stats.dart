import 'dart:collection';

import 'package:cfar/services/user_status.dart';

class Stats {
  String averageSolvedRating = "0";
  String successRate = "0.00";
  String recentAverageSolvedRating = "0"; // last 25
  String recentSuccessRate = "0.00"; // last 50
  Stats({
    required this.averageSolvedRating,
    required this.successRate,
    required this.recentAverageSolvedRating,
    required this.recentSuccessRate,
  });
}

Stats getStats(Status status) {
  double recentAverageSolvedRating = 0.0;
  double recentSuccessRate = 0.0;

  int ratingSum = 0;
  Map<String, int> map = HashMap();
  int failedSubmissions = 0;
  int correctSubmissions = 0;
  int totalProblemsSolved = 0;
  // status.
  for (var problem in status.result ?? []) {
    // get id
    int? id = problem.contestId;
    if (id == null) {
      continue;
    }
    String index = problem.problem.index!;
    String problemName = "$id$index";

    // get wa and ac
    if (problem.verdict == "OK") {
      correctSubmissions++;

      // get the rating if correct
      int? rating = problem.problem.rating;

      if (rating == null || map[problemName] == 1) {
        continue;
      }
      map[problemName] = 1;
      totalProblemsSolved++;
      ratingSum += rating;

      if (totalProblemsSolved <= 25 && totalProblemsSolved > 0) {
        recentAverageSolvedRating = ratingSum / totalProblemsSolved;
      }
    } else {
      failedSubmissions++;
    }
    if ((correctSubmissions + failedSubmissions <= 50) &&
        (correctSubmissions + failedSubmissions > 0)) {
      recentSuccessRate =
          correctSubmissions / (correctSubmissions + failedSubmissions);
    }
  }
  return Stats(
    averageSolvedRating: totalProblemsSolved == 0
        ? "0"
        : (ratingSum / totalProblemsSolved).toStringAsFixed(0),
    successRate: (correctSubmissions + failedSubmissions) == 0
        ? "0"
        : (100 *
                  (correctSubmissions /
                      (correctSubmissions + failedSubmissions)))
              .toStringAsFixed(2),
    recentAverageSolvedRating: totalProblemsSolved == 0
        ? "0"
        : (recentAverageSolvedRating).toStringAsFixed(0),
    recentSuccessRate: (correctSubmissions + failedSubmissions) == 0
        ? "0"
        : (100 * recentSuccessRate).toStringAsFixed(2),
  );
}
