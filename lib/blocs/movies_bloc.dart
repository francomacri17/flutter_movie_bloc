import 'package:flutter_movie_bloc/models/movie_item.dart';
import 'package:flutter_movie_bloc/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc{
  final _movieRepository = MovieRepository();
  final _movies = PublishSubject<MovieItem>();

  Observable<MovieItem> get popularMovies => _movies.stream;

  // Get popular movies
  getPopularMovies() async{
    MovieItem movieItem = await _movieRepository.getPopularMovies();
    _movies.sink.add(movieItem);
  }

  // free data memory
  dispose(){
    _movies.close();
  }
}