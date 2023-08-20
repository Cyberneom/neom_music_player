/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2023, Ankit Sangwan
 */

import 'package:flutter/material.dart';

import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:neom_commons/core/domain/model/app_media_item.dart';
import 'package:neom_music_player/ui/widgets/bouncy_sliver_scroll_view.dart';
import 'package:neom_music_player/ui/widgets/copy_clipboard.dart';
import 'package:neom_music_player/ui/widgets/gradient_containers.dart';
import 'package:neom_music_player/ui/widgets/image_card.dart';
import 'package:neom_music_player/ui/widgets/song_tile_trailing_menu.dart';
import 'package:neom_music_player/neom_player_invoke.dart';
import 'package:neom_music_player/domain/use_cases/youtube_services.dart';
import 'package:neom_music_player/domain/use_cases/yt_music.dart';
import 'package:neom_music_player/utils/constants/player_translation_constants.dart';
import 'package:get/get.dart';

class YouTubeArtist extends StatefulWidget {
  final String artistId;

  const YouTubeArtist({
    super.key,
    required this.artistId,
  });

  @override
  _YouTubeArtistState createState() => _YouTubeArtistState();
}

class _YouTubeArtistState extends State<YouTubeArtist> {
  bool status = false;
  Map<String, dynamic> data = {};
  bool fetched = false;
  bool done = true;
  final ScrollController _scrollController = ScrollController();
  String artistName = '';
  String artistSubtitle = '';
  String artistImage = '';
  List<Map> searchedList = [];

  @override
  void initState() {
    if (!status) {
      status = true;
      YtMusicService().getArtistDetails(widget.artistId).then((value) {
        setState(() {
          try {
            data = value;
            searchedList = data['songs'] as List<Map>;
            artistName = value['name'] as String? ?? '';
            artistSubtitle = value['subtitle'] as String? ?? '';
            artistImage = value['images']?.last as String? ?? '';
            fetched = true;
          } catch (e) {
            AppUtilities.logger.e('Error in fetching artist details', e);
            fetched = true;
          }
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext cntxt) {
    return GradientContainer(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.main75,
        body: Stack(
          children: [
            if (!fetched)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              BouncyImageSliverScrollView(
                scrollController: _scrollController,
                title: artistName,
                imageUrl: artistImage,
                fromYt: true,
                sliverList: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (searchedList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            top: 5.0,
                            bottom: 5.0,
                          ),
                          child: Text(
                            PlayerTranslationConstants.songs.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ...searchedList.map(
                        (Map entry) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: ListTile(
                              leading: imageCard(
                                imageUrl: entry['image'].toString(),
                              ),
                              title: Text(
                                entry['title'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onLongPress: () {
                                copyToClipboard(
                                  context: context,
                                  text: entry['title'].toString(),
                                );
                              },
                              subtitle: entry['subtitle'] == ''
                                  ? null
                                  : Text(
                                      entry['subtitle'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              onTap: () async {
                                setState(() {
                                  done = false;
                                });
                                final AppMediaItem? response = await YouTubeServices().formatVideoFromId(
                                  id: entry['id'].toString(), data: entry,
                                );

                                final Map response2 = await YtMusicService().getSongData(
                                  videoId: entry['id'].toString(),
                                );

                                if (response != null && response2['image'] != null) {
                                  response.imgUrl = response2['image'].toString();
                                }
                                setState(() {
                                  done = true;
                                });

                                if(response != null) {
                                  NeomPlayerInvoke.init(
                                    appMediaItems: [response],
                                    index: 0,
                                    isOffline: false,
                                  );
                                }
                                // for (var i = 0;
                                //     i < searchedList.length;
                                //     i++) {
                                //   YouTubeServices()
                                //       .formatVideo(
                                //     video: searchedList[i],
                                //     quality: Hive.box(AppHiveConstants.settings)
                                //         .get(
                                //           'ytQuality',
                                //           defaultValue: 'Low',
                                //         )
                                //         .toString(),
                                //   )
                                //       .then((songMap) {
                                //     final MediaItem mediaItem =
                                //         MediaItemConverter.mapToMediaItem(
                                //       songMap!,
                                //     );
                                //     addToNowPlaying(
                                //       context: context,
                                //       mediaItem: mediaItem,
                                //       showNotification: false,
                                //     );
                                //   });
                                // }
                              },
                              trailing: YtSongTileTrailingMenu(data: entry),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (!done)
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width / 2,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GradientContainer(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                PlayerTranslationConstants.useHome.tr,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary,
                              ),
                              strokeWidth: 5,
                            ),
                            Text(
                              PlayerTranslationConstants.fetchingStream.tr,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
