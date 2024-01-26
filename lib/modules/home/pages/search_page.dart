import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/router/pages_name.dart';
import 'package:mediafy/shared/widgets/base_state.dart';
import 'package:mediafy/shared/widgets/poster.dart';
import 'package:tmdb_api/tmdb_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final AppCubit _bloc = AppCubit();

  @override
  void initState() {
    super.initState();
    _bloc.goToSearchPage();
  }

  TextEditingController inputController = TextEditingController();

  List<String> mediaTypes = ["movie", "tv"];

  @override
  Widget build(BuildContext context) {
    return BaseState(
      refresh: () async {
        _bloc.goToSearchPage();
      },
      body: BlocBuilder<AppCubit, CubitStates>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is SearchPageState) {
            List<Movie> movies = state.movies;
            List<TvShow> tvShows = state.tvShows;
            bool hasData = state.hasData;
            String mediaTypeSelected = state.mediaType;

            inputController.text = state.query;

            return Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        // Search bar
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.search),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: inputController,
                                    onSubmitted: (value) {
                                      _bloc.searchQuery(mediaTypeSelected, value);
                                    },
                                    decoration: const InputDecoration(hintText: "Type here to search", border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Media type toggle
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: mediaTypes.map((e) {
                              return TextButton(
                                onPressed: () {
                                  setState(() {
                                    state.mediaType = e;
                                    _bloc.finalSearchPageState.mediaType = e;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: mediaTypeSelected == e ? Colors.white : Colors.transparent,
                                    fixedSize: const Size(100, 30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                    foregroundColor: mediaTypeSelected == e ? Colors.black : Colors.white,
                                    side: mediaTypeSelected == e ? BorderSide.none : const BorderSide(),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                    )),
                                child: Text('${e[0].toUpperCase()}${e.substring(1)}'),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  hasData
                      ? movies.isNotEmpty
                          ? Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: 0.9),
                                itemCount: movies.length,
                                itemBuilder: (context, index) {
                                  Movie movie = movies[index];
                                  double posterHeight = 180;

                                  return Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Modular.to.pushNamed(PagesName.movie, arguments: movie.id);
                                          },
                                          child: Poster(height: posterHeight, posterPath: movie.poster_path)),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        width: posterHeight / 1.5,
                                        child: Text(
                                          movie.original_title!,
                                          style: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          : tvShows.isNotEmpty
                              ? Expanded(
                                  child: GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: 0.9),
                                    itemCount: tvShows.length,
                                    itemBuilder: (context, index) {
                                      TvShow tvShow = tvShows[index];
                                      double posterHeight = 180;

                                      return Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Modular.to.pushNamed(PagesName.tvShow, arguments: tvShow.id);
                                              },
                                              child: Poster(height: posterHeight, posterPath: tvShow.poster_path)),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            width: posterHeight / 1.5,
                                            child: Text(
                                              tvShow.name!,
                                              style: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : WarningImages("not-found", "No data found")
                      : WarningImages("search", "Search a Movie or a Tv Show")
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget WarningImages(String image, String text) {
  return Expanded(
    child: ListView(
      children: [
        Container(margin: const EdgeInsets.only(top: 150, right: 40), child: SvgPicture.asset('assets/$image.svg', width: 200)),
        const SizedBox(
          height: 20,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}
