import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final inherited =
    //     context.getInheritedWidgetOfExactType<LandingInherited>()!;

    return AppScaffold(
      body: Column(children: [
        RatingBar(
          ratingWidget: RatingWidget(
            empty: Icon(Icons.face),
            half: Icon(Icons.face_3),
            full: Icon(Icons.face_retouching_natural_sharp),
          ),
          onRatingUpdate: (value) {},
        )
      ]),
    );
  }
}
