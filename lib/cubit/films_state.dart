import 'package:flutter/material.dart';

import '../models/ghibli_film.dart';

const _noErrorValue = Object();

@immutable
class FilmsState {
  const FilmsState({
    this.status = FilmsStatus.initial,
    this.films = const <GhibliFilm>[],
    this.filteredFilms = const <GhibliFilm>[],
    this.query = '',
    this.errorMessage,
  });

  final FilmsStatus status;
  final List<GhibliFilm> films;
  final List<GhibliFilm> filteredFilms;
  final String query;
  final String? errorMessage;

  bool get isLoading => status == FilmsStatus.loading;
  bool get isSuccess => status == FilmsStatus.success;
  bool get isFailure => status == FilmsStatus.failure;

  FilmsState copyWith({
    FilmsStatus? status,
    List<GhibliFilm>? films,
    List<GhibliFilm>? filteredFilms,
    String? query,
    Object? errorMessage = _noErrorValue,
  }) {
    return FilmsState(
      status: status ?? this.status,
      films: films ?? this.films,
      filteredFilms: filteredFilms ?? this.filteredFilms,
      query: query ?? this.query,
      errorMessage: identical(errorMessage, _noErrorValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

enum FilmsStatus { initial, loading, success, failure }
