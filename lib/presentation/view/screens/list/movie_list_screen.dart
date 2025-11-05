import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/core/theme/app_theme.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';
import 'package:tmdb_app/presentation/view/screens/details/movie_details_screen.dart';
import 'package:tmdb_app/presentation/view/widgets/movie_card.dart';

enum MovieListType { topRated, nowPlaying }

class MovieListScreen extends StatefulWidget {
  final String title;
  final MovieListType listType;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.listType,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (widget.listType == MovieListType.topRated) {
        await context.read<MovieProvider>().getAllTopRatedMovies(
          context,
          page: page,
        );
      } else {
        await context.read<MovieProvider>().getAllWatchListMovies(
          context,
          page: page,
        );
      }
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      setState(() {
        page++;
      });
      if (widget.listType == MovieListType.topRated) {
        context.read<MovieProvider>().getAllTopRatedMovies(context, page: page);
      } else {
        context.read<MovieProvider>().getAllWatchListMovies(
          context,
          page: page,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: AppTextStyle.appText20Bold.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.darkBlue,
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          final movies = widget.listType == MovieListType.topRated
              ? provider.topRatedMovies
              : provider.watchListMovies;

          final isLoading = widget.listType == MovieListType.topRated
              ? provider.isTopRatedLoading
              : provider.isWatchListLoading;

          if (movies.isEmpty && isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (movies.isEmpty) {
            return Center(
              child: Text(
                'No ${widget.listType == MovieListType.topRated ? 'top rated' : 'watchlist'} movies found.',
                style: AppTextStyle.appText14Regular,
              ),
            );
          }

          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.66,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: movies.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final movie = movies[index];
              return MovieCard(
                movie: movie,
                type: widget.listType == MovieListType.topRated
                    ? MovieCardType.topRated
                    : MovieCardType.watchlist,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailsScreen(
                      movie: movie,
                      fromCardType: widget.listType == MovieListType.topRated
                          ? MovieCardType.topRated
                          : MovieCardType.watchlist,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
