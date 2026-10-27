import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_widgets.dart';
import 'playlist_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  final DbService _db = DbService();
  final AuthService _auth = AuthService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _createPlaylist() {
    final TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: MusaColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.queue_music, color: MusaColors.primaryCyan),
            SizedBox(width: 8),
            Text(
              'Nova Playlist',
              style: TextStyle(color: MusaColors.textPrimary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: MusaColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Nome da sua playlist',
            hintStyle: TextStyle(color: MusaColors.textMuted.withValues(alpha: 0.5)),
            filled: true,
            fillColor: MusaColors.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar', style: TextStyle(color: MusaColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MusaColors.primaryCyan,
              foregroundColor: MusaColors.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;

              final uid = _auth.currentUser?.uid;
              if (uid == null) return;

              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogCtx);

              try {
                await _db.createPlaylist(name, uid);
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Playlist "$name" criada com sucesso! ✨')),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Erro ao criar playlist: $e')),
                );
              }
            },
            child: const Text('Criar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(
        backgroundColor: MusaColors.background,
        body: Center(
          child: Text('Faça login para ver sua biblioteca.', style: TextStyle(color: MusaColors.textMuted)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MusaColors.background,
      appBar: AppBar(
        backgroundColor: MusaColors.background,
        elevation: 0,
        title: const Text(
          'Sua Biblioteca',
          style: TextStyle(
            color: MusaColors.primaryCyan,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: MusaColors.primaryCyan,
          indicatorWeight: 3,
          labelColor: MusaColors.primaryCyan,
          unselectedLabelColor: MusaColors.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(text: 'Playlists'),
            Tab(text: 'Músicas Favoritas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Playlists
          _buildPlaylistsTab(uid),

          // Tab 2: Favorites
          _buildFavoritesTab(uid),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MusaColors.primaryCyan,
        foregroundColor: MusaColors.background,
        elevation: 6,
        onPressed: _createPlaylist,
        icon: const Icon(Icons.add, size: 22),
        label: const Text('Nova Playlist', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPlaylistsTab(String uid) {
    return StreamBuilder<List<Playlist>>(
      stream: _db.getUserPlaylists(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: MusaColors.primaryCyan),
          );
        }

        final playlists = snapshot.data ?? [];
        if (playlists.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MusaColors.surfaceContainer,
                      border: Border.all(color: MusaColors.primaryCyan.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.queue_music, color: MusaColors.primaryCyan, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhuma playlist criada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MusaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Crie sua primeira playlist e convide amigos para colaborar em tempo real.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final pl = playlists[index];
            final isOwner = pl.ownerId == uid;
            final isCollab = pl.collaborators.isNotEmpty || !isOwner;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: MusaColors.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCollab ? MusaColors.secondaryPink.withValues(alpha: 0.3) : MusaColors.borderSubtle,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                leading: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCollab
                          ? [MusaColors.secondaryPink, MusaColors.accentPurple]
                          : [MusaColors.primaryCyan, MusaColors.accentPurple],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCollab ? Icons.group : Icons.playlist_play,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        pl.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MusaColors.textPrimary,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCollab)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: MusaColors.secondaryPink.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MusaColors.secondaryPink.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          isOwner ? 'Colaborativa' : 'Convidado',
                          style: const TextStyle(
                            color: MusaColors.secondaryPink,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${pl.tracks.length} músicas' +
                        (pl.collaborators.isNotEmpty ? ' • ${pl.collaborators.length} colaborador(es)' : ''),
                    style: const TextStyle(color: MusaColors.textMuted, fontSize: 13),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: MusaColors.textMuted, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: pl)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesTab(String uid) {
    return StreamBuilder<List<Song>>(
      stream: _db.getUserFavorites(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: MusaColors.secondaryPink),
          );
        }

        final favorites = snapshot.data ?? [];
        if (favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MusaColors.surfaceContainer,
                      border: Border.all(color: MusaColors.secondaryPink.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.favorite_border, color: MusaColors.secondaryPink, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhuma música favorita',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MusaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Toque no ícone de coração em qualquer música para salvá-la aqui nos seus favoritos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 100),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final song = favorites[index];
            return SongTile(
              song: song,
              queue: favorites,
            );
          },
        );
      },
    );
  }
}