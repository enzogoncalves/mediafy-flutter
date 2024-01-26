import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/router/pages_name.dart';
import 'package:mediafy/shared/widgets/base_state.dart';
import 'package:mediafy/shared/widgets/loadingMedia.dart';
import 'package:mediafy/shared/widgets/mediaDetails.dart';
import 'package:mediafy/shared/widgets/noCastProfilePath.dart';
import 'package:mediafy/shared/widgets/poster.dart';
import 'package:mediafy/shared/widgets/title_large.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key, required this.movieId});

  final int movieId;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final AppCubit _bloc = AppCubit();

  @override
  void initState() {
    super.initState();
    _bloc.showMoviePage(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseState(
      refresh: () async {
        _bloc.showMoviePage(widget.movieId);
      },
      body: SafeArea(
          child: BlocBuilder<AppCubit, CubitStates>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is MovieState) {
            MovieDetails movie = state.details;
            List<Cast> cast = state.cast;
            List<Crew> crew = state.crew;
            List<Keyword> keywords = state.keywords;
            List<Movie> recommendations = state.recommendations;
            MediaFunctions mediaFunctions = MediaFunctions();

            return Scaffold(
                appBar: AppBar(
                    title: Text(
                      movie.original_title!,
                    ),
                    centerTitle: true,
                    backgroundColor: AppColors.mainColor,
                    foregroundColor: Colors.white,
                    leading: IconButton(
                        onPressed: () {
                          Modular.to.pop();
                          _bloc.popToPreviousMovie();
                        },
                        icon: const Icon(Icons.arrow_back))),
                backgroundColor: AppColors.mainColor,
                body: ListView(
                  children: [
                    Stack(
                      children: [
                        // Backdrop image with blur and a blue background with some opacity
                        Stack(
                          children: [
                            Container(
                              height: 384,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage("https://image.tmdb.org/t/p/original${movie.backdrop_path}"),
                                opacity: .4,
                                fit: BoxFit.cover,
                              )),
                            ),
                            SizedBox(
                              height: 384,
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  color: Colors.blue[900]!.withOpacity(.1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Principal informations about the movie
                        Container(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Poster(posterPath: movie.poster_path, height: 192, width: 128),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            movie.title!,
                                            style: const TextStyle(overflow: TextOverflow.clip, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "(${movie.release_date!.substring(0, 4)})",
                                            style: const TextStyle(color: Colors.grey, fontSize: 20),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Wrap(
                                  children: [
                                    Text(
                                      mediaFunctions.formatDate(movie.release_date!)["date"],
                                      style: const TextStyle(color: Colors.white),
                                    ),

                                    const SizedBox(
                                      width: 16,
                                    ),

                                    Wrap(
                                      children: mediaFunctions.formatGenres(movie.genres).split('').map((genre) {
                                        return Text(
                                          genre,
                                          style: const TextStyle(color: Colors.white),
                                        );
                                      }).toList(),
                                    ),

                                    // Text(
                                    //   movie.formatGenres(movie.genres),
                                    //   style: const TextStyle(
                                    //     color: Colors.white
                                    //   ),
                                    // ),

                                    const SizedBox(
                                      width: 16,
                                    ),

                                    Text(
                                      mediaFunctions.formatMediaDuration(movie.runtime),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                movie.tagline!.isNotEmpty
                                    ? Column(
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            movie.tagline!,
                                            style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TitleLarge("Synopse"),
                                    Text(
                                      movie.overview!,
                                      style: const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: crew.getRange(0, 5).map((e) {
                                    String jobs = '';
                                    e.jobs!.forEach((element) {
                                      if (e.jobs!.indexOf(element) == e.jobs!.length - 1) {
                                        jobs += element;
                                      } else {
                                        jobs += '$element, ';
                                      }
                                    });

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(e.name!,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            jobs,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )
                              ],
                            )),
                      ],
                    ),

                    // Main Cast
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleLarge("Main Cast"),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 275,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              itemBuilder: (context, index) {
                                Cast castMember = cast[index];
                                double posterHeight = 180;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      castMember.profile_path != null
                                          ? Container(
                                              width: posterHeight / 1.5,
                                              height: posterHeight,
                                              decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("https://image.tmdb.org/t/p/w300${castMember.profile_path}"))),
                                            )
                                          : NoCastProfilePath(posterHeight: posterHeight),
                                      Container(
                                        padding: const EdgeInsets.all(2),
                                        width: posterHeight / 1.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              castMember.name!,
                                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              castMember.character!.length <= 25 ? castMember.character! : '${castMember.character!.split(' ').getRange(0, 3).join(' ')}...',
                                              style: const TextStyle(color: Colors.white, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    recommendations.isNotEmpty
                        ? const SizedBox(
                            height: 20,
                          )
                        : Container(),

                    // Movie Recommendaitions
                    recommendations.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TitleLarge("Recommendations"),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 225,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recommendations.length,
                                    itemBuilder: (context, index) {
                                      Movie movieRecommendation = recommendations[index];
                                      double posterHeight = 180;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Modular.to.pushNamed(PagesName.movie, arguments: movieRecommendation.id);
                                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                              },
                                              child: Poster(height: posterHeight, posterPath: movieRecommendation.poster_path)),
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            width: posterHeight / 1.5,
                                            child: Text(
                                              movieRecommendation.original_title!,
                                              style: const TextStyle(color: Colors.white, fontSize: 14, overflow: TextOverflow.ellipsis),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),

                    // Details
                    Padding(
                      padding: const EdgeInsets.only(right: 4, bottom: 4, left: 4),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaDetail(header: "Status", data: movie.status!),
                            const SizedBox(
                              height: 16,
                            ),
                            MediaDetail(header: "Original Language", data: movie.original_language!),
                            const SizedBox(
                              height: 16,
                            ),
                            MediaDetail(header: "Budget", data: '\$${NumberFormat.decimalPattern('de-DE').format(movie.budget!).toString()}'),
                            const SizedBox(
                              height: 16,
                            ),
                            MediaDetail(header: "Revenue", data: '\$${NumberFormat.decimalPattern('de-DE').format(movie.revenue!).toString()}'),
                            keywords.isNotEmpty
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      const Text(
                                        "KeyWords",
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: keywords.map((e) {
                                          return Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(4)),
                                            child: Text(
                                              e.name,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    )
                  ],
                ));
          } else {
            return const LoadingMedia();
          }
        },
      )),
    );
  }
}
