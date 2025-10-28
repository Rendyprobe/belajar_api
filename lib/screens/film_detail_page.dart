import 'package:flutter/material.dart';

import '../models/ghibli_film.dart';

class FilmDetailPage extends StatelessWidget {
  const FilmDetailPage({super.key, required this.film});

  final GhibliFilm film;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bannerUrl = film.bannerUrl.isNotEmpty ? film.bannerUrl : film.imageUrl;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1D2A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF0B1D2A),
            elevation: 0,
            pinned: true,
            expandedHeight: 320,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              title: Text(
                film.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'poster_${film.id}',
                    child: bannerUrl.isNotEmpty
                        ? Image.network(
                            bannerUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildBannerFallback(),
                          )
                        : _buildBannerFallback(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xFF0B1D2A),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (film.originalTitleRomanized != null &&
                      film.originalTitleRomanized!.isNotEmpty)
                    Text(
                      film.originalTitleRomanized!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else if (film.originalTitle != null &&
                      film.originalTitle!.isNotEmpty &&
                      film.originalTitle!.toLowerCase() !=
                          film.title.toLowerCase())
                    Text(
                      film.originalTitle!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (film.releaseInfo.isNotEmpty)
                        _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: film.releaseInfo,
                        ),
                      if (film.peopleInfo.isNotEmpty)
                        _InfoChip(
                          icon: Icons.groups_rounded,
                          label: film.peopleInfo,
                        ),
                      if (film.rtScoreInfo.isNotEmpty)
                        _InfoChip(
                          icon: Icons.grade_outlined,
                          label: film.rtScoreInfo,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Sinopsis',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    film.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildPeopleSection(theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleSection(ThemeData theme) {
    final items = <_DetailItem>[
      if (film.director.isNotEmpty)
        _DetailItem('Sutradara', film.director, Icons.person_outline),
      if (film.producer.isNotEmpty)
        _DetailItem('Produser', film.producer, Icons.person_2_outlined),
      if (film.movieUrl.isNotEmpty)
        _DetailItem('Informasi Resmi', film.movieUrl, Icons.link_outlined),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Lain',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.icon,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerFallback() {
    return Container(
      color: const Color(0xFF123752),
      child: const Center(
        child: Icon(
          Icons.landscape_outlined,
          color: Colors.white54,
          size: 72,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(31),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  _DetailItem(this.title, this.value, this.icon);

  final String title;
  final String value;
  final IconData icon;
}
