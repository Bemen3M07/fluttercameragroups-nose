import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Escoltar canvis en la durada de l'àudio
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    // Escoltar el progrés de la reproducció
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    // Quan l'àudio s'acaba
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

  // Funció per reproduir/pausar
  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Reproduïm des dels assets
      await _audioPlayer.play(AssetSource('himnoperu.mp3'));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  // Funció per aturar
  void _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _position = Duration.zero;
    });
  }

  // Funció per canviar la velocitat
  void _toggleSpeed() {
    setState(() {
      _playbackSpeed = (_playbackSpeed == 1.0) ? 2.0 : 1.0;
    });
    _audioPlayer.setPlaybackRate(_playbackSpeed);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Colors.blue),
            const SizedBox(height: 20),

            // Slider per posicionar-se a qualsevol lloc de l'àudio
            Slider(
              min: 0,
              max: _duration.inMilliseconds.toDouble(),
              value: _position.inMilliseconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(milliseconds: value.toInt());
                await _audioPlayer.seek(position);
              },
            ),

            // Text amb el temps actual / total
            Text(
                "${_position.toString().split('.').first} / ${_duration.toString().split('.').first}"),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botó enrere (10 segons)
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: () => _audioPlayer
                      .seek(_position - const Duration(seconds: 10)),
                ),
                // Botó Play/Pause
                IconButton(
                  iconSize: 64,
                  icon:
                      Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                  onPressed: _playPause,
                ),
                // Botó Stop
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.stop_circle),
                  onPressed: _stop,
                ),
                // Botó endavant (10 segons)
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: () => _audioPlayer
                      .seek(_position + const Duration(seconds: 10)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Control de velocitat
            ElevatedButton(
              onPressed: _toggleSpeed,
              child: Text("Velocitat: x$_playbackSpeed"),
            ),
          ],
        ),
      ),
    );
  }
}
