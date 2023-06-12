import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {

  String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'en-US';

  List<Movie> onDisplayMovies = [];

  MoviesProvider () {
    print('MOvies  provider inicializado');
    this.getOnDisplayMovies();
  }

  getOnDisplayMovies() async {
    var url = Uri.https(_baseUrl,'3/movie/now_playing',
      {
        'api_key':_apiKey,
        'language':_language,
        'page':'1'
      }
    );
    print(url);
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(response.body);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }


}