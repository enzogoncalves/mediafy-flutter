import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/components/loadingMoviesTvShows.dart';
import 'package:mediafy/components/poster.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, CubitStates>(builder: (context, state) {
      if (state is MoviesState) {
        double posterHeight = 180;
        List<Movie> trendingMovies = state.trendingMovies;
        List<Movie> topRatedMovies = state.topRatedMovies;
        List<Movie> upcomingMovies = state.upcomingMovies;
        MediaFunctions mediaFunctions = MediaFunctions();
        bool hasData = state.hasData;

        if (hasData) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AppCubit>().goToMoviesPage();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: ListView(
                children: [
                  // Trending Movies
                  Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Trending Movies",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.local_fire_department_outlined,
                            color: Colors.orange,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingMovies.length,
                          itemBuilder: (context, index) {
                            Movie trendingMovie = trendingMovies[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<AppCubit>(context).showMoviePage(trendingMovie.id!);
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                    },
                                    child: Poster(height: posterHeight, posterPath: trendingMovie.poster_path)),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  width: posterHeight / 1.5,
                                  child: Text(
                                    trendingMovie.original_title!,
                                    style: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Top Rated Movies
                  Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Top Rated Movies",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topRatedMovies.length,
                          itemBuilder: (context, index) {
                            Movie topRatedMovie = topRatedMovies[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<AppCubit>(context).showMoviePage(topRatedMovie.id!);
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                    },
                                    child: Poster(height: posterHeight, posterPath: topRatedMovie.poster_path)),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  width: posterHeight / 1.5,
                                  child: Text(
                                    topRatedMovie.original_title!,
                                    style: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // Upcoming Movies
                  Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Upcoming Movies",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.access_time,
                            color: Colors.orange,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingMovies.length,
                          itemBuilder: (context, index) {
                            Movie upcomingMovie = upcomingMovies[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<AppCubit>(context).showMoviePage(upcomingMovie.id!);
                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                    },
                                    child: Poster(height: posterHeight, posterPath: upcomingMovie.poster_path)),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  width: posterHeight / 1.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        upcomingMovie.original_title!,
                                        style: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(
                                        mediaFunctions.transformReleaseDate(upcomingMovie.release_date!),
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const LoadingMoviesTvShows(itemCount: 3);
        }
      } else {
        return Container();
      }
    });
  }
}
