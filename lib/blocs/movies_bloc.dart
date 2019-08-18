import 'package:flutter_movie_bloc/models/movie_item.dart';
import 'package:flutter_movie_bloc/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc{
  final _movieRepository = MovieRepository();
  final _movies = PublishSubject();

  Observable<MovieItem> get popilarMovies => _movies.stream;

  // Get popular movies
  getPopularMovies() async{
    MovieItem movieItem = await _movieRepository.GetPopularMovies();
    _movies.sink.add(movieItem);
  }

  // free data memory
  dispose(){
    _movies.close();
  }
}