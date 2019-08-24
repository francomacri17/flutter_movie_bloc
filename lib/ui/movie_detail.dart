import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_bloc/blocs/movie_detail_bloc.dart';
import 'package:flutter_movie_bloc/models/trailer_item.dart';
import 'package:flutter_movie_bloc/resources/movie_detail_bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final String title;
  final int movieId;
  final description;
  final releaseDate;
  final double voteAverage;
  final posterUrl;

  MovieDetail(
      {this.title,
      this.movieId,
      this.description,
      this.releaseDate,
      this.voteAverage,
      this.posterUrl});

  @override
  _MovieDetailState createState() => _MovieDetailState(
      title: title,
      movieId: movieId,
      description: description,
      releaseDate: releaseDate,
      voteAverage: voteAverage,
      posterUrl: posterUrl);
}

class _MovieDetailState extends State<MovieDetail> {
  MovieDetailBloc bloc;
  final String title;
  final int movieId;
  final description;
  final releaseDate;
  final double voteAverage;
  final posterUrl;

  _MovieDetailState(
      {this.title,
      this.movieId,
      this.description,
      this.releaseDate,
      this.voteAverage,
      this.posterUrl});

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = MovieDetailBlocProvider.of(context);
    bloc.getMovieTrailersById(movieId);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  elevation: 0.0,
                  floating: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      'https://image.tmdb.org/t/p/w500${posterUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ];
            },
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.00),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Colors.black45,
                      ),
                      Text(voteAverage.toString(),
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black45)),
                      Container(
                        margin: EdgeInsets.only(left: 10.00),
                      ),
                      Text(
                        releaseDate.toString(),
                        style: TextStyle(
                            fontSize: 18.0, fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.00),
                  ),
                  Text(description),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                  ),
                  Text(
                    'Trailers',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder(
                      stream: bloc.movieTrailers,
                      builder: (context, AsyncSnapshot<TrailerItem> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.results.length > 0) {
                            return trailerLayout(snapshot.data);
                          } else {
                            return noTrailer(snapshot.data);
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                ],
              ),
            )),
      ),
    );
  }

  Widget trailerLayout(TrailerItem data) {
    if (data.results.length > 1) {
      return Row(
        children: <Widget>[
          trailerItemLayout(data, 0),
          trailerItemLayout(data, 1)
        ],
      );
    } else {
      trailerItemLayout(data, 0);
    }
  }

  Widget noTrailer(TrailerItem data) {
    return Center(
        child: Text(
      'No hay trailers disponibles',
    ));
  }

  trailerItemLayout(TrailerItem data, int i) {
    return Expanded(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          height: 100.0,
          color: Colors.grey,
          child: Center(
            child: IconButton(
                icon: Icon(Icons.play_circle_filled),
                onPressed: () {
                  _watchVideo(data.results[i].key, data.results[i].site);
                }),
          ),
        ),
        Text(
          data.results[i].name,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        Container(
          margin: EdgeInsets.only(top: 10.00),
        ),
        StreamBuilder(
            stream: bloc.movieTrailers,
            builder: (context, AsyncSnapshot<TrailerItem> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.results.length > 0) {
                  return trailerLayout(snapshot.data);
                } else {
                  return noTrailer(snapshot.data);
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    ));
  }

  Future _watchVideo(String key, String site) async {
    String baseURL = '';
    if (site == 'YouTube') {
      baseURL = 'https://www.youtube.com/watch?v=';
    } else {
      baseURL = 'https://vimeo.com/';
    }

    String url = baseURL + key;

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw ('No se ha podido abrir la url');
    }
  }
}
