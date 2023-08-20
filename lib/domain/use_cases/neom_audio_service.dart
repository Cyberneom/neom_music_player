import 'package:audio_service/audio_service.dart';
import 'package:neom_music_player/domain/entities/queue_state.dart';
import 'package:neom_music_player/ui/player/media_player_page.dart';
import 'package:rxdart/rxdart.dart';

abstract class NeomAudioService implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  ValueStream<double> get speed;
}