class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({required this.uid, required this.email, required this.name});

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['displayName'] ?? map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'displayName': name,
    'name': name,
  };
}

class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String previewUrl;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album = '',
    required this.coverUrl,
    required this.previewUrl,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id']?.toString() ?? map['trackId']?.toString() ?? '',
      title: map['title'] ?? map['trackName'] ?? 'Desconhecido',
      artist: map['artist'] ?? map['artistName'] ?? 'Desconhecido',
      album: map['album'] ?? map['collectionName'] ?? '',
      coverUrl: map['coverUrl'] ?? map['artworkUrl100'] ?? '',
      previewUrl: map['previewUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'artist': artist,
    'album': album,
    'coverUrl': coverUrl,
    'previewUrl': previewUrl,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Playlist {
  final String id;
  final String name;
  final String ownerId;
  final List<String> collaborators;
  final List<String> collaboratorEmails;
  final List<Song> tracks;

  Playlist({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.collaborators,
    this.collaboratorEmails = const [],
    required this.tracks,
  });

  factory Playlist.fromMap(Map<String, dynamic> map, String id) {
    var tracksList = (map['tracks'] as List?)
            ?.map((t) => Song.fromMap(Map<String, dynamic>.from(t)))
            .toList() ??
        [];
    return Playlist(
      id: id,
      name: map['name'] ?? '',
      ownerId: map['ownerId'] ?? '',
      collaborators: List<String>.from(map['collaborators'] ?? []),
      collaboratorEmails: List<String>.from(map['collaboratorEmails'] ?? []),
      tracks: tracksList,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'ownerId': ownerId,
    'collaborators': collaborators,
    'collaboratorEmails': collaboratorEmails,
    'tracks': tracks.map((t) => t.toMap()).toList(),
  };
}