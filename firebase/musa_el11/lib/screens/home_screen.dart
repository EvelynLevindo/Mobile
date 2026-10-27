import 'package:flutter/material.dart';
import 'package:musa_el11/screens/player_screen.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();
  final AudioService _audio = AudioService();

  String _selectedGenre = 'Tudo';
  final List<String> _genres = [
    'Tudo',
    'Pop Galáctico',
    'Eletrônica & Synth',
    'Lo-fi Mágico',
    'Rock & Instrumentais',
  ];

  late Future<List<Song>> _popularSongs;
  late Future<List<Song>> _recommendedSongs;
  late Future<List<Map<String, dynamic>>> _featuredAlbums;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _popularSongs = _api.getPopular();
    _recommendedSongs = _api.getRecommendations(_selectedGenre);
    _featuredAlbums = _api.getFeaturedAlbums();
  }

  void _onGenreSelected(String genre) {
    if (_selectedGenre == genre) return;
    setState(() {
      _selectedGenre = genre;
      _recommendedSongs = _api.getRecommendations(genre);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = _auth.currentUserName;

    return Scaffold(
      backgroundColor: MusaColors.background,
      appBar: AppBar(
        backgroundColor: MusaColors.background.withValues(alpha: 0.9),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [MusaColors.primaryCyan, MusaColors.secondaryPink],
                ),
                boxShadow: [
                  BoxShadow(
                    color: MusaColors.primaryCyan.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: MusaColors.background, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'MUSA',
              style: TextStyle(
                color: MusaColors.primaryCyan,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair da Conta',
            icon: const Icon(Icons.logout, color: MusaColors.textMuted),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: MusaColors.surfaceContainer,
                  title: const Text('Sair do Musa?', style: TextStyle(color: MusaColors.textPrimary)),
                  content: const Text(
                    'Deseja realmente desconectar de sua conta?',
                    style: TextStyle(color: MusaColors.textMuted),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar', style: TextStyle(color: MusaColors.textMuted)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MusaColors.secondaryPink,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _auth.logout();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: MusaColors.primaryCyan,
        backgroundColor: MusaColors.surfaceElevated,
        onRefresh: () async {
          setState(() {
            _loadData();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Cosmic Frequency Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, $userName ✨',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: MusaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Frequência sonora sintonizada em 432Hz',
                          style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: MusaColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: MusaColors.primaryCyan.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.graphic_eq, color: MusaColors.primaryCyan, size: 14),
                          SizedBox(width: 4),
                          Text('Online', style: TextStyle(color: MusaColors.primaryCyan, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Filter Chips
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _genres.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final genre = _genres[index];
                    final isSelected = genre == _selectedGenre;

                    return GestureDetector(
                      onTap: () => _onGenreSelected(genre),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? MusaColors.primaryCyan : MusaColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? MusaColors.primaryCyan : MusaColors.borderSubtle,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: MusaColors.primaryCyan.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          genre,
                          style: TextStyle(
                            color: isSelected ? MusaColors.background : MusaColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Section 1: Mais Tocadas na Galáxia (Horizontal Carousel Cards)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: MusaColors.primaryCyan, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Mais Tocadas na Galáxia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MusaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: FutureBuilder<List<Song>>(
                  future: _popularSongs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: MusaColors.primaryCyan));
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma música em destaque no momento.', style: TextStyle(color: MusaColors.textMuted)),
                      );
                    }
                    final songs = snapshot.data!;

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: songs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return _buildFeaturedSongCard(song, songs);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Section 2: Recomendações Sonoras
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.queue_music, color: MusaColors.secondaryPink, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Recomendações: $_selectedGenre',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MusaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Song>>(
                future: _recommendedSongs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator(color: MusaColors.secondaryPink)),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text('Nenhuma recomendação encontrada.', style: TextStyle(color: MusaColors.textMuted)),
                      ),
                    );
                  }
                  final songs = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.take(6).length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return SongTile(song: song, queue: songs);
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              // Section 3: Álbuns em Destaque
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.album, color: MusaColors.primaryCyan, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Álbuns em Destaque',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MusaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _featuredAlbums,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: MusaColors.primaryCyan));
                    }
                    final albums = snapshot.data ?? [];
                    if (albums.isEmpty) {
                      return const Center(
                        child: Text('Nenhum álbum em destaque.', style: TextStyle(color: MusaColors.textMuted)),
                      );
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: albums.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return _buildAlbumCard(album);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSongCard(Song song, List<Song> queue) {
    return GestureDetector(
      onTap: () {
        _audio.playSong(song, queue: queue);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerScreen(song: song)),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: MusaColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MusaColors.borderSubtle),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    song.coverUrl.replaceAll('100x100', '300x300'),
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 130,
                      height: 130,
                      color: MusaColors.surfaceElevated,
                      child: const Icon(Icons.music_note, color: MusaColors.secondaryPink, size: 40),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(6),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: MusaColors.primaryCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MusaColors.primaryCyan.withValues(alpha: 0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow, color: MusaColors.background, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              song.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: MusaColors.textPrimary,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              song.artist,
              style: const TextStyle(
                color: MusaColors.textMuted,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumCard(Map<String, dynamic> album) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: MusaColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MusaColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              album['coverUrl'] as String? ?? '',
              width: 104,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 104,
                height: 90,
                color: MusaColors.surfaceElevated,
                child: const Icon(Icons.album, color: MusaColors.primaryCyan),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            album['title'] as String? ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, color: MusaColors.textPrimary, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            album['artist'] as String? ?? '',
            style: const TextStyle(color: MusaColors.textMuted, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
