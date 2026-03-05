import 'package:flutter/material.dart';
import 'package:pilem/services/api_services.dart';
import 'package:pilem/models/movie.dart';

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
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieList("All Movies", _allMovies),
            _buildMovieList("Trending Movies", _trendingMovie),
            _buildMovieList("Popular Movies", _popularMovie),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network("https://image.tmdb.org/t/p/w500${movie.posterPath}",
                    width: 100, height: 150, fit: BoxFit.cover
                    ),

                    SizedBox(height: 5),
                    Text(movie.title, style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)
                  ],
                )
              );
            },
          ),
        )
      ],
    );
  }
}