import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_bloc/blocs/movies_bloc.dart';
import 'package:flutter_movie_bloc/models/movie_item.dart';
import 'package:flutter_movie_bloc/resources/movie_detail_bloc_provider.dart';

import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  MoviesBloc movieBloc;

  @override
  void initState() {
    super.initState();
    movieBloc = new MoviesBloc();
    movieBloc.getPopularMovies();
  }

  @override
  void dispose() {
    super.dispose();
    movieBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
          stream: movieBloc.popularMovies,
          builder: (context, AsyncSnapshot<MovieItem> snapshot) {
            if (snapshot.hasData) {
              return buildMovieList(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget buildMovieList(AsyncSnapshot<MovieItem> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data.results.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.7),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
              child: InkResponse(
            enableFeedback: true,
            child: Image.network(
                'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].posterPath}',
                fit: BoxFit.cover),
            onTap: () => openDetailMovie(snapshot.data, index),
          ));
        });
  }

  openDetailMovie(MovieItem data, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieDetailBlocProvider(
          child: MovieDetail(
              title: data.results[index].title,
              movieId: data.results[index].id,
              description: data.results[index].overview,
              releaseDate: data.results[index].releaseDate,
              voteAverage: data.results[index].voteAverage,
              posterUrl: data.results[index].posterPath));
    }));
  }
}
