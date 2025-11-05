import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';
import 'package:tmdb_app/presentation/view/screens/details/movie_details_screen.dart';
import 'package:tmdb_app/presentation/view/widgets/movie_card.dart';

class TopRatedMoviesWidget extends StatelessWidget {
  final double gridChildAspectRatio;
  final int crossAxisCount;
  final int itemCount;

  const TopRatedMoviesWidget({
    super.key,
    this.gridChildAspectRatio = 0.66,
    this.crossAxisCount = 2,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, _) {
        if (provider.isTopRatedLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final topRated = provider.topRatedMovies;

        if (topRated.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No top rated movies',
              style: AppTextStyle.appText14Regular,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: topRated.take(itemCount).length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: gridChildAspectRatio,
          ),
          itemBuilder: (context, index) {
            final movie = topRated[index];
            return MovieCard(
              movie: movie,
              type: MovieCardType.topRated,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(
                    movie: movie,
                    fromCardType: MovieCardType.topRated,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
