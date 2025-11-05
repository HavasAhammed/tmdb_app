import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/core/constants/height_and_width.dart';
import 'package:tmdb_app/core/theme/app_theme.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';
import 'package:tmdb_app/presentation/view/screens/details/movie_details_screen.dart';
import 'package:tmdb_app/presentation/view/screens/home/widgets/movies_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // fetch after first frame so providers are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchPopularMovies();
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
            color: Colors.white, // ensure non-transparent pixels for the mask
            height: 30,
          ),
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, _) {
          final favoriteMovies = movieProvider.movies;
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Favorite Movies",
                  style: AppTextStyle.appText17Bold,
                ),
              ),
              kHeight(16),
              SizedBox(
                width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: favoriteMovies.length,
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    viewportFraction: 0.55,
                    enlargeCenterPage: true,
                    pageSnapping: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: Duration(seconds: 2),
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onTap: () {
                          // Handle movie tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movie: favoriteMovies[index],
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 200,
                          height: 300,
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${favoriteMovies[index].posterPath ?? ''}',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              kHeight(24),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Top Rated Movies",
                  style: AppTextStyle.appText17Bold,
                ),
              ),
              kHeight(12),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Movie ${index + 1}",
                        style: AppTextStyle.appText14Bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              kHeight(32),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Watchlist Movies",
                  style: AppTextStyle.appText17Bold,
                ),
              ),
              kHeight(12),
              MoviesSlider(),
            ],
          );
        },
      ),
      // body: Consumer<MovieProvider>(
      //   builder: (context, provider, _) {
      //     if (provider.isLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (provider.error != null) {
      //       return Center(child: Text(provider.error!));
      //     }
      //     final List<Movie> movies = provider.movies;
      //     if (movies.isEmpty) {
      //       return RefreshIndicator(
      //         onRefresh: provider.refresh,
      //         child: ListView(
      //           children: const [
      //             SizedBox(height: 200),
      //             Center(child: Text('No movies')),
      //           ],
      //         ),
      //       );
      //     }
      //     return RefreshIndicator(
      //       onRefresh: provider.refresh,
      //       child: ListView.builder(
      //         itemCount: movies.length,
      //         itemBuilder: (context, index) {
      //           final movie = movies[index];
      //           final poster = movie.posterPath != null
      //               ? 'https://image.tmdb.org/t/p/w92${movie.posterPath}'
      //               : null;
      //           return ListTile(
      //             leading: poster != null
      //                 ? Image.network(poster, width: 50, fit: BoxFit.cover)
      //                 : const SizedBox(width: 50, child: Icon(Icons.movie)),
      //             title: Text(movie.title ?? 'Untitled'),
      //             subtitle: Text(
      //               movie.overview ?? '',
      //               maxLines: 2,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
