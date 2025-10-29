import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ghibli_film.dart';
import '../services/studio_ghibli_service.dart';
import 'films_state.dart';

class FilmsCubit extends Cubit<FilmsState> {
  FilmsCubit(this._service) : super(const FilmsState());

  final StudioGhibliService _service;

  Future<void> loadFilms() async {
    emit(state.copyWith(status: FilmsStatus.loading, errorMessage: null));
    try {
      final films = await _service.fetchFilms();
      final filtered = _filterFilms(films, state.query);
      emit(
        state.copyWith(
          status: FilmsStatus.success,
          films: films,
          filteredFilms: filtered,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: FilmsStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadFilms();
  }

  void updateQuery(String query) {
    if (query == state.query && state.status != FilmsStatus.initial) {
      return;
    }
    final filtered = _filterFilms(state.films, query);
    emit(
      state.copyWith(
        query: query,
        filteredFilms: filtered,
      ),
    );
  }

  void clearSearch() {
    if (state.query.isEmpty) return;
    emit(
      state.copyWith(
        query: '',
        filteredFilms: state.films,
      ),
    );
  }

  List<GhibliFilm> _filterFilms(List<GhibliFilm> films, String query) {
    final lowered = query.trim().toLowerCase();
    if (lowered.isEmpty) return films;

    return films.where((film) {
      final title = film.title.toLowerCase();
      final original = film.originalTitle?.toLowerCase() ?? '';
      final romanized = film.originalTitleRomanized?.toLowerCase() ?? '';
      final director = film.director.toLowerCase();
      final producer = film.producer.toLowerCase();
      final description = film.description.toLowerCase();

      return title.contains(lowered) ||
          original.contains(lowered) ||
          romanized.contains(lowered) ||
          director.contains(lowered) ||
          producer.contains(lowered) ||
          description.contains(lowered);
    }).toList();
  }
}
