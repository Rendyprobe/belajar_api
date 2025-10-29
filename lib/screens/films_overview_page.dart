import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/films_cubit.dart';
import '../cubit/films_state.dart';
import '../models/ghibli_film.dart';
import 'film_detail_page.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF0B1D2A),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF123752),
                Color(0xFF0B1D2A),
              ],
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                        const SizedBox(height: 4),
                        Text(
                          'Jelajahi dunia magis karya Hayao Miyazaki dan rekan-rekannya.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 24),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(31),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _searchController,
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        cursorColor: Colors.white70,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.white70),
          hintText: 'Cari judul, sutradara, atau karakter',
          hintStyle: TextStyle(color: Colors.white54),
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: state.filteredFilms.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final film = state.filteredFilms[index];
          return _FilmCard(
            film: film,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FilmDetailPage(film: film),
                ),
              );
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              color: Colors.white.withAlpha(179),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(51),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
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

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
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
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        film.releaseInfo,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  if (film.peopleInfo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
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
    return Container(
      color: const Color(0xFF133043),
      child: const Center(
        child: Icon(
          Icons.local_movies_outlined,
          color: Colors.white54,
          size: 48,
        ),
      ),
    );
  }
}
