// import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';
// import 'package:tmdb_app/core/network/api_service.dart';
// import 'package:tmdb_app/data/services/movie_service.dart';
// import 'package:tmdb_app/presentation/providers/movie_provider.dart';

// class Providers {
//   static List<SingleChildWidget> get providers => [
//     Provider<ApiService>(create: (_) => ApiService()),
//     Provider<MovieService>(
//       create: (context) => MovieService(apiService: context.read<ApiService>()),
//     ),
//     ChangeNotifierProvider<MovieProvider>(
//       create: (context) =>
//           MovieProvider(movieService: context.read<MovieService>()),
//     ),
//   ];
// }

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tmdb_app/presentation/providers/cast_provider.dart';
import 'package:tmdb_app/presentation/providers/movie_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider.value(value: MovieProvider()),
  ChangeNotifierProvider.value(value: CastProvider()),
];
