import 'package:flutter/material.dart';
import 'package:neom_commons/core/domain/model/app_media_item.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../neom_player_invoker.dart';
import '../../ui/player/media_player_page.dart';
import 'audio_query.dart';

// ignore: avoid_classes_with_only_static_members
class HandleRoute {
  static Route? handleRoute(String? url) {
    AppUtilities.logger.i('received route url: $url');
    if (url == null) return null;

    ///DEPRECATED
    // if (url.contains('spotify')) {
    //   // TODO: Add support for spotify links
    //   AppUtilities.logger.i('received spotify link');
    //   final RegExpMatch? songResult = RegExp(r'.*spotify.com.*?\/(track)\/(.*?)[/?]').firstMatch('$url/');
    //   if (songResult != null) {
    //     return PageRouteBuilder(
    //       opaque: false,
    //       pageBuilder: (_, __, ___) => SpotifyUrlHandler(
    //         id: songResult[2]!,
    //         type: songResult[1]!,
    //       ),
    //     );
    //   }
    // }

    final RegExpMatch? fileResult = RegExp(r'\/[0-9]+\/([0-9]+)\/').firstMatch('$url/');
    if (fileResult != null) {
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => OfflinePlayHandler(
          id: fileResult[1]!,
        ),
      );
    }

    return null;
  }
}

class OfflinePlayHandler extends StatelessWidget {
  final String id;
  const OfflinePlayHandler({super.key, required this.id});

  Future<List> playOfflineSong(String id) async {
    final OfflineAudioQuery offlineAudioQuery = OfflineAudioQuery();
    await offlineAudioQuery.requestPermission();

    final List<SongModel> songs = await offlineAudioQuery.getSongs();
    final int index = songs.indexWhere((i) => i.id.toString() == id);

    return [index, songs];
  }

  @override
  Widget build(BuildContext context) {
    playOfflineSong(id).then((value) {
      NeomPlayerInvoker.init(
        appMediaItems: AppMediaItem.listFromSongModel(value[1] as List<SongModel>),
        index: value[0] as int,
        isOffline: true,
        recommend: false,
      );
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => MediaPlayerPage(),
        ),
      );
    });
    return const SizedBox.shrink();
  }
}
