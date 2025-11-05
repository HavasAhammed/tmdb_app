import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/core/constants/height_and_width.dart';
import 'package:tmdb_app/core/theme/app_theme.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';
import 'package:tmdb_app/presentation/view/screens/list/movie_list_screen.dart';
import 'package:tmdb_app/presentation/view/screens/home/widgets/top_rated_movies_widget.dart';
import 'package:tmdb_app/presentation/view/screens/home/widgets/watchlist_movies_widget.dart';
import 'package:tmdb_app/presentation/view/screens/home/widgets/favorite_movies_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<MovieProvider>(
        context,
        listen: false,
      ).getAllFavoriteMovies(context, page: 1);

      await Provider.of<MovieProvider>(
        context,
        listen: false,
      ).getAllTopRatedMovies(context, page: 1);

      await Provider.of<MovieProvider>(
        context,
        listen: false,
      ).getAllWatchListMovies(context, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.darkBlue,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF8BE9FF), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: SvgPicture.asset(
            "assets/images/tmdb_logo.svg",
            color: Colors.white,
            height: 30,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shrinkWrap: true,
        children: [
          // Favorite Movies Section
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("Favorite Movies", style: AppTextStyle.appText17Bold),
          ),
          kHeight(16),
          const FavoriteMoviesWidget(),
          kHeight(32),

          // Top Rated section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top Rated Movies", style: AppTextStyle.appText17Bold),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MovieListScreen(
                          title: 'Top Rated Movies',
                          listType: MovieListType.topRated,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: AppTextStyle.appText14Regular.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          kHeight(12),
          const TopRatedMoviesWidget(itemCount: 6),

          // Watchlist section
          kHeight(32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Watchlist Movies", style: AppTextStyle.appText17Bold),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MovieListScreen(
                          title: 'Watchlist Movies',
                          listType: MovieListType.nowPlaying,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: AppTextStyle.appText14Regular.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          kHeight(12),
          const WatchlistMoviesWidget(itemCount: 10),
        ],
      ),
    );
  }
}
