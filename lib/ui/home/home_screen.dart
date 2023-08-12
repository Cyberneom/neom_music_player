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

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'package:neom_commons/core/utils/constants/app_assets.dart';
import 'package:neom_music_player/ui/widgets/drawer.dart';
import 'package:neom_music_player/ui/widgets/textinput_dialog.dart';
import 'package:neom_music_player/ui/Home/saavn.dart';
import 'package:neom_music_player/ui/Search/search_page.dart';
import 'package:neom_music_player/utils/constants/app_hive_constants.dart';
import 'package:neom_music_player/utils/constants/player_translation_constants.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String name = Hive.box(AppHiveConstants.settings).get('name', defaultValue: 'Guest') as String;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool rotated = MediaQuery.of(context).size.height < screenWidth;
    return Stack(
      children: [
        NestedScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxScrolled,
          ) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 35,
                backgroundColor: AppColor.main75,
                elevation: 10,
                toolbarHeight: 70,
                automaticallyImplyLeading: false,
                flexibleSpace: LayoutBuilder(
                  builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                  ) {
                    return FlexibleSpaceBar(
                      // collapseMode: CollapseMode.parallax,
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                            child: Image.asset(
                              AppAssets.logoCompanyWhite,
                              height: 70,
                              width: 150,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            )
                          ],
                      ),
                    );
                  },
                ),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: AppColor.main75,
                elevation: 0,
                stretch: true,
                toolbarHeight: 65,
                title: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedBuilder(
                    animation: _scrollController,
                    builder: (context, child) {
                      return GestureDetector(
                        child: AnimatedContainer(
                          width: (!_scrollController.hasClients ||
                                  _scrollController.positions.length > 1)
                              ? MediaQuery.of(context).size.width
                              : max(
                                  MediaQuery.of(context).size.width -
                                      _scrollController.offset.roundToDouble(),
                                  MediaQuery.of(context).size.width -
                                      (rotated ? 0 : 75),
                                ),
                          height: 55.0,
                          duration: const Duration(milliseconds: 150,),
                          padding: const EdgeInsets.all(2.0),
                          // margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0,),
                            color: AppColor.main75,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                offset: Offset(1.5, 1.5),
                                // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10.0,),
                              Icon(
                                CupertinoIcons.search,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 10.0,),
                              Text(
                                PlayerTranslationConstants.searchText.tr,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(
                              query: '',
                              fromHome: true,
                              autofocus: true,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ];
          },
          body: SaavnHomePage(),
        ),
        if (!rotated)
          homeDrawer(
            context: context,
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
          )
      ],
    );
  }
}
