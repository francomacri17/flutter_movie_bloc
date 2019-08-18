import 'dart:convert';

import 'package:flutter_movie_bloc/models/movie_item.dart';
import 'package:http/http.dart';

class MovieApiProvider{
  Client http = new Client();
  final _baseURL = 'https://api.themoviedb.org/3';
  final _apiKey = '9d728bea0819f32d83abe358a283c223';

  Future<MovieItem> GetPopularMovies() async {
    final response = await http.get('${_baseURL}/movie/popular?api_key=$_apiKey');

    if(response.statusCode == 200){
      return MovieItem.fromJson(json.decode(response.body));
    }else{
      throw Exception('Ocurrio un error inesperado');
    }
  }
}