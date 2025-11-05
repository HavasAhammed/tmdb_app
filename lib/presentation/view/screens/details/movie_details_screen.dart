import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/core/theme/app_theme.dart';
import 'package:tmdb_app/data/models/movie/movie.dart';
import 'package:tmdb_app/presentation/providers/cast_provider.dart';
import 'package:tmdb_app/presentation/view/widgets/cast_card.dart';
import 'package:tmdb_app/presentation/view/widgets/movie_card.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  final MovieCardType fromCardType;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
    required this.fromCardType,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isFavorite = false;
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final id = widget.movie.id ?? 0;
      await Provider.of<CastProvider>(
        context,
        listen: false,
      ).getAllMovieCredits(context, movieId: id);
    });
  }

  // CLEANUP: clear credits when leaving details screen
  @override
  void dispose() {
    try {
      context.read<CastProvider>().clear();
    } catch (_) {}
    super.dispose();
  }

  void _showCenteredSnackBar(String message, {Color? background}) {
    final mq = MediaQuery.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        backgroundColor: background ?? AppTheme.primaryGreen,
        margin: EdgeInsets.symmetric(
          horizontal: mq.size.width * 0.18,
          vertical: 20,
        ),
      ),
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    _showCenteredSnackBar(
      _isFavorite ? 'Added to favorites' : 'Removed from favorites',
      background: _isFavorite ? AppTheme.primaryGreen : Colors.black87,
    );
  }

  void _toggleWatchlist() {
    setState(() => _isInWatchlist = !_isInWatchlist);
    _showCenteredSnackBar(
      _isInWatchlist ? 'Added to Watchlist' : 'Removed from Watchlist',
      background: _isInWatchlist ? AppTheme.primaryGreen : Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieHeader(),
            _buildOverviewSection(),
            _buildCastSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieHeader() {
    final posterUrl = widget.movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}'
        : null;

    return Hero(
      tag: 'movie_${widget.movie.id}_${widget.fromCardType.name}',
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(color: AppTheme.darkBlue),
        child: Stack(
          children: [
            if (posterUrl != null)
              Image.network(
                posterUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.movie.title ?? '',
                          style: AppTextStyle.appText24Bold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Rating row (vote average + vote count)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    (widget.movie.voteAverage != null)
                                        ? (widget.movie.voteAverage!
                                              .toStringAsFixed(1))
                                        : '0.0',
                                    style: AppTextStyle.appText12Regular
                                        .copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${widget.movie.voteCount ?? 0})',
                                    style: AppTextStyle.appText12Regular
                                        .copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _toggleFavorite,
                        iconSize: 28,
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite
                              ? AppTheme.primaryGreen
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _toggleWatchlist,
                        iconSize: 28,
                        icon: Icon(
                          _isInWatchlist
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: _isInWatchlist
                              ? AppTheme.primaryGreen
                              : Colors.white,
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
    );
  }

  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: AppTextStyle.appText20Bold),
          const SizedBox(height: 8),
          Text(
            widget.movie.overview ?? 'No overview available',
            style: AppTextStyle.appText14Regular,
          ),
        ],
      ),
    );
  }

  // CLEAN: cast section styled like other movie tiles with gradient and overlay
  Widget _buildCastSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cast', style: AppTextStyle.appText20Bold),
          const SizedBox(height: 12),
          Consumer<CastProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (provider.error != null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      provider.error!,
                      style: AppTextStyle.appText14Regular,
                    ),
                  ),
                );
              }

              final cast = provider.credits?.cast ?? [];
              if (cast.isEmpty) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: Text('No cast information available')),
                );
              }

              return SizedBox(
                height: 160,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return CastCard(
                      actor: cast[index],
                      onTap: () {
                        // Optional: Navigate to actor details screen
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
