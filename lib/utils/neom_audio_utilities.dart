import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:neom_music_player/domain/entities/app_media_item.dart';

class NeomAudioUtilities {

  static int? getQueueIndex(AudioPlayer player, int? currentIndex) {
    final effectiveIndices = player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (player.shuffleModeEnabled &&
        ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  static const Set<MediaAction> mediaActions = {MediaAction.seek,MediaAction.seekForward,MediaAction.seekBackward};

  static List<AppMediaItem> sortSongs(List<AppMediaItem> appMediaItems, {required int sortVal, required int order}) {
    switch (sortVal) {
      case 0:
        appMediaItems.sort(
              (a, b) => a.title
              .toString()
              .toUpperCase()
              .compareTo(b.title.toString().toUpperCase()),
        );
      case 1:
        appMediaItems.sort(
              (a, b) => a.releaseDate
              .toString()
              .toUpperCase()
              .compareTo(b.releaseDate.toString().toUpperCase()),
        );
      case 2:
        appMediaItems.sort(
              (a, b) => a.album
              .toString()
              .toUpperCase()
              .compareTo(b.album.toString().toUpperCase()),
        );
      case 3:
        appMediaItems.sort(
              (a, b) => a.artist
              .toString()
              .toUpperCase()
              .compareTo(b.artist.toString().toUpperCase()),
        );
      case 4:
        appMediaItems.sort(
              (a, b) => a.duration
              .toString()
              .toUpperCase()
              .compareTo(b.duration.toString().toUpperCase()),
        );
      default:
        appMediaItems.sort(
              (b, a) => a.releaseDate
              .toString()
              .toUpperCase()
              .compareTo(b.releaseDate.toString().toUpperCase()),
        );
        break;
    }

    if (order == 1) {
      appMediaItems = appMediaItems.reversed.toList();
    }

    return appMediaItems;
  }

}