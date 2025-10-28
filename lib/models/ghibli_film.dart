class GhibliFilm {
  const GhibliFilm({
    required this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.producer,
    required this.releaseYear,
    required this.runningTimeMinutes,
    required this.rottenTomatoesScore,
    required this.imageUrl,
    required this.bannerUrl,
    required this.movieUrl,
    this.originalTitle,
    this.originalTitleRomanized,
  });

  factory GhibliFilm.fromJson(Map<String, dynamic> json) {
    return GhibliFilm(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '-',
      description: (json['description'] as String? ?? '').trim(),
      director: (json['director'] as String? ?? '').trim(),
      producer: (json['producer'] as String? ?? '').trim(),
      releaseYear: (json['release_date'] as String? ?? '').trim(),
      runningTimeMinutes: (json['running_time'] as String? ?? '').trim(),
      rottenTomatoesScore: (json['rt_score'] as String? ?? '').trim(),
      imageUrl: (json['image'] as String? ?? '').trim(),
      bannerUrl: (json['movie_banner'] as String? ?? '').trim(),
      movieUrl: json['url'] as String? ??
          'https://ghibliapi.vercel.app/films/${json['id']}',
      originalTitle: (json['original_title'] as String?)?.trim(),
      originalTitleRomanized:
          (json['original_title_romanised'] as String?)?.trim(),
    );
  }

  final String id;
  final String title;
  final String description;
  final String director;
  final String producer;
  final String releaseYear;
  final String runningTimeMinutes;
  final String rottenTomatoesScore;
  final String imageUrl;
  final String bannerUrl;
  final String movieUrl;
  final String? originalTitle;
  final String? originalTitleRomanized;

  String get releaseInfo {
    final year = releaseYear.isEmpty ? null : releaseYear;
    final duration =
        runningTimeMinutes.isEmpty ? null : '$runningTimeMinutes menit';
    if (year == null && duration == null) return '';
    if (year != null && duration != null) return '$year • $duration';
    return year ?? duration ?? '';
  }

  String get peopleInfo {
    final dir = director.isEmpty ? null : 'Sutradara: $director';
    final prod = producer.isEmpty ? null : 'Produser: $producer';
    if (dir == null && prod == null) return '';
    if (dir != null && prod != null) return '$dir • $prod';
    return dir ?? prod ?? '';
  }

  String get rtScoreInfo {
    if (rottenTomatoesScore.isEmpty) return '';
    return 'Skor Rotten Tomatoes: $rottenTomatoesScore';
  }
}
