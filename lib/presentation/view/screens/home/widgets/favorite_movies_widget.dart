import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';
import 'package:tmdb_app/presentation/view/screens/details/movie_details_screen.dart';
import 'package:tmdb_app/presentation/view/widgets/movie_card.dart';

class FavoriteMoviesWidget extends StatelessWidget {
  final double height;
  final double viewportFraction;

  const FavoriteMoviesWidget({
    super.key,
    this.height = 300,
    this.viewportFraction = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        if (provider.isFavoritesLoading) {
          return SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final favorites = provider.favoriteMovies;

        if (favorites.isEmpty) {
          return SizedBox(
            height: height,
            child: Center(
              child: Text(
                'No movies available',
                style: AppTextStyle.appText14Regular,
              ),
            ),
          );
        }

        return SizedBox(
          height: height,
          child: CarouselSlider.builder(
            itemCount: favorites.length,
            options: CarouselOptions(
              height: height,
              autoPlay: true,
              viewportFraction: viewportFraction,
              enlargeCenterPage: true,
              pageSnapping: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(seconds: 2),
            ),
            itemBuilder: (context, index, realIdx) {
              final movie = favorites[index];
              return MovieCard(
                movie: movie,
                type: MovieCardType.favorite,
                height: height,
                width: 200,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsScreen(
                      movie: movie,
                      fromCardType: MovieCardType.favorite,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
