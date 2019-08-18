import 'package:flutter_movie_bloc/models/movie_item.dart';

import 'movie_api_provider.dart';

class MovieRepository{
  final movieApiProvider = new MovieApiProvider();

  Future<MovieItem> GetPopularMovies() => movieApiProvider.GetPopularMovies();
}