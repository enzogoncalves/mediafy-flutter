import 'package:flutter_modular/flutter_modular.dart';
import 'package:mediafy/cubit/cubits.dart';
import 'package:mediafy/modules/home/home_screen.dart';
import 'package:mediafy/modules/movie/movie_screen.dart';
import 'package:mediafy/modules/splash/splash_screen.dart';
import 'package:mediafy/modules/tvShow/tvShow_screen.dart';
import 'package:mediafy/modules/welcome/welcome_screen.dart';
import 'package:mediafy/router/pages_name.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(() => AppCubit.instance);
  }

  @override
  void routes(r) {
    r.child(PagesName.splash, child: (context) => const SplashScreen());
    r.child(PagesName.welcome, child: (context) => const WelcomeScreen());
    r.child(PagesName.movies, child: (context) => HomeScreen(page: 1), transition: TransitionType.noTransition);
    r.child(PagesName.tv_shows, child: (context) => HomeScreen(page: 0), transition: TransitionType.noTransition);
    r.child(PagesName.search, child: (context) => HomeScreen(page: 2), transition: TransitionType.noTransition);
    r.child(PagesName.movie,
        child: (context) => MovieScreen(
              movieId: r.args.data,
            ),
        transition: TransitionType.rightToLeft);
    r.child(PagesName.tvShow, child: (context) => TvShowScreen(tvShowId: r.args.data), transition: TransitionType.rightToLeft);
  }
}
