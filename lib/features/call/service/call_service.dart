// ignore_for_file: avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class CallService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playRingtone() async {
    try {
      if (_audioPlayer.state == PlayerState.playing) {
        await _audioPlayer.stop();
      }
      // Ring tone
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      await _audioPlayer.setSource(AssetSource('sounds/calls.mp3'));
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.resume();

      // Vibration
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [1000, 1000, 1000, 1000], repeat: 1);
      } else {
        print("Devices error.");
      }
    } catch (e) {
      print("Error CallService (playRingtone): $e");
    }
  }

  Future<void> stopRingtone() async {
    try {
      await _audioPlayer.stop();
      Vibration.cancel();
    } catch (e) {
      print("Error CallService (stopRingtone): $e");
    }
  }
}
