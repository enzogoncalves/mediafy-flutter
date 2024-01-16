import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mediafy/components/LoadingMedia.dart';
import 'package:mediafy/components/Poster.dart';
import 'package:mediafy/components/mediaDetails.dart';
import 'package:mediafy/components/noCastProfilePath.dart';
import 'package:mediafy/components/title_large.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/models/cast_model.dart';
import 'package:mediafy/models/crew_model.dart';
import 'package:mediafy/models/keywords_model.dart';
import 'package:mediafy/models/media_functions_model.dart';
import 'dart:ui' as ui;

import 'package:mediafy/models/tvshow_model.dart';

class TvShowScreen extends StatefulWidget {
  const TvShowScreen({super.key});

  @override
  State<TvShowScreen> createState() => _TvShowScreenState();
}

class _TvShowScreenState extends State<TvShowScreen> {
  final AppColors appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    // List cast;
    return SafeArea(child: BlocBuilder<AppCubit, CubitStates>(
      builder: (context, state) {
        if (state is TvShowState) {
          TvShowDetails tvShow = state.details;
          List<Cast> cast = state.cast;
          List<Crew> crew = state.crew;
          List<Keyword> keywords = state.keywords;
          List<TvShow> recommendations = state.recommendations;
          MediaFunctions mediaFunctions = MediaFunctions();

          return Scaffold(
              appBar: AppBar(
                  title: Text(tvShow.name!),
                  centerTitle: true,
                  leading: IconButton(
                      onPressed: () {
                        BlocProvider.of<AppCubit>(context).backToPreviousTvShow();
                      },
                      icon: const Icon(Icons.arrow_back))),
              backgroundColor: appColors.mainColor,
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
                              image: NetworkImage("https://image.tmdb.org/t/p/original${tvShow.backdrop_path}"),
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
                                  Poster(posterPath: tvShow.poster_path, height: 192, width: 128),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tvShow.name!,
                                          style: const TextStyle(overflow: TextOverflow.clip, color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        tvShow.first_air_date!.isNotEmpty
                                            ? Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "(${tvShow.first_air_date!.substring(0, 4)})",
                                                    style: const TextStyle(color: Colors.grey, fontSize: 20),
                                                  )
                                                ],
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  tvShow.first_air_date!.isNotEmpty
                                      ? Text(
                                          mediaFunctions.formatDate(tvShow.first_air_date!)["date"],
                                          style: const TextStyle(color: Colors.white),
                                        )
                                      : Container(),
                                  Wrap(
                                    children: mediaFunctions.formatGenres(tvShow.genres).split('').map((genre) {
                                      return Text(
                                        genre,
                                        style: const TextStyle(color: Colors.white),
                                      );
                                    }).toList(),
                                  ),
                                  tvShow.episode_run_time!.isNotEmpty
                                      ? Text(
                                          tvShow.episode_run_time![0].toString(),
                                          style: const TextStyle(color: Colors.white),
                                        )
                                      : Container()
                                ],
                              ),
                              tvShow.tagline!.isNotEmpty
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          tvShow.tagline!,
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
                                    tvShow.overview!,
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: crew.getRange(0, crew.length >= 5 ? 5 : crew.length).map((e) {
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
                  cast.isNotEmpty
                      ? Container(
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
                        )
                      : Container(),

                  recommendations.isNotEmpty
                      ? const SizedBox(
                          height: 20,
                        )
                      : Container(),

                  // TvShow Recommendaitions
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
                                    TvShow tvShowRecommendations = recommendations[index];
                                    double posterHeight = 180;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              context.read<AppCubit>().showTvShowPage(tvShowRecommendations.id!);
                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                            },
                                            child: Poster(height: posterHeight, posterPath: tvShowRecommendations.poster_path)),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          width: posterHeight / 1.5,
                                          child: Text(
                                            tvShowRecommendations.name!,
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
                          MediaDetail(header: "Status", data: tvShow.status!),
                          const SizedBox(
                            height: 16,
                          ),
                          MediaDetail(header: "Original Language", data: tvShow.original_language!),
                          const SizedBox(
                            height: 16,
                          ),
                          MediaDetail(header: "Number of Seasons", data: tvShow.number_of_seasons.toString()),
                          const SizedBox(
                            height: 16,
                          ),
                          MediaDetail(header: "Original Name", data: tvShow.original_name!),
                          const SizedBox(
                            height: 16,
                          ),
                          MediaDetail(header: "Number of Episodes", data: tvShow.number_of_episodes.toString()),
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
        } else if (state is LoadingTvShow) {
          return const LoadingMedia();
        } else {
          return const Center(
            child: Text("Erro na tela do filme"),
          );
        }
      },
    ));
  }
}
