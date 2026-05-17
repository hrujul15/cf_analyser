// Util function for printing handle , rating colors correctly

import 'package:flutter/material.dart';
import 'package:cfar/services/fetch_user_data.dart';

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

Widget coloredHandle(Profile p, BuildContext context) {
  final style = Theme.of(
    context,
  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700);

  if ((p.rating ?? 0) < 3000) {
    return Text(
      p.handle ?? "N/A",
      style: style.copyWith(color: getCFColor(p.rating), fontSize: 64),
    );
  }

  return RichText(
    text: TextSpan(
      style: style, // base style
      children: [
        const TextSpan(text: ""),
        TextSpan(
          text: p.handle![0],
          style: const TextStyle(color: Colors.white, fontSize: 64),
        ),
        const TextSpan(text: ""),
        TextSpan(
          text: p.handle!.substring(1),
          style: const TextStyle(color: Colors.red, fontSize: 64),
        ),
      ],
    ),
  );
}
