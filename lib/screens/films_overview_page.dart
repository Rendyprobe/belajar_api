import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../cubit/films_cubit.dart';
import '../cubit/films_state.dart';
import '../models/ghibli_film.dart';
import '../router/app_router.dart';

class FilmsOverviewPage extends StatefulWidget {
  const FilmsOverviewPage({super.key});

  @override
  State<FilmsOverviewPage> createState() => _FilmsOverviewPageState();
}

class _FilmsOverviewPageState extends State<FilmsOverviewPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_handleQueryChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleQueryChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _handleQueryChanged() {
    context.read<FilmsCubit>().updateQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contentHorizontal = (5.w).clamp(16.0, 40.0).toDouble();
    final headerVertical = (3.h).clamp(20.0, 48.0).toDouble();
    final headerTitleSpacing = (1.h).clamp(8.0, 20.0).toDouble();
    final headerSearchSpacing = (3.h).clamp(20.0, 40.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1D2A),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF123752), Color(0xFF0B1D2A)],
            ),
          ),
          child: BlocConsumer<FilmsCubit, FilmsState>(
            listenWhen: (previous, current) => previous.query != current.query,
            listener: (_, state) {
              if (_searchController.text != state.query) {
                _searchController
                  ..text = state.query
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: state.query.length),
                  );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: contentHorizontal,
                      vertical: headerVertical,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Studio Ghibli',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: headerTitleSpacing),
                        Text(
                          'Jelajahi dunia magis karya Hayao Miyazaki dan rekan-rekannya.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: headerSearchSpacing),
                        _buildSearchField(theme),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildBodyContent(context, theme, state),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    final horizontalPadding = (4.5.w).clamp(14.0, 28.0).toDouble();
    final verticalPadding = (0.9.h).clamp(10.0, 16.0).toDouble();
    final borderRadius = (4.5.w).clamp(18.0, 32.0).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(31),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: TextField(
        controller: _searchController,
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        cursorColor: Colors.white70,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.white70, size: 22),
          hintText: 'Cari judul, sutradara, atau karakter',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white54,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    ThemeData theme,
    FilmsState state,
  ) {
    final horizontalPadding = (5.w).clamp(16.0, 40.0).toDouble();
    final topPadding = (1.5.h).clamp(12.0, 24.0).toDouble();
    final bottomPadding = (4.h).clamp(24.0, 56.0).toDouble();
    final itemSpacing = (2.4.h).clamp(16.0, 28.0).toDouble();

    if (state.isLoading && state.films.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (state.isFailure) {
      return _buildMessage(
        context,
        theme,
        message: 'Gagal memuat katalog.\n${state.errorMessage ?? ''}',
        actionLabel: 'Coba Lagi',
        onAction: () => context.read<FilmsCubit>().loadFilms(),
      );
    }

    if (state.filteredFilms.isEmpty) {
      return _buildMessage(
        context,
        theme,
        message:
            'Tidak ada film yang cocok.\nCoba kata kunci lain atau hapus pencarian.',
        actionLabel: 'Hapus Pencarian',
        onAction: () {
          context.read<FilmsCubit>().clearSearch();
        },
      );
    }

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: const Color(0xFF134466),
      onRefresh: context.read<FilmsCubit>().refresh,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          topPadding,
          horizontalPadding,
          bottomPadding,
        ),
        itemCount: state.filteredFilms.length,
        separatorBuilder: (_, __) => SizedBox(height: itemSpacing),
        itemBuilder: (context, index) {
          final film = state.filteredFilms[index];
          return _FilmCard(
            film: film,
            onTap: () {
              context.pushNamed(AppRoutes.filmDetail, extra: film);
            },
          );
        },
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context,
    ThemeData theme, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final horizontalPadding = (8.w).clamp(24.0, 64.0).toDouble();
    final verticalPadding = (4.h).clamp(24.0, 48.0).toDouble();
    final iconSize = (12.w).clamp(48.0, 96.0).toDouble();
    final spacing = (2.h).clamp(12.0, 24.0).toDouble();
    final buttonSpacing = (2.5.h).clamp(16.0, 28.0).toDouble();
    final buttonRadius = (6.w).clamp(24.0, 36.0).toDouble();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.white.withAlpha(179),
              size: iconSize,
            ),
            SizedBox(height: spacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: buttonSpacing),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(51),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius),
                  ),
                ),
                onPressed: () {
                  if (actionLabel == 'Hapus Pencarian') {
                    _searchController.clear();
                  }
                  onAction();
                },
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilmCard extends StatelessWidget {
  const _FilmCard({required this.film, required this.onTap});

  final GhibliFilm film;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = film.imageUrl.isNotEmpty ? film.imageUrl : film.bannerUrl;
    final cardRadius = (6.w).clamp(24.0, 36.0).toDouble();
    final paddingHorizontal = (5.w).clamp(20.0, 32.0).toDouble();
    final paddingTop = (2.h).clamp(16.0, 24.0).toDouble();
    final paddingBottom = (3.h).clamp(20.0, 32.0).toDouble();
    final infoSpacing = (1.2.h).clamp(8.0, 18.0).toDouble();
    final secondarySpacing = (1.h).clamp(6.0, 14.0).toDouble();

    return InkWell(
      borderRadius: BorderRadius.circular(cardRadius),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius),
          color: Colors.white.withAlpha(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(64),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(cardRadius),
              ),
              child: Hero(
                tag: 'poster_${film.id}',
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallback(),
                        )
                      : _buildFallback(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                paddingHorizontal,
                paddingTop,
                paddingHorizontal,
                paddingBottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (film.releaseInfo.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: infoSpacing),
                      child: Text(
                        film.releaseInfo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  if (film.peopleInfo.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: secondarySpacing),
                      child: Text(
                        film.peopleInfo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    final iconSize = (10.w).clamp(40.0, 72.0).toDouble();

    return Container(
      color: const Color(0xFF133043),
      child: Center(
        child: Icon(
          Icons.local_movies_outlined,
          color: Colors.white54,
          size: iconSize,
        ),
      ),
    );
  }
}
