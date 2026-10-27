import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/custom_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  int _selectedFilter = 0; // 0: Músicas, 1: Artistas, 2: Álbuns
  final List<String> _filterLabels = ['Músicas', 'Artistas', 'Álbuns'];

  List<Song> _songResults = [];
  List<Map<String, dynamic>> _albumResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _search() async {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      if (_selectedFilter == 0) {
        // Músicas
        final songs = await _api.searchSongs(query);
        if (mounted) {
          setState(() {
            _songResults = songs;
            _isLoading = false;
          });
        }
      } else if (_selectedFilter == 1) {
        // Artistas
        final songs = await _api.searchArtists(query);
        if (mounted) {
          setState(() {
            _songResults = songs;
            _isLoading = false;
          });
        }
      } else {
        // Álbuns
        final albums = await _api.searchAlbums(query);
        if (mounted) {
          setState(() {
            _albumResults = albums;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na busca: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MusaColors.background,
      appBar: AppBar(
        backgroundColor: MusaColors.background,
        elevation: 0,
        title: const Text(
          'Buscar',
          style: TextStyle(
            color: MusaColors.primaryCyan,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: MusaColors.surfaceContainer,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: MusaColors.borderSubtle),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F00F0FF),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 8.0),
                    child: Icon(Icons.search, color: MusaColors.primaryCyan),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(color: MusaColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Música, artista ou álbum...',
                        hintStyle: TextStyle(color: MusaColors.textMuted, fontSize: 14),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  if (_searchCtrl.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: MusaColors.textMuted, size: 20),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {
                          _hasSearched = false;
                          _songResults.clear();
                          _albumResults.clear();
                        });
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: MusaColors.primaryCyan),
                    onPressed: _search,
                  ),
                ],
              ),
            ),
          ),

          // Filter Segmented Chips (Músicas, Artistas, Álbuns)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Row(
              children: List.generate(_filterLabels.length, (index) {
                final isSelected = _selectedFilter == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_filterLabels[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = index;
                        });
                        if (_searchCtrl.text.trim().isNotEmpty) {
                          _search();
                        }
                      }
                    },
                    selectedColor: MusaColors.primaryCyan,
                    backgroundColor: MusaColors.surfaceContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? MusaColors.background : MusaColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? MusaColors.primaryCyan : MusaColors.borderSubtle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          // Search Results
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: MusaColors.primaryCyan),
                  )
                : !_hasSearched
                    ? _buildInitialState()
                    : _selectedFilter == 2
                        ? _buildAlbumResults()
                        : _buildSongResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MusaColors.surfaceContainer,
                border: Border.all(color: MusaColors.primaryCyan.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.music_note, color: MusaColors.primaryCyan, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Encontre seu som mágico',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MusaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pesquise músicas, artistas e álbuns para ouvir prévias e montar suas playlists.',
              textAlign: TextAlign.center,
              style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongResults() {
    if (_songResults.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado.',
          style: TextStyle(color: MusaColors.textMuted, fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _songResults.length,
      itemBuilder: (context, index) {
        final song = _songResults[index];
        return SongTile(
          song: song,
          queue: _songResults,
          trailing: IconButton(
            tooltip: 'Adicionar à Playlist',
            icon: const Icon(Icons.playlist_add, color: MusaColors.secondaryPink),
            onPressed: () => showAddToPlaylistSheet(context, song),
          ),
        );
      },
    );
  }

  Widget _buildAlbumResults() {
    if (_albumResults.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum álbum encontrado.',
          style: TextStyle(color: MusaColors.textMuted, fontSize: 15),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _albumResults.length,
      itemBuilder: (context, index) {
        final album = _albumResults[index];
        return Container(
          decoration: BoxDecoration(
            color: MusaColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: MusaColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    album['coverUrl'] as String? ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: MusaColors.surfaceElevated,
                      child: const Center(
                        child: Icon(Icons.album, color: MusaColors.primaryCyan, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                album['title'] as String? ?? '',
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
                album['artist'] as String? ?? '',
                style: const TextStyle(color: MusaColors.textMuted, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${album['trackCount']} faixas • ${album['genre']}',
                style: const TextStyle(color: MusaColors.secondaryPink, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}