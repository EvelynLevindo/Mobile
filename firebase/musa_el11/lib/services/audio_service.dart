import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer player = AudioPlayer();
  Song? currentSong;
  List<Song> currentQueue = [];
  int currentIndex = -1;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  AudioService._internal() {
    player.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    player.onDurationChanged.listen((d) {
      duration = d;
      notifyListeners();
    });

    player.onPositionChanged.listen((p) {
      position = p;
      notifyListeners();
    });

    player.onPlayerComplete.listen((_) {
      if (hasNext) {
        playNext();
      } else {
        isPlaying = false;
        position = Duration.zero;
        notifyListeners();
      }
    });
  }

  bool get hasNext => currentIndex >= 0 && currentIndex + 1 < currentQueue.length;
  bool get hasPrevious => currentIndex > 0 && currentQueue.isNotEmpty;

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    if (song.previewUrl.isEmpty) return;

    if (queue != null && queue.isNotEmpty) {
      currentQueue = List<Song>.from(queue);
      currentIndex = currentQueue.indexWhere((s) => s.id == song.id);
      if (currentIndex == -1) {
        currentQueue.insert(0, song);
        currentIndex = 0;
      }
    } else if (currentQueue.isEmpty || !currentQueue.any((s) => s.id == song.id)) {
      currentQueue = [song];
      currentIndex = 0;
    } else {
      currentIndex = currentQueue.indexWhere((s) => s.id == song.id);
    }

    if (currentSong?.id == song.id) {
      if (!isPlaying) {
        await resume();
      }
      return;
    }

    currentSong = song;
    position = Duration.zero;
    notifyListeners();

    try {
      await player.stop();
      await player.play(UrlSource(song.previewUrl));
      isPlaying = true;
    } catch (e) {
      debugPrint('Erro ao reproduzir áudio: $e');
    }
    notifyListeners();
  }

  Future<void> pause() async {
    try {
      await player.pause();
      isPlaying = false;
    } catch (e) {
      debugPrint('Erro ao pausar: $e');
    }
    notifyListeners();
  }

  Future<void> resume() async {
    if (currentSong == null) return;
    try {
      await player.resume();
      isPlaying = true;
    } catch (e) {
      debugPrint('Erro ao retomar: $e');
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> seek(Duration newPosition) async {
    try {
      await player.seek(newPosition);
    } catch (e) {
      debugPrint('Erro ao buscar posição: $e');
    }
  }

  Future<void> playNext() async {
    if (hasNext) {
      currentIndex++;
      final nextSong = currentQueue[currentIndex];
      await playSong(nextSong, queue: currentQueue);
    }
  }

  Future<void> playPrevious() async {
    // If more than 3 seconds in, restart track
    if (position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (hasPrevious) {
      currentIndex--;
      final prevSong = currentQueue[currentIndex];
      await playSong(prevSong, queue: currentQueue);
    } else {
      await seek(Duration.zero);
    }
  }
}