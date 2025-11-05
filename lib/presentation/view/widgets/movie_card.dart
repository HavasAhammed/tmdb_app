import 'package:flutter/material.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/core/theme/app_theme.dart';
import 'package:tmdb_app/data/models/movie/movie.dart';

enum MovieCardType {
  favorite, // Carousel style
  watchlist, // Horizontal list with gradient
  topRated, // Grid style with container
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final MovieCardType type;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.type,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MovieCardType.favorite:
        return _buildFavoriteCard();
      case MovieCardType.watchlist:
        return _buildWatchlistCard();
      case MovieCardType.topRated:
        return _buildTopRatedCard();
    }
  }

  Widget _buildFavoriteCard() {
    final poster = movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'movie_${movie.id}_${type.name}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: width ?? 200,
            height: height ?? 300,
            child: poster != null
                ? Image.network(
                    poster,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (c, e, st) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 48),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildWatchlistCard() {
    final poster = movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w342${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'movie_${movie.id}_${type.name}',
        child: SizedBox(
          width: width ?? 140,
          height: height ?? 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                poster != null
                    ? Image.network(
                        poster,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, st) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie),
                      ),
                // Gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.title ?? 'Untitled',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.appText12Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              movie.voteAverage?.toStringAsFixed(1) ?? '0.0',
                              style: AppTextStyle.appText12Bold.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRatedCard() {
    final poster = movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w342${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'movie_${movie.id}_${type.name}',
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: poster != null
                    ? Image.network(
                        poster,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, st) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? 'Untitled',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.appText14Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          movie.voteAverage?.toStringAsFixed(1) ?? '0.0',
                          style: AppTextStyle.appText12Regular.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
