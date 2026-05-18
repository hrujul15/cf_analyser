import 'package:flutter/material.dart';
import 'package:cfar/services/user_info.dart';

// Get color for rating
Color getCFColor(int? rating) {
  if (rating == null) return Colors.white;

  if (rating < 1200) {
    return Colors.grey; // Newbie
  } else if (rating < 1400) {
    return Colors.green; // Pupil
  } else if (rating < 1600) {
    return Colors.cyan; // Specialist
  } else if (rating < 1900) {
    return Colors.blue; // Expert
  } else if (rating < 2100) {
    return Colors.purple; // Candidate Master
  } else if (rating < 2300) {
    return Colors.orange; // Master
  } else if (rating < 2400) {
    return Colors.orangeAccent; // Intl Master
  } else if (rating < 2600) {
    return Colors.red; // Grandmaster
  } else if (rating < 3000) {
    return Colors.redAccent; // Intl GM
  }

  return Colors.red.shade900; // Legendary GM
}

// Print the rating
Widget coloredRating(String ratingType, int? rating, bool isNarrow, double w) {
  final isNarrow = w < 1550;
  double medium = 1;
  if (w < 1550 && w >= 900) {
    medium = 1.5;
  } else if (w < 900) {
    medium = 1.0;
  }
  return Text.rich(
    TextSpan(
      text: "$ratingType: ",
      style: TextStyle(
        color: Colors.white,
        fontSize: isNarrow ? 15 * medium : 28,
        fontWeight: FontWeight.w600,
      ),
      children: <TextSpan>[
        TextSpan(
          text: "${rating ?? "Unrated"}",
          style: TextStyle(
            color: getCFColor(rating),
            fontSize: isNarrow ? 15 * medium : 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

// Print the handle
Widget coloredHandle(Profile p, BuildContext context) {
  final style = Theme.of(
    context,
  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700);

  final w = MediaQuery.of(context).size.width;
  final isNarrow = w < 1550;
  double medium = 1;
  if (w < 1550 && w >= 900) {
    medium = 1.5;
  } else if (w < 900) {
    medium = 1.0;
  }
  if ((p.rating ?? 0) < 3000) {
    return Text(
      p.handle ?? "N/A",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: style.copyWith(
        color: getCFColor(p.rating),
        fontSize: isNarrow ? 22 * medium : 64,
      ),
    );
  }

  return RichText(
    text: TextSpan(
      style: style, // base style
      children: [
        const TextSpan(text: ""),
        TextSpan(
          text: p.handle![0],
          style: TextStyle(
            color: Colors.white,
            fontSize: isNarrow ? 32 * medium : 64,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const TextSpan(text: ""),
        TextSpan(
          text: p.handle!.substring(1),
          style: TextStyle(
            color: Colors.red,
            fontSize: isNarrow ? 32 * medium : 64,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

int min(int a, int b) {
  if (a < b) {
    return a;
  } else {
    return b;
  }
}

// Get recent contests performance
Widget recentContests(bool isNarrow, List<int> ratingHistory, double w) {
  final isNarrow = w < 1550;
  double medium = 1;
  if (w < 1550 && w >= 900) {
    medium = 1.5;
  } else if (w < 900) {
    medium = 1.0;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Recent Contests",
        style: TextStyle(
          color: Colors.white,
          fontSize: isNarrow ? 13 * medium : 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      Wrap(
        spacing: isNarrow ? 6 * medium : 12,
        runSpacing: 4,
        children: List.generate(min(5, ratingHistory.length), (index) {
          int n = ratingHistory.length;
          List<String> values = [];

          for (int i = n - 1; i >= 1; --i) {
            int val = ratingHistory[i] - ratingHistory[i - 1];
            values.add(val > 0 ? "+$val" : "$val");
          }
          if (index >= values.length) {
            if (ratingHistory.isNotEmpty) {
              int val = ratingHistory.first;
              values.add(val > 0 ? "+$val" : "$val");
            } else {
              return const SizedBox();
            }
          }

          final val = values[index];
          final isPlus = val.startsWith("+");
          final isMinus = val.startsWith("-");

          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 5 * medium : 10,
                  vertical: isNarrow ? 3 * medium : 6,
                ),
                decoration: BoxDecoration(
                  color: isPlus
                      ? Colors.green[900]
                      : isMinus
                      ? const Color.fromARGB(255, 110, 16, 16)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  val,
                  style: TextStyle(
                    fontSize: isNarrow ? 9 * medium : 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // get arrow pointing towards first element
              if (index == 0)
                Align(
                  widthFactor: 0,
                  heightFactor: 0,
                  child: Transform.translate(
                    offset: Offset(0, isNarrow ? 8 * medium : 16),
                    child: Icon(
                      Icons.arrow_drop_up_outlined,
                      color: Color(0xFF4CC9F0),
                      size: isNarrow ? 28 * medium : 58,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    ],
  );
}

// Display average problem rating and success rate
Color getSuccessrateColor(String successRate) {
  Color color = Colors.white;
  double sr = double.parse(successRate);
  if (sr <= 15.00) {
    color = Colors.red[800]!;
  } else if (sr < 30.00) {
    color = Colors.deepOrange;
  } else if (sr < 40.00) {
    color = Colors.yellow;
  } else if (sr < 50.00) {
    color = Colors.lightGreen;
  } else if (sr < 60.00) {
    color = Colors.green;
  } else if (sr < 80) {
    color = Colors.green[800]!;
  } else {
    color = Colors.cyan;
  }
  return color;
}

Widget averageProblemRatingAndSuccessRate(
  String overallAverageTag,
  String overallAverage,
  String recentAverageTag,
  String recentAverage,
  bool inPercentage,
  bool isNarrow,
  double medium,
) {
  String first = overallAverage;
  String second = recentAverage;
  Color firstColor = Colors.white;
  Color secondColor = Colors.white;
  if (inPercentage) {
    firstColor = getSuccessrateColor(first);
    secondColor = getSuccessrateColor(second);
    first = "$first%";
    second = "$second%";
  } else {
    // The data is about rating
    firstColor = getCFColor(int.parse(first));
    secondColor = getCFColor(int.parse(second));
  }

  const double boxWidth = 260;
  const double gap = 16;

  Widget buildInfoBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: isNarrow ? 32 : 44,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  final Widget overallBox = buildInfoBox(overallAverageTag, first, firstColor);
  final Widget recentBox = buildInfoBox(recentAverageTag, second, secondColor);
  // medium = 1.5 -> Tablet mode, 1.0 -> Mobile
  if (isNarrow && medium == 1.0) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: boxWidth, child: overallBox),
          const SizedBox(height: gap),
          SizedBox(width: boxWidth, child: recentBox),
          const SizedBox(height: gap),
        ],
      ),
    );
  }

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: overallBox,
                ),
              ),

              const SizedBox(width: gap),

              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: recentBox,
                ),
              ),
            ],
          ),
          const SizedBox(height: gap),
        ],
      ),
    ),
  );
}
