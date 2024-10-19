import 'package:demo/content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo/services.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          final favoriteMovies = movieProvider.favoriteMovies;

          if (favoriteMovies.isEmpty) {
            return const Center(
              child: Text(
                'No favorite movies added yet.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display two movies per row
                childAspectRatio:
                    0.7, // Adjust the aspect ratio of each grid item
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];

                return GestureDetector(
                  onTap: () {
                    movieProvider.setSelectedMovie(movie);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Content(),
                      ),
                    );
                  },
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        movie.name!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () {
                          movieProvider.toggleFavorite(movie);
                        },
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: movie.image != null
                          ? Image.network(
                              movie.image!.original!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.movie,
                                  color: Colors.white,
                                  size: 50,
                                );
                              },
                            )
                          : const Icon(
                              Icons.movie,
                              color: Colors.white,
                              size: 50,
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
