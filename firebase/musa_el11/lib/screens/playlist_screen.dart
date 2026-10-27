import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_widgets.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;
  const PlaylistScreen({super.key, required this.playlist});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final DbService _db = DbService();
  final AuthService _auth = AuthService();

  String get _currentUid => _auth.currentUser?.uid ?? '';

  void _renamePlaylist(String currentName) {
    final ctrl = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: MusaColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Renomear Playlist', style: TextStyle(color: MusaColors.textPrimary)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: MusaColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Novo nome',
            hintStyle: TextStyle(color: MusaColors.textMuted.withValues(alpha: 0.5)),
            filled: true,
            fillColor: MusaColors.surfaceElevated,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
              final newName = ctrl.text.trim();
              if (newName.isEmpty) return;

              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogCtx);

              try {
                await _db.updatePlaylistName(widget.playlist.id, newName);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Nome da playlist atualizado!')),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Erro ao atualizar: $e')),
                );
              }
            },
            child: const Text('Salvar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePlaylist() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: MusaColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir Playlist?', style: TextStyle(color: MusaColors.textPrimary)),
        content: const Text(
          'Esta ação não pode ser desfeita. Todos os colaboradores perderão o acesso.',
          style: TextStyle(color: MusaColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar', style: TextStyle(color: MusaColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () async {
              final nav = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              Navigator.pop(dialogCtx);

              try {
                await _db.deletePlaylist(widget.playlist.id);
                nav.pop();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Playlist excluída.')),
                );
              } catch (e) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Erro ao excluir: $e')),
                );
              }
            },
            child: const Text('Excluir', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _manageParticipants(Playlist currentPlaylist) {
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MusaColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people, color: MusaColors.secondaryPink),
                      const SizedBox(width: 10),
                      const Text(
                        'Participantes & Colaboradores',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MusaColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: MusaColors.textMuted),
                        onPressed: () => Navigator.pop(sheetCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Convide amigos pelo e-mail cadastrado no Musa para adicionarem e removerem músicas juntos.',
                    style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Invite input row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: MusaColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'amigo@exemplo.com',
                            hintStyle: TextStyle(color: MusaColors.textMuted.withValues(alpha: 0.5), fontSize: 14),
                            filled: true,
                            fillColor: MusaColors.surfaceElevated,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MusaColors.primaryCyan,
                          foregroundColor: MusaColors.background,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () async {
                          final email = emailCtrl.text.trim();
                          if (email.isEmpty) return;

                          final scaffoldMessenger = ScaffoldMessenger.of(context);

                          try {
                            await _db.addCollaborator(currentPlaylist.id, email, _currentUid);
                            emailCtrl.clear();
                            setSheetState(() {});
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text('Colaborador "$email" convidado com sucesso! ✨')),
                            );
                          } catch (e) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                            );
                          }
                        },
                        child: const Text('Convidar', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Colaboradores ativos:',
                    style: TextStyle(color: MusaColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),

                  if (currentPlaylist.collaborators.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Nenhum colaborador adicionado ainda.',
                        style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
                      ),
                    )
                  else
                    ...List.generate(currentPlaylist.collaborators.length, (idx) {
                      final collabUid = currentPlaylist.collaborators[idx];
                      final collabEmail = idx < currentPlaylist.collaboratorEmails.length
                          ? currentPlaylist.collaboratorEmails[idx]
                          : collabUid;

                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: MusaColors.secondaryPink.withValues(alpha: 0.2),
                          child: const Icon(Icons.person, color: MusaColors.secondaryPink, size: 20),
                        ),
                        title: Text(
                          collabEmail,
                          style: const TextStyle(color: MusaColors.textPrimary, fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                          tooltip: 'Remover colaborador',
                          onPressed: () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            try {
                              await _db.removeCollaborator(currentPlaylist.id, collabUid, collabEmail);
                              setSheetState(() {});
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(content: Text('Colaborador removido.')),
                              );
                            } catch (e) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text('Erro ao remover: $e')),
                              );
                            }
                          },
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Playlist?>(
      stream: _db.getPlaylistStream(widget.playlist.id),
      builder: (context, snapshot) {
        final currentPlaylist = snapshot.data ?? widget.playlist;
        final isOwner = currentPlaylist.ownerId == _currentUid;
        final isCollaborator = currentPlaylist.collaborators.contains(_currentUid);
        final canEditTracks = isOwner || isCollaborator;

        return Scaffold(
          backgroundColor: MusaColors.background,
          appBar: AppBar(
            backgroundColor: MusaColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: MusaColors.primaryCyan),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              currentPlaylist.name,
              style: const TextStyle(
                color: MusaColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              if (isOwner) ...[
                IconButton(
                  tooltip: 'Gerenciar Colaboradores',
                  icon: const Icon(Icons.person_add_alt_1, color: MusaColors.primaryCyan),
                  onPressed: () => _manageParticipants(currentPlaylist),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: MusaColors.textMuted),
                  color: MusaColors.surfaceContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  onSelected: (val) {
                    if (val == 'rename') _renamePlaylist(currentPlaylist.name);
                    if (val == 'delete') _confirmDeletePlaylist();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'rename',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: MusaColors.primaryCyan, size: 18),
                          SizedBox(width: 8),
                          Text('Renomear', style: TextStyle(color: MusaColors.textPrimary)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                          SizedBox(width: 8),
                          Text('Excluir Playlist', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          body: Column(
            children: [
              // Header Summary Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MusaColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isOwner ? MusaColors.primaryCyan.withValues(alpha: 0.3) : MusaColors.secondaryPink.withValues(alpha: 0.3),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isOwner
                              ? [MusaColors.primaryCyan, MusaColors.accentPurple]
                              : [MusaColors.secondaryPink, MusaColors.accentPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.queue_music, color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentPlaylist.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: MusaColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOwner
                                ? 'Criada por você'
                                : 'Playlist colaborativa',
                            style: const TextStyle(color: MusaColors.secondaryPink, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${currentPlaylist.tracks.length} faixas • ${currentPlaylist.collaborators.length} colaborador(es)',
                            style: const TextStyle(color: MusaColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Track List
              Expanded(
                child: currentPlaylist.tracks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MusaColors.surfaceContainer,
                                  border: Border.all(color: MusaColors.primaryCyan.withValues(alpha: 0.3)),
                                ),
                                child: const Icon(Icons.music_off, color: MusaColors.primaryCyan, size: 36),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Nenhuma música na playlist',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MusaColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Use a aba Buscar ou o botão de adicionar nas faixas para incluir músicas aqui.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: MusaColors.textMuted, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: currentPlaylist.tracks.length,
                        itemBuilder: (context, index) {
                          final song = currentPlaylist.tracks[index];

                          return SongTile(
                            song: song,
                            queue: currentPlaylist.tracks,
                            trailing: canEditTracks
                                ? IconButton(
                                    tooltip: 'Remover da playlist',
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 22),
                                    onPressed: () async {
                                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                                      try {
                                        await _db.removeSongFromPlaylist(currentPlaylist.id, song);
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(content: Text('Removida de "${currentPlaylist.name}".')),
                                        );
                                      } catch (e) {
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(content: Text('Erro ao remover: $e')),
                                        );
                                      }
                                    },
                                  )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}