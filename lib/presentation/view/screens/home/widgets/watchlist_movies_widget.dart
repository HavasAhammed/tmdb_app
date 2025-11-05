import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';
import 'package:tmdb_app/presentation/view/screens/details/movie_details_screen.dart';
import 'package:tmdb_app/presentation/view/widgets/movie_card.dart';

class WatchlistMoviesWidget extends StatelessWidget {
  final double height;
  final int itemCount;

  const WatchlistMoviesWidget({
    super.key,
    this.height = 200,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        if (provider.isWatchListLoading) {
          return SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final movies = provider.watchListMovies;

        if (movies.isEmpty) {
          return SizedBox(
            height: height,
            child: Center(
              child: Text(
                'No watchlist movies',
                style: AppTextStyle.appText14Regular,
              ),
            ),
          );
        }

        return SizedBox(
          height: height,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(itemCount).length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                type: MovieCardType.watchlist,
                height: height,
                width: 140,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsScreen(
                      movie: movie,
                      fromCardType: MovieCardType.watchlist,
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
