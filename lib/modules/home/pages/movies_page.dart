import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/router/pages_name.dart';
import 'package:mediafy/shared/widgets/base_state.dart';
import 'package:mediafy/shared/widgets/loadingMoviesTvShows.dart';
import 'package:mediafy/shared/widgets/poster.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final AppCubit _bloc = AppCubit();

  @override
  void initState() {
    super.initState();
    _bloc.goToMoviesPage();
  }

  @override
  Widget build(BuildContext context) {
    return BaseState(
      refresh: () async {
        _bloc.goToMoviesPage(refresh: true);
      },
      body: BlocBuilder<AppCubit, CubitStates>(
          bloc: _bloc,
          builder: (context, state) {
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
                    await _bloc.goToMoviesPage(refresh: true);
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
                                            Modular.to.pushNamed(PagesName.movie, arguments: trendingMovie.id);
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
                                            Modular.to.pushNamed(PagesName.movie, arguments: topRatedMovie.id);
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
                                            Modular.to.pushNamed(PagesName.movie, arguments: upcomingMovie.id);
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
              return const Center(
                child: Text("Movies Page"),
              );
            }
          }),
    );
  }
}
