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

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  final AppCubit _bloc = AppCubit();

  @override
  void initState() {
    super.initState();
    _bloc.goToTvSeriesPage();
  }

  @override
  Widget build(BuildContext context) {
    return BaseState(
      refresh: () async {
        _bloc.goToTvSeriesPage(refresh: true);
      },
      body: BlocBuilder<AppCubit, CubitStates>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is TvShowsState) {
              double posterHeight = 180;
              List<TvShow> trendingTvShows = state.trendingTvShows;
              List<TvShow> topRatedTvShows = state.topRatedTvShows;
              bool hasData = state.hasData;

              if (hasData) {
                return RefreshIndicator(
                  onRefresh: () async {
                    _bloc.goToTvSeriesPage(refresh: true);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: ListView(
                      children: [
                        // Trending TvShows
                        Column(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Trending TvShows",
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
                                itemCount: trendingTvShows.length,
                                itemBuilder: (context, index) {
                                  TvShow trendingTvShow = trendingTvShows[index];

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Modular.to.pushNamed(PagesName.tvShow, arguments: trendingTvShow.id);
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                          },
                                          child: Poster(height: posterHeight, posterPath: trendingTvShow.poster_path)),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        width: posterHeight / 1.5,
                                        child: Text(
                                          trendingTvShow.name!,
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

                        // Top Rated TvShows
                        Column(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Top Rated TvShows",
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
                                itemCount: topRatedTvShows.length,
                                itemBuilder: (context, index) {
                                  TvShow topRatedTvShow = topRatedTvShows[index];

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Modular.to.pushNamed(PagesName.tvShow, arguments: topRatedTvShow.id);
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                          },
                                          child: Poster(height: posterHeight, posterPath: topRatedTvShow.poster_path)),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        width: posterHeight / 1.5,
                                        child: Text(
                                          topRatedTvShow.name!,
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
                      ],
                    ),
                  ),
                );
              } else {
                return const LoadingMoviesTvShows(itemCount: 2);
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
