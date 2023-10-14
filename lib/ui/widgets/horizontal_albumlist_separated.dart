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
import 'package:get/get.dart';
import 'package:neom_commons/core/domain/model/app_media_item.dart';
import 'package:neom_commons/core/domain/model/item_list.dart';
import 'package:neom_commons/core/utils/constants/app_assets.dart';
import 'package:neom_commons/core/utils/enums/itemlist_type.dart';
import 'package:neom_music_player/ui/player/media_player_page.dart';
import 'package:neom_music_player/ui/widgets/custom_physics.dart';
import 'package:neom_music_player/ui/widgets/image_card.dart';
import 'package:neom_music_player/ui/widgets/song_tile_trailing_menu.dart';

class HorizontalAlbumsListSeparated extends StatelessWidget {
  final List<AppMediaItem> songsList;
  final Itemlist? itemlist;
  final Function(int) onTap;
  const HorizontalAlbumsListSeparated({
    super.key,
    required this.songsList,
    required this.onTap,
    this.itemlist,
  });

  String formatString(String? text) {
    return text == null
        ? ''
        : text
            .replaceAll('&amp;', '&')
            .replaceAll('&#039;', "'")
            .replaceAll('&quot;', '"')
            .trim();
  }

  String getSubTitle(Map item) {
    final type = item['type'];
    if (type == 'charts') {
      return '';
    } else if (type == 'playlist' || type == 'radio_station') {
      return formatString(item['subtitle']?.toString());
    } else if (type == 'song') {
      return formatString(item['artist']?.toString());
    } else {
      if (item['subtitle'] != null) {
        return formatString(item['subtitle']?.toString());
      }
      final artists = item['more_info']?['artistMap']?['artists']
          .map((artist) => artist['name'])
          .toList();
      if (artists != null) {
        return formatString(artists?.join(', ')?.toString());
      }
      if (item['artist'] != null) {
        return formatString(item['artist']?.toString());
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool rotated = MediaQuery.of(context).size.height < MediaQuery.of(context).size.width;
    final bool biggerScreen = MediaQuery.of(context).size.width > 1050;
    final double portion = (songsList.length <= 4) ? 1.0 : 0.875;
    final double listSize = rotated ? biggerScreen
        ? MediaQuery.of(context).size.width * portion / 3
        : MediaQuery.of(context).size.width * portion / 2
        : MediaQuery.of(context).size.width * portion;
    return SizedBox(
      height: songsList.length < 4 ? songsList.length * 74 : 74 * 4,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          physics: PagingScrollPhysics(itemDimension: listSize),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemExtent: listSize,
          itemCount: (songsList.length / 4).ceil(),
          itemBuilder: (context, index) {
            final itemGroup = songsList.skip(index * 4).take(4);
            return SizedBox(
              height: 72 * 4,
              width: listSize,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: itemGroup.map((item) {
                  final subTitle = item.name ?? '';// getSubTitle(item as Map);
                  return ListTile(
                    title: Text(
                      formatString(item.name),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      subTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: imageCard(
                      imageUrl: item.imgUrl,
                      placeholderImage: (itemlist?.type == ItemlistType.playlist ||
                              itemlist?.type == ItemlistType.album)
                          ? const AssetImage(AppAssets.musicPlayerAlbum,)
                          : item.artist.isNotEmpty ? const AssetImage(AppAssets.musicPlayerArtist,)
                              : const AssetImage(AppAssets.musicPlayerCover,),
                    ),
                    trailing: SongTileTrailingMenu(
                      appMediaItem: item,//.getTotalItems() > 0 ? AppMediaItem.mapItemsFromItemlist(item).first : AppMediaItem(),
                      itemlist: itemlist ?? Itemlist(),
                      showAddToPlaylist: false,
                    ),
                    onTap: () => onTap(songsList.indexOf(item)),
                    onLongPress: () {
                      Get.to(() => MediaPlayerPage(appMediaItem: item));
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
