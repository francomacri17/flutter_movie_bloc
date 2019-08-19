import 'package:flutter_movie_bloc/models/movie_item.dart';
import 'package:flutter_movie_bloc/models/trailer_item.dart';

import 'movie_api_provider.dart';

class MovieRepository{
  final movieApiProvider = new MovieApiProvider();

  Future<MovieItem> getPopularMovies() => movieApiProvider.getPopularMovies();

  Future<TrailerItem> getMovieTrailers(int movieId) => movieApiProvider.getTrailerItem(movieId);
}