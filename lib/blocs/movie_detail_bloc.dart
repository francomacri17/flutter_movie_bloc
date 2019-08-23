import 'package:flutter_movie_bloc/models/trailer_item.dart';
import 'package:flutter_movie_bloc/resources/movie_repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc{
  final _movieRepository = new MovieRepository();
  final _trailers = PublishSubject<TrailerItem>();

  Observable<TrailerItem> get movieTrailers => _trailers.stream;

  dispose(){
    _trailers.close();
  }

  getMovieTrailersById(int movieId) async {
    TrailerItem trailerItem = await _movieRepository.getMovieTrailers(movieId);
    _trailers.sink.add(trailerItem);
  }
}