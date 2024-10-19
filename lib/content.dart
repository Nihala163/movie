import 'package:demo/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            final movie = movieProvider.selectedMovie;
            return Text(
              movie?.name ?? 'Movie Details',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          final movie = movieProvider.selectedMovie;
          final cast = movieProvider.cast;

          if (movie == null || movie.image == null) {
            return const Center(
              child: Text(
                'No movie selected',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: (movie.image != null &&
                              movie.image!.original != null &&
                              movie.image!.original!.isNotEmpty)
                          ? Image.network(
                              movie.image!.original!,
                              height: 250,
                              width: 200,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return const Placeholder(
                                  fallbackHeight: 250,
                                  fallbackWidth: 200,
                                );
                              },
                            )
                          : const Placeholder(
                              fallbackHeight: 250,
                              fallbackWidth: 200,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          movie.name!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      // Favorite icon in the body
                      IconButton(
                        icon: Icon(
                          movieProvider.isFavorite(movie)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: movieProvider.isFavorite(movie)
                              ? Colors.red
                              : Colors.white,
                        ),
                        onPressed: () {
                          movieProvider.toggleFavorite(movie);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  RatingBarIndicator(
                    rating: movie.rating?.average ?? 0.0,
                    itemCount: 5,
                    itemSize: 30.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    movie.summary!.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Cast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (cast == null) // Loading state
                    const CircularProgressIndicator()
                  else if (cast.isEmpty) // No cast available
                    const Text(
                      'No cast information available',
                      style: TextStyle(color: Colors.white),
                    )
                  else // Display cast information
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        runSpacing: 8.0,
                        spacing: 20.0,
                        children: cast.map((castMember) {
                          return Chip(
                            label: Text(castMember.person?.name ?? 'Unknown'),
                            backgroundColor: Colors.grey[800],
                            labelStyle: const TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
