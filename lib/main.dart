import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'cubit/films_cubit.dart';
import 'router/app_router.dart';
import 'services/studio_ghibli_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1C5D99),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );

    return BlocProvider(
      create: (_) => FilmsCubit(StudioGhibliService())..loadFilms(),
      child: Sizer(
        builder: (_, __, ___) {
          return MaterialApp.router(
            title: 'Studio Ghibli Explorer',
            debugShowCheckedModeBanner: false,
            theme: baseTheme.copyWith(
              scaffoldBackgroundColor: const Color(0xFF0B1D2A),
              textTheme: baseTheme.textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
              ),
            ),
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
