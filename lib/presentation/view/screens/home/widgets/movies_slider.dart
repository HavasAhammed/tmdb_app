import 'package:flutter/material.dart';
import 'package:tmdb_app/core/constants/height_and_width.dart';

class MoviesSlider extends StatelessWidget {
  const MoviesSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 12),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (context, index) => kWidth(12),
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
