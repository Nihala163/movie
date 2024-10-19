import 'package:demo/content.dart';
import 'package:demo/favoriteMovies.dart';
import 'package:demo/sepeate%20ui/movieposter.dart';
import 'package:demo/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger fetching of movies when the widget is built
    Future.microtask(
        () => Provider.of<MovieProvider>(context, listen: false).fetchMovies());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Text(
              'StreamApp',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 8.0.w), // Responsive width
              child: const Icon(
                Icons.tv,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                  ),
                  onChanged: (query) {
                    Provider.of<MovieProvider>(context, listen: false)
                        .searchMovies(query);
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritePage()),
                );
              },
              icon: const Icon(Icons.favorite, color: Colors.white),
              tooltip: 'Favorites',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list, color: Colors.white),
              tooltip: 'filter',
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Consumer<MovieProvider>(builder: (context, movieProvider, child) {
        if (movieProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Use the filteredMovies for the grid view
        final moviesToShow = movieProvider.filteredMovies;

        if (moviesToShow.isEmpty) {
          return const Center(
            child: Text(
              'No movies found.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Use LayoutBuilder for a responsive grid view
        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1200
                ? 6
                : constraints.maxWidth > 800
                    ? 4
                    : 2;

            return Padding(
              padding: EdgeInsets.all(8.0.w), // Responsive padding
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10.0.w, // Responsive spacing
                  mainAxisSpacing: 10.0.h, // Responsive spacing
                  childAspectRatio: 0.68, // Maintain poster aspect ratio
                ),
                itemCount: moviesToShow.length, // Use filtered movies count
                itemBuilder: (BuildContext context, int index) {
                  final movie = moviesToShow[index];
                  return GestureDetector(
                    onTap: () {
                      Provider.of<MovieProvider>(context, listen: false)
                          .setSelectedMovie(movie);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Content(),
                        ),
                      );
                    },
                    child: MoviePosterWidget(movie: movie),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
