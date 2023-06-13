import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider () {
    getOnDisplayMovies();
    getOnPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint,
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


}