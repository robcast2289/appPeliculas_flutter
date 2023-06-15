import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];
  List<Movie> onSearchMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider () {
    getOnDisplayMovies();
    getOnPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
      {
        'api_key':_apiKey,
        'language':_language,
        'page':'$page'
      }
    );
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {    
    final response = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromRawJson(response);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getOnPopularMovies() async {

    _popularPage++;

    final response = await _getJsonData('3/movie/popular',_popularPage);
    final popularResponse = PopularResponse.fromRawJson(response);
    onPopularMovies = [...onPopularMovies,...popularResponse.results];
    notifyListeners();
  }


  Future<List<Cast>> getMovieCast(int movieId) async {
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    print('Pidiendo Id');

    final response = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromRawJson(response);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;

  }

  Future<List<Movie>> searchMovies(String query, [int page = 1]) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
      {
        'api_key':_apiKey,
        'language':_language,
        'page':'$page',
        'query':query
      }
    );
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromRawJson(response.body);
    //onSearchMovies = searchResponse.results;
    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300),(_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((value) => timer.cancel());
  }

}