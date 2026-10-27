import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class DbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream user playlists (both owned and where the user is an authorized collaborator).
  Stream<List<Playlist>> getUserPlaylists(String uid) {
    return _db
        .collection('playlists')
        .where(
          Filter.or(
            Filter('ownerId', isEqualTo: uid),
            Filter('collaborators', arrayContains: uid),
          ),
        )
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Playlist.fromMap(doc.data(), doc.id)).toList());
  }

  /// Single playlist stream for real-time playlist screen updates.
  Stream<Playlist?> getPlaylistStream(String playlistId) {
    return _db.collection('playlists').doc(playlistId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return Playlist.fromMap(doc.data()!, doc.id);
    });
  }

  /// Create a new playlist
  Future<void> createPlaylist(String name, String ownerId) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    await _db.collection('playlists').add({
      'name': cleanName,
      'ownerId': ownerId,
      'collaborators': <String>[],
      'collaboratorEmails': <String>[],
      'tracks': <Map<String, dynamic>>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Rename an existing playlist (restricted by rules to owner)
  Future<void> updatePlaylistName(String playlistId, String newName) async {
    final cleanName = newName.trim();
    if (cleanName.isEmpty) return;

    await _db.collection('playlists').doc(playlistId).update({
      'name': cleanName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a playlist (restricted by rules to owner)
  Future<void> deletePlaylist(String playlistId) async {
    await _db.collection('playlists').doc(playlistId).delete();
  }

  /// Add track to playlist (allowed for owner and authorized collaborators)
  Future<void> addSongToPlaylist(String playlistId, Song song) async {
    await _db.collection('playlists').doc(playlistId).update({
      'tracks': FieldValue.arrayUnion([song.toMap()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove track from playlist (allowed for owner and authorized collaborators)
  Future<void> removeSongFromPlaylist(String playlistId, Song song) async {
    await _db.collection('playlists').doc(playlistId).update({
      'tracks': FieldValue.arrayRemove([song.toMap()]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Invite collaborator by registered email
  Future<void> addCollaborator(String playlistId, String email, String currentUid) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty) {
      throw Exception('Informe o e-mail do colaborador.');
    }

    final doc = await _db.collection('user_emails').doc(cleanEmail).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Nenhum usuário encontrado com o e-mail "$cleanEmail". O usuário precisa ter uma conta no Musa.');
    }

    final targetUid = doc.data()!['uid'] as String?;
    if (targetUid == null) {
      throw Exception('Dados de usuário incompletos.');
    }

    if (targetUid == currentUid) {
      throw Exception('Você já é o proprietário desta playlist.');
    }

    await _db.collection('playlists').doc(playlistId).update({
      'collaborators': FieldValue.arrayUnion([targetUid]),
      'collaboratorEmails': FieldValue.arrayUnion([cleanEmail]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove collaborator (owner only)
  Future<void> removeCollaborator(String playlistId, String collaboratorUid, String? collaboratorEmail) async {
    final updates = <String, dynamic>{
      'collaborators': FieldValue.arrayRemove([collaboratorUid]),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (collaboratorEmail != null && collaboratorEmail.isNotEmpty) {
      updates['collaboratorEmails'] = FieldValue.arrayRemove([collaboratorEmail]);
    }
    await _db.collection('playlists').doc(playlistId).update(updates);
  }

  // ---------------------------------------------------------------------------
  // FAVORITES
  // ---------------------------------------------------------------------------

  /// Stream user favorites
  Stream<List<Song>> getUserFavorites(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Song.fromMap(doc.data())).toList());
  }

  /// Stream single song favorite status
  Stream<bool> isFavoriteStream(String uid, String songId) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(songId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Toggle favorite on or off
  Future<bool> toggleFavorite(String uid, Song song) async {
    final docRef = _db.collection('users').doc(uid).collection('favorites').doc(song.id);
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
      return false;
    } else {
      await docRef.set({
        ...song.toMap(),
        'favoritedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }
}