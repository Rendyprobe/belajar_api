import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../models/ghibli_film.dart';

class FilmDetailPage extends StatelessWidget {
  const FilmDetailPage({super.key, required this.film});

  final GhibliFilm film;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bannerUrl = film.bannerUrl.isNotEmpty
        ? film.bannerUrl
        : film.imageUrl;
    final expandedHeight = (45.h).clamp(280.0, 420.0).toDouble();
    final titlePaddingHorizontal = (4.w).clamp(16.0, 32.0).toDouble();
    final titlePaddingBottom = (2.h).clamp(12.0, 24.0).toDouble();
    final contentHorizontal = (5.w).clamp(16.0, 40.0).toDouble();
    final contentTop = (3.h).clamp(20.0, 40.0).toDouble();
    final contentBottom = (5.h).clamp(28.0, 56.0).toDouble();
    final sectionSpacing = (2.h).clamp(16.0, 28.0).toDouble();
    final wrapSpacing = (3.w).clamp(12.0, 32.0).toDouble();
    final wrapRunSpacing = (1.5.h).clamp(10.0, 20.0).toDouble();
    final headingSpacing = (3.h).clamp(24.0, 36.0).toDouble();
    final descriptionSpacing = (1.5.h).clamp(12.0, 22.0).toDouble();
    final peopleSectionSpacing = (4.h).clamp(28.0, 48.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1D2A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF0B1D2A),
            elevation: 0,
            pinned: true,
            expandedHeight: expandedHeight,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(
                left: titlePaddingHorizontal,
                right: titlePaddingHorizontal,
                bottom: titlePaddingBottom,
              ),
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
                            errorBuilder: (_, __, ___) =>
                                _buildBannerFallback(),
                          )
                        : _buildBannerFallback(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF0B1D2A)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                contentHorizontal,
                contentTop,
                contentHorizontal,
                contentBottom,
              ),
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
                  SizedBox(height: sectionSpacing),
                  Wrap(
                    spacing: wrapSpacing,
                    runSpacing: wrapRunSpacing,
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
                  SizedBox(height: headingSpacing),
                  Text(
                    'Sinopsis',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: descriptionSpacing),
                  Text(
                    film.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: peopleSectionSpacing),
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

    final sectionSpacing = (1.5.h).clamp(12.0, 24.0).toDouble();
    final cardRadius = (3.w).clamp(16.0, 28.0).toDouble();
    final cardPadding = (4.w).clamp(16.0, 28.0).toDouble();
    final iconSize = (4.5.w).clamp(20.0, 28.0).toDouble();
    final iconSpacing = (4.w).clamp(12.0, 24.0).toDouble();
    final textSpacing = (0.8.h).clamp(6.0, 12.0).toDouble();

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
        SizedBox(height: sectionSpacing),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: sectionSpacing),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              padding: EdgeInsets.all(cardPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, color: Colors.white70, size: iconSize),
                  SizedBox(width: iconSpacing),
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
                        SizedBox(height: textSpacing),
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
    final iconSize = (14.w).clamp(64.0, 128.0).toDouble();

    return Container(
      color: const Color(0xFF123752),
      child: Center(
        child: Icon(
          Icons.landscape_outlined,
          color: Colors.white54,
          size: iconSize,
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
    final horizontalPadding = (4.5.w).clamp(16.0, 28.0).toDouble();
    final verticalPadding = (1.2.h).clamp(10.0, 18.0).toDouble();
    final borderRadius = (5.w).clamp(18.0, 32.0).toDouble();
    final iconSize = (4.w).clamp(18.0, 26.0).toDouble();
    final spacing = (2.2.w).clamp(8.0, 16.0).toDouble();
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Colors.white70,
      fontWeight: FontWeight.w500,
    );

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(31),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: iconSize),
            SizedBox(width: spacing),
            Expanded(
              child: Text(
                label,
                style: textStyle,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
