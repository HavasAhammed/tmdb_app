import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/core/theme/app_theme.dart';
import 'package:tmdb_app/data/models/movie/movie.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isFavorite = false;
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovieCredits(widget.movie.id ?? 0);
    });
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

    return Container(
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
                                  style: AppTextStyle.appText12Regular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${widget.movie.voteCount ?? 0})',
                                  style: AppTextStyle.appText12Regular.copyWith(
                                    color: Colors.white70,
                                  ),
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
                        _isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
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

  Widget _buildCastSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cast', style: AppTextStyle.appText20Bold),
          const SizedBox(height: 16),
          Consumer<MovieProvider>(
            builder: (context, provider, _) {
              if (provider.isLoadingCredits) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.creditsError != null) {
                return Center(child: Text(provider.creditsError!));
              }
              final cast = provider.movieCredits?.cast ?? [];
              if (cast.isEmpty) {
                return const Center(
                  child: Text('No cast information available'),
                );
              }
              return SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (context, index) {
                    final actor = cast[index];
                    final profileUrl = actor.profilePath != null
                        ? 'https://image.tmdb.org/t/p/w185${actor.profilePath}'
                        : null;
                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: profileUrl != null
                                ? Image.network(
                                    profileUrl,
                                    height: 120,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 120,
                                    width: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person),
                                  ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            actor.name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.appText12Regular,
                          ),
                        ],
                      ),
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
