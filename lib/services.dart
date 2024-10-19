import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movieModel.dart';
import 'castModel.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = []; // List to hold filtered movies
  Movie? _selectedMovie;
  List<Cast>? _cast;
  bool _isLoading = false;
  List<Movie> _favoriteMovies = []; // List to hold favorite movies
  List<String> _genres = [];

  List<Movie> get movies => _movies;
  List<Movie> get filteredMovies => _filteredMovies.isNotEmpty
      ? _filteredMovies
      : _movies; // Getter for filtered movies
  Movie? get selectedMovie => _selectedMovie;
  List<Cast>? get cast => _cast;
  bool get isLoading => _isLoading;
  List<Movie> get favoriteMovies => _favoriteMovies;

  final String apiUrl1 = 'https://api.tvmaze.com/shows'; // Movie API base URL

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      var response = await http.get(Uri.parse(apiUrl1));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body) as List;
        _movies = res.map((movieJson) => Movie.fromJson(movieJson)).toList();
      } else {
        print('Failed to load movies: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch the cast based on selected movie ID
  Future<void> fetchCast(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final String apiUrl2 =
          'https://api.tvmaze.com/shows/$movieId/cast'; // Dynamic cast API based on movie ID
      var response = await http.get(Uri.parse(apiUrl2));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body) as List;
        _cast = res.map((castJson) => Cast.fromJson(castJson)).toList();
      } else {
        print('Failed to load cast: ${response.statusCode}');
        _cast = [];
      }
    } catch (error) {
      print('Error occurred: $error');
      _cast = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set the selected movie and fetch the related cast
  void setSelectedMovie(Movie movie) {
    _selectedMovie = movie;
    notifyListeners();
    fetchCast(movie.id!); // Fetch cast for the selected movie based on its ID
  }

  // Toggle favorite movie
  void toggleFavorite(Movie movie) {
    if (_favoriteMovies.contains(movie)) {
      _favoriteMovies.remove(movie);
    } else {
      _favoriteMovies.add(movie);
    }
    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.contains(movie);
  }

  List<String> get genres {
    // Create a set to avoid duplicates
    final genreSet = <String>{};
    for (var movie in _movies) {
      if (movie.genres != null) {
        genreSet.addAll(movie.genres! as Iterable<String>);
      }
    }
    _genres = genreSet.toList();
    return _genres;
  }

  // Add a method to filter movies by selected genre
  List<Movie> getMoviesByGenre(String genre) {
    return _movies.where((movie) {
      return movie.genres != null && movie.genres!.contains(genre);
    }).toList();
  }

  // Search movies by name
  void searchMovies(String query) {
    if (query.isEmpty) {
      _filteredMovies = []; // Reset to show all movies when search is cleared
    } else {
      _filteredMovies = _movies
          .where((movie) =>
              movie.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify listeners about the change
  }
}
