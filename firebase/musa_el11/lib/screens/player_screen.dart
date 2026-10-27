import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../widgets/custom_widgets.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;
  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioService _audio = AudioService();
  final DbService _db = DbService();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    // If not already playing this song, start it
    if (_audio.currentSong?.id != widget.song.id) {
      _audio.playSong(widget.song);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    return AnimatedBuilder(
      animation: _audio,
      builder: (context, _) {
        final currentSong = _audio.currentSong ?? widget.song;

        final durationMs = _audio.duration.inMilliseconds > 0
            ? _audio.duration.inMilliseconds
            : 30000; // default 30s preview
        final positionMs = _audio.position.inMilliseconds.clamp(0, durationMs);

        return Scaffold(
          backgroundColor: MusaColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, color: MusaColors.primaryCyan, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Column(
              children: [
                const Text(
                  'TOCANDO AGORA',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: MusaColors.textMuted,
                  ),
                ),
                Text(
                  currentSong.album.isNotEmpty ? currentSong.album : 'Musa Soundwave',
                  style: const TextStyle(
                    fontSize: 13,
                    color: MusaColors.primaryCyan,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Adicionar à Playlist',
                icon: const Icon(Icons.playlist_add, color: MusaColors.primaryCyan),
                onPressed: () => showAddToPlaylistSheet(context, currentSong),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Album Artwork with Neon Glow
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: MusaColors.primaryCyan.withValues(alpha: 0.35),
                          blurRadius: 32,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: MusaColors.secondaryPink.withValues(alpha: 0.25),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        currentSong.coverUrl.replaceAll('100x100', '600x600'),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: MusaColors.surfaceElevated,
                          child: const Icon(Icons.music_note, color: MusaColors.secondaryPink, size: 80),
                        ),
                      ),
                    ),
                  ),

                  // Title, Artist and Favorite Button
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: MusaColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentSong.artist,
                              style: const TextStyle(
                                fontSize: 16,
                                color: MusaColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (uid != null)
                        StreamBuilder<bool>(
                          stream: _db.isFavoriteStream(uid, currentSong.id),
                          builder: (context, snap) {
                            final isFav = snap.data ?? false;
                            return IconButton(
                              iconSize: 28,
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? MusaColors.secondaryPink : MusaColors.textMuted,
                              ),
                              onPressed: () => _db.toggleFavorite(uid, currentSong),
                            );
                          },
                        ),
                    ],
                  ),

                  // Progress Bar & Timestamps
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: MusaColors.primaryCyan,
                          inactiveTrackColor: MusaColors.surfaceElevated,
                          thumbColor: MusaColors.primaryCyan,
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        ),
                        child: Slider(
                          min: 0,
                          max: durationMs.toDouble(),
                          value: positionMs.toDouble(),
                          onChanged: (val) {
                            _audio.seek(Duration(milliseconds: val.toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_audio.position),
                              style: const TextStyle(color: MusaColors.textMuted, fontSize: 12),
                            ),
                            Text(
                              _formatDuration(
                                _audio.duration.inSeconds > 0
                                    ? _audio.duration
                                    : const Duration(seconds: 30),
                              ),
                              style: const TextStyle(color: MusaColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Audio Control Buttons (Previous, Play/Pause, Next)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 42,
                        icon: Icon(
                          Icons.skip_previous,
                          color: _audio.hasPrevious ? MusaColors.textPrimary : MusaColors.textMuted.withValues(alpha: 0.3),
                        ),
                        onPressed: _audio.hasPrevious ? () => _audio.playPrevious() : null,
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [MusaColors.primaryCyan, MusaColors.secondaryPink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MusaColors.primaryCyan.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 40,
                          icon: Icon(
                            _audio.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: MusaColors.background,
                          ),
                          onPressed: () => _audio.togglePlayPause(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        iconSize: 42,
                        icon: Icon(
                          Icons.skip_next,
                          color: _audio.hasNext ? MusaColors.textPrimary : MusaColors.textMuted.withValues(alpha: 0.3),
                        ),
                        onPressed: _audio.hasNext ? () => _audio.playNext() : null,
                      ),
                    ],
                  ),

                  // API Preview Notice Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: MusaColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MusaColors.borderSubtle),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, color: MusaColors.textMuted, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Prévia Oficial iTunes • 30 segundos',
                          style: TextStyle(color: MusaColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
