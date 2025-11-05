import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tmdb_app/data/services/cast_service.dart';
import 'package:tmdb_app/data/services/movie_service.dart';

List<SingleChildWidget> chopperServices = [
  Provider(
    create: (context) => MovieService.create(),
    dispose: (_, MovieService service) => service.client.dispose(),
  ),

  Provider(
    create: (context) => CastService.create(),
    dispose: (_, CastService service) => service.client.dispose(),
  ),
];
