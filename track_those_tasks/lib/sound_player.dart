import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  static AudioCache audioCache = AudioCache();
  static AudioPlayer advancedPlayer = AudioPlayer();

  static final path = "sounds";

  static final confirmSound = '$path/confirm.mp3';
  static final dongSound = '$path/dong.mp3';
  static final clickSound = '$path/click.mp3';

  static void playConfirmSound() => audioCache.play(confirmSound, volume: 25);

  static void playClickSound() => audioCache.play(clickSound, volume: 25);

  static void playDongSound() => audioCache.play(dongSound, volume: 25);
}
