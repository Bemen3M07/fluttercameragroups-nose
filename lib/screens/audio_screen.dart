import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late AudioPlayer _audioPlayer;

  // --- CONFIGURACIÓ DE LA LLISTA DE CANÇONS ---
  final List<Map<String, String>> _playlist = [
    {
      'title': 'Himne del Perú',
      'file': 'himnoperu.mp3',
    },
    {
      'title': 'Faraón Love Shady - Duro 2 horas',
      'file': 'duro2horas.mp3', // Canvia pel nom del teu 2n fitxer
    },
  ];

  int _currentIndex = -1;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong(int index) async {
    if (_currentIndex == index) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } else {
      await _audioPlayer.stop();
      _currentIndex = index;
      await _audioPlayer.play(AssetSource(_playlist[index]['file']!));
    }

    if (_audioPlayer.state == PlayerState.playing) {
      setState(() => _isPlaying = true);
    } else {
      setState(() => _isPlaying = false);
    }
  }

  void _togglePlayPause() async {
    if (_currentIndex == -1) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
    });
  }

  // Noves funcions per saltar temps
  void _seekRelative(int seconds) {
    if (_currentIndex == -1) return;

    final newPosition = _position + Duration(seconds: seconds);
    // Evitem errors si ens passem de 0 o del final
    if (newPosition < Duration.zero) {
      _audioPlayer.seek(Duration.zero);
    } else if (newPosition > _duration) {
      _audioPlayer.seek(_duration);
    } else {
      _audioPlayer.seek(newPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- SECCIÓ 1: LLISTA ---
        Expanded(
          child: ListView.builder(
            itemCount: _playlist.length,
            itemBuilder: (context, index) {
              bool isSelected = _currentIndex == index;
              return Card(
                color: isSelected ? Colors.blue.shade100 : null,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Icon(
                    isSelected && _isPlaying
                        ? Icons.music_note
                        : Icons.music_off,
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                  title: Text(
                    _playlist[index]['title']!,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected && _isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onTap: () => _playSong(index),
                ),
              );
            },
          ),
        ),

        // --- SECCIÓ 2: REPRODUCTOR COMPLET ---
        Container(
          padding: const EdgeInsets.all(
              15), // Una mica menys de padding per que capiga tot
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentIndex != -1
                    ? "Reproduint: ${_playlist[_currentIndex]['title']}"
                    : "Selecciona una cançó",
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Slider(
                min: 0,
                max: _duration.inMilliseconds.toDouble(),
                value: _position.inMilliseconds
                    .toDouble()
                    .clamp(0, _duration.inMilliseconds.toDouble()),
                onChanged: (value) async {
                  if (_currentIndex != -1) {
                    final position = Duration(milliseconds: value.toInt());
                    await _audioPlayer.seek(position);
                  }
                },
              ),

              Text(
                  "${_position.toString().split('.').first} / ${_duration.toString().split('.').first}"),

              const SizedBox(height: 5),

              // --- FILA DE BOTONS ACTUALITZADA ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centrats
                children: [
                  // 1. Enrere 10s
                  IconButton(
                    icon: const Icon(Icons.replay_10),
                    onPressed:
                        _currentIndex != -1 ? () => _seekRelative(-10) : null,
                  ),

                  // 2. Stop
                  IconButton(
                    icon: const Icon(Icons.stop_circle),
                    onPressed: _currentIndex != -1 ? _stop : null,
                  ),

                  // 3. Play/Pause (Més gran)
                  IconButton(
                    iconSize: 50,
                    icon: Icon(_isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled),
                    color: Colors.blue,
                    onPressed: _currentIndex != -1 ? _togglePlayPause : null,
                  ),

                  // 4. Endavant 10s
                  IconButton(
                    icon: const Icon(Icons.forward_10),
                    onPressed:
                        _currentIndex != -1 ? () => _seekRelative(10) : null,
                  ),

                  // 5. Velocitat
                  IconButton(
                    icon: Text("x$_playbackSpeed",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      setState(() {
                        _playbackSpeed = (_playbackSpeed == 1.0) ? 2.0 : 1.0;
                      });
                      _audioPlayer.setPlaybackRate(_playbackSpeed);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
