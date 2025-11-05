import 'package:flutter/material.dart';
import 'package:tmdb_app/core/constants/app_text_style.dart';
import 'package:tmdb_app/data/models/cast/cast_member.dart';

class CastCard extends StatelessWidget {
  final CastMember actor;
  final double? width;
  final VoidCallback? onTap;

  const CastCard({
    super.key,
    required this.actor,
    this.width = 110,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final profileUrl =
        actor.profilePath != null && actor.profilePath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w185${actor.profilePath}'
        : null;

    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Actor Image
              profileUrl != null
                  ? Image.network(
                      profileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, st) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person),
                    ),

              // Gradient Overlay with Name and Character
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(140, 0, 0, 0),
                        Colors.black87,
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.appText12Regular.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if ((actor.character ?? '').isNotEmpty)
                        Text(
                          actor.character ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.appText10Regular.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
