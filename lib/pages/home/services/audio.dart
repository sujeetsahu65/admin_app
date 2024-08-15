import 'package:audioplayers/audioplayers.dart';

// class AudioService {
//   static final AudioPlayer _player = AudioPlayer();
//     static final AudioCache _audioCache = AudioCache();

//   static void playAlarmSound()async {
//  _player.stop();
//       // _audioCache.play('sounds/alarm_sound.mp3');
//     // _player.play('assets/audio/schoo-fire-alarm.mp3');
//     // await _player.play(UrlSource('https://example.com/my-audio.wav'));
//     await _player.play(AssetSource('audio/schoo-fire-alarm.mp3'));
//   }

//   static void stopAlarmSound() {
//     _player.stop();
//   }
// }




class AudioService {
  // Singleton pattern
  AudioService._privateConstructor();
  static final AudioService _instance = AudioService._privateConstructor();
  factory AudioService() => _instance;

  final AudioCache _audioCache = AudioCache();
  final AudioPlayer _player = AudioPlayer();

  void playAlarmSound() async {
    // Stop any currently playing audio
    await _player.stop();
    await _player.play(AssetSource('audio/schoo-fire-alarm.mp3'));
  }

  void stopAlarmSound() async {
    await _player.stop();
  }

  // bool isPlaying() {
  //   return _player.state == PlayerState.PLAYING;
  // }

    PlayerState getPlayerState() {
    return _player.state;
  }
}

