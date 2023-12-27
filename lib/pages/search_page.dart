import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediafy/components/noMediaPosterPath.dart';
import 'package:mediafy/cubit/cubit_states.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/misc/colors.dart';
import 'package:mediafy/models/movie_model.dart';
import 'package:mediafy/models/tvshow_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController inputController = TextEditingController();
  
  List<String> mediaTypes = ["movie", "tv"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, CubitStates>(
      builder: (context, state){
        if(state is SearchPageState) {
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
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    children: [
                      // Search bar
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.search),
                                              
                              const SizedBox(width: 12,),
                                              
                              Expanded(
                                child: TextField(
                                  controller: inputController,
                                  onSubmitted: (value) {
                                    context.read<AppCubit>().searchQuery(mediaTypeSelected, value);
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Type here to search",
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Media type toggle
                      Container(
                        color: Colors.blueGrey[900],
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: mediaTypes.map((e) {
                            return TextButton(
                              onPressed: () {
                                setState(() {
                                  state.mediaType = e;
                                  context.read<AppCubit>().finalSearchPageState.mediaType = e;
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
                                )
                              ),
                              child: Text('${e[0].toUpperCase()}${e.substring(1)}'),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16,),

                hasData
                ? movies.isNotEmpty 
                  ? Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: movies.map((Movie movie) {
                            double posterHeight = 180;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    BlocProvider.of<AppCubit>(context).showMoviePage(movie.id!);
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                  },
                                  child: movie.poster_path != null
                                  ? Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: posterHeight / 1.5,
                                    height: posterHeight,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://image.tmdb.org/t/p/w300${movie.poster_path}"
                                        )
                                      )
                                    ),
                                  ) : NoMediaPosterPath(posterHeight: posterHeight, isMovie: true)
                                ),
                    
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  width: posterHeight / 1.5,
                                  child: Text(
                                    movie.original_title!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                    ),
                  )
                  : Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: tvShows.map((TvShow tvShow) {
                            double posterHeight = 180;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    BlocProvider.of<AppCubit>(context).showTvShowPage(tvShow.id!);
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MovieScreen(movie)));
                                  },
                                  child: tvShow.poster_path != null
                                  ? Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: posterHeight / 1.5,
                                    height: posterHeight,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://image.tmdb.org/t/p/w300${tvShow.poster_path}"
                                        )
                                      )
                                    ),
                                  ) : NoMediaPosterPath(posterHeight: posterHeight, isMovie: false)
                                ),

                                Container(
                                  padding: const EdgeInsets.all(2),
                                  width: posterHeight / 1.5,
                                  child: Text(
                                    tvShow.original_name!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                )
                              ],
                            );
                          }).toList(),
                        ),
                    ),
                  )
                  : Container()
              ],
            ),
          );
        } else {
          return Placeholder();
        }
      },
    );
  }
}