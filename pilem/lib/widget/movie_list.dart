import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';

class MovieList extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const MovieList({
    super.key,
    required this.title,
    required this.movies,
  });
  

  @override
  Widget build(BuildContext context) {
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
                    Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
