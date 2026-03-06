import 'package:flutter/material.dart';
import 'package:pilem/services/api_services.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/widget/movie_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices apiServices = ApiServices();

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovie = [];
  List<Movie> _popularMovie = [];

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> allMoviesData = await apiServices.getAllMovies();
    final List<Map<String, dynamic>> trendingMoviesData = await apiServices.getTrendingMovies();
    final List<Map<String, dynamic>> popularMoviesData = await apiServices.getPopularMovies();

    setState(() {
      _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovie = trendingMoviesData.map((e) => Movie.fromJson(e)).toList();
      _popularMovie = popularMoviesData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film'),
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieList(title: "All Movies", movies: _allMovies),
            MovieList(title: "Trending Movies", movies: _trendingMovie),
            MovieList(title: "Popular Movies", movies: _popularMovie),
          ],
        ),
      ),
    );
  }
}