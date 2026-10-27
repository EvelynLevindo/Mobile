import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/player_screen.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';

class MusaColors {
  static const Color background = Color(0xFF0F1321);
  static const Color surface = Color(0xFF171B2A);
  static const Color surfaceContainer = Color(0xFF1B1F2E);
  static const Color surfaceElevated = Color(0xFF252939);
  static const Color primaryCyan = Color(0xFF00F0FF);
  static const Color secondaryPink = Color(0xFFE026C4);
  static const Color accentPurple = Color(0xFF9D4EDD);
  static const Color textPrimary = Color(0xFFDFE1F6);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderSubtle = Color(0x1FFFFFFF);
}

class SongTile extends StatelessWidget {
  final Song song;
  final List<Song>? queue;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SongTile({
    super.key,
    required this.song,
    this.queue,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();
    final uid = AuthService().currentUser?.uid;
    final isCurrent = audio.currentSong?.id == song.id;

    return AnimatedBuilder(
      animation: audio,
      builder: (context, _) {
        final currentlyPlaying = audio.currentSong?.id == song.id && audio.isPlaying;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrent ? MusaColors.surfaceElevated : MusaColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCurrent ? MusaColors.primaryCyan.withValues(alpha: 0.4) : MusaColors.borderSubtle,
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    song.coverUrl.replaceAll('100x100', '200x200'),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: MusaColors.surfaceElevated,
                      child: const Icon(Icons.music_note, color: MusaColors.secondaryPink),
                    ),
                  ),
                ),
                if (currentlyPlaying)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const EqualizerIndicator(),
                  ),
              ],
            ),
            title: Text(
              song.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isCurrent ? MusaColors.primaryCyan : MusaColors.textPrimary,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artist + (song.album.isNotEmpty ? ' • ${song.album}' : ''),
              style: const TextStyle(color: MusaColors.textMuted, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: trailing ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (uid != null)
                      StreamBuilder<bool>(
                        stream: DbService().isFavoriteStream(uid, song.id),
                        builder: (context, snap) {
                          final isFav = snap.data ?? false;
                          return IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? MusaColors.secondaryPink : MusaColors.textMuted,
                            ),
                            onPressed: () => DbService().toggleFavorite(uid, song),
                          );
                        },
                      ),
                    IconButton(
                      iconSize: 22,
                      splashRadius: 20,
                      icon: Icon(
                        currentlyPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        color: MusaColors.primaryCyan,
                      ),
                      onPressed: () {
                        if (isCurrent) {
                          audio.togglePlayPause();
                        } else {
                          audio.playSong(song, queue: queue);
                        }
                      },
                    ),
                  ],
                ),
            onTap: onTap ??
                () {
                  audio.playSong(song, queue: queue);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerScreen(song: song)),
                  );
                },
          ),
        );
      },
    );
  }
}

class EqualizerIndicator extends StatelessWidget {
  const EqualizerIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _EqBar(height: 16),
        SizedBox(width: 2),
        _EqBar(height: 22),
        SizedBox(width: 2),
        _EqBar(height: 12),
      ],
    );
  }
}

class _EqBar extends StatelessWidget {
  final double height;
  const _EqBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: MusaColors.primaryCyan,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [
          BoxShadow(
            color: MusaColors.primaryCyan,
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    return AnimatedBuilder(
      animation: audio,
      builder: (context, _) {
        final song = audio.currentSong;
        if (song == null) return const SizedBox.shrink();

        final progress = audio.duration.inMilliseconds > 0
            ? (audio.position.inMilliseconds / audio.duration.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerScreen(song: song)),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MusaColors.surfaceElevated.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: MusaColors.primaryCyan.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3300F0FF),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress line
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(MusaColors.primaryCyan),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            song.coverUrl,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 44,
                              height: 44,
                              color: MusaColors.surfaceContainer,
                              child: const Icon(Icons.music_note, color: MusaColors.secondaryPink, size: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                song.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MusaColors.textPrimary,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                song.artist,
                                style: const TextStyle(color: MusaColors.textMuted, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            audio.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: MusaColors.primaryCyan,
                          ),
                          onPressed: () => audio.togglePlayPause(),
                        ),
                        if (audio.hasNext)
                          IconButton(
                            iconSize: 26,
                            icon: const Icon(Icons.skip_next, color: MusaColors.textMuted),
                            onPressed: () => audio.playNext(),
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

void showAddToPlaylistSheet(BuildContext context, Song song) {
  final uid = AuthService().currentUser?.uid;
  if (uid == null) return;

  final db = DbService();

  showModalBottomSheet(
    context: context,
    backgroundColor: MusaColors.surfaceContainer,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.playlist_add, color: MusaColors.primaryCyan),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Adicionar "${song.title}" à playlist',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MusaColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: MusaColors.borderSubtle),
              Flexible(
                child: StreamBuilder<List<Playlist>>(
                  stream: db.getUserPlaylists(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(color: MusaColors.primaryCyan),
                        ),
                      );
                    }
                    final playlists = snapshot.data ?? [];
                    if (playlists.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Você ainda não possui playlists. Crie uma na aba Biblioteca.',
                              style: TextStyle(color: MusaColors.textMuted),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MusaColors.secondaryPink,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(sheetContext),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final pl = playlists[index];
                        final alreadyAdded = pl.tracks.any((t) => t.id == song.id);

                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: MusaColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.queue_music, color: MusaColors.primaryCyan, size: 22),
                          ),
                          title: Text(
                            pl.name,
                            style: const TextStyle(color: MusaColors.textPrimary, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${pl.tracks.length} músicas' +
                                (pl.ownerId != uid ? ' • Colaborativa' : ''),
                            style: const TextStyle(color: MusaColors.textMuted, fontSize: 12),
                          ),
                          trailing: alreadyAdded
                              ? const Icon(Icons.check, color: MusaColors.primaryCyan)
                              : const Icon(Icons.add, color: MusaColors.secondaryPink),
                          onTap: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            Navigator.pop(sheetContext);

                            if (alreadyAdded) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text('Esta música já está em "${pl.name}".')),
                              );
                              return;
                            }

                            try {
                              await db.addSongToPlaylist(pl.id, song);
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text('Adicionada a "${pl.name}"!')),
                              );
                            } catch (e) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text('Erro ao adicionar: $e')),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}