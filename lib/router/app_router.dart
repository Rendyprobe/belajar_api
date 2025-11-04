import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/ghibli_film.dart';
import '../screens/film_detail_page.dart';
import '../screens/films_overview_page.dart';
import '../screens/splash_page.dart';

class AppRoutes {
  static const splash = 'splash';
  static const overview = 'overview';
  static const filmDetail = 'film-detail';
}

class AppRouter {
  AppRouter();

  final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/',
        name: AppRoutes.overview,
        builder: (context, state) => const FilmsOverviewPage(),
      ),
      GoRoute(
        path: '/film',
        name: AppRoutes.filmDetail,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is GhibliFilm) {
            return FilmDetailPage(film: extra);
          }
          return const _MissingFilmPage();
        },
      ),
    ],
  );
}

class _MissingFilmPage extends StatelessWidget {
  const _MissingFilmPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Film tidak ditemukan.')));
  }
}
