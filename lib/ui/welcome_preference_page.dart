import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:neom_commons/core/app_flavour.dart';
import 'package:neom_commons/core/data/implementations/user_controller.dart';
import 'package:neom_commons/core/utils/app_color.dart';
import 'widgets/gradient_containers.dart';
import 'widgets/snackbar.dart';
import '../utils/constants/app_hive_constants.dart';
import '../utils/constants/countrycodes.dart';
import '../utils/constants/music_player_constants.dart';
import '../utils/constants/player_translation_constants.dart';

class WelcomePreferencePage extends StatefulWidget {
  const WelcomePreferencePage({super.key});

  @override
  _WelcomePreferencePageState createState() => _WelcomePreferencePageState();
}

class _WelcomePreferencePageState extends State<WelcomePreferencePage> {

  List<bool> isSelected = [true, false];
  List preferredLanguage = Hive.box(AppHiveConstants.settings).get('preferredLanguage', defaultValue: ['Español'])?.toList() as List;
  String region = Hive.box(AppHiveConstants.settings).get('region', defaultValue: 'México') as String;
  bool useProxy = Hive.box(AppHiveConstants.settings).get('useProxy', defaultValue: false) as bool;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: AppColor.main50,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: MediaQuery.of(context).size.width / 1.5,
                child: Image(
                  image: AssetImage(AppFlavour.getIconPath(),),
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 4,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.popAndPushNamed(context, '/');
                        },
                        child: Text(
                          PlayerTranslationConstants.skip.tr,
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '${PlayerTranslationConstants.welcome.tr}\n',
                                  style: TextStyle(
                                    fontSize: 46,
                                    height: 1.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          PlayerTranslationConstants.aboard.tr,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 52,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '!\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 54,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: PlayerTranslationConstants.tryOurMusicPlayer.tr,
                                      style: TextStyle(
                                        height: 1.5,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    title: Text(
                                      PlayerTranslationConstants.langQue.tr,
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                        right: 10,
                                      ),
                                      height: 57.0,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: AppColor.bondiBlue75,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 3.0),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          preferredLanguage.isEmpty
                                              ? 'None'
                                              : preferredLanguage.join(', '),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                    dense: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: AppColor.main25,
                                        context: context,
                                        builder: (BuildContext context) {
                                          final List checked = List.from(preferredLanguage);
                                          return StatefulBuilder(
                                            builder: (
                                              BuildContext context,
                                              StateSetter setStt,
                                            ) {
                                              return BottomGradientContainer(
                                                borderRadius: BorderRadius.circular(20.0,),
                                                hasOpacity: true,
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: ListView.builder(
                                                        physics: const BouncingScrollPhysics(),
                                                        shrinkWrap: true,
                                                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10,),
                                                        itemCount: MusicPlayerConstants.musicLanguages.length,
                                                        itemBuilder: (context, idx) {
                                                          return CheckboxListTile(
                                                            activeColor: Theme.of(context,).colorScheme.secondary,
                                                            value: checked.contains(MusicPlayerConstants.musicLanguages[idx],),
                                                            title: Text(MusicPlayerConstants.musicLanguages[idx],),
                                                            onChanged: (bool? value,) {
                                                              value! ? checked.add(MusicPlayerConstants.musicLanguages[idx],)
                                                                  : checked.remove(MusicPlayerConstants.musicLanguages[idx],);
                                                              setStt(() {});
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: Theme.of(context,).colorScheme.secondary,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context,);
                                                          },
                                                          child: Text(PlayerTranslationConstants.cancel.tr,),
                                                        ),
                                                        TextButton(
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: Theme.of(context,).colorScheme.secondary,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              preferredLanguage = checked;
                                                              Navigator.pop(context,);
                                                              Hive.box('settings',).put('preferredLanguage', checked,);
                                                            });
                                                            if (preferredLanguage.isEmpty) {
                                                              ShowSnackBar().showSnackBar(context,
                                                                PlayerTranslationConstants.noLangSelected.tr,
                                                              );
                                                            }
                                                          },
                                                          child: Text(
                                                            PlayerTranslationConstants.ok.tr,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20.0,),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 5.0,),
                                    title: Text(PlayerTranslationConstants.countryQue.tr,),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      height: 57.0,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: AppColor.bondiBlue75,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 3.0),
                                          ),
                                        ],
                                      ),
                                      child: Center(child: Text(region, textAlign: TextAlign.end,),),
                                    ),
                                    dense: true,
                                    onTap: () {
                                      showModalBottomSheet(
                                        isDismissible: true,
                                        backgroundColor: AppColor.main75,
                                        context: context,
                                        builder: (BuildContext context) {
                                          const Map<String, String> codes = CountryCodes.localChartCodes;
                                          final List<String> countries = codes.keys.toList();
                                          return BottomGradientContainer(
                                            borderRadius: BorderRadius.circular(20.0),
                                            child: ListView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10,),
                                              itemCount: countries.length,
                                              itemBuilder: (context, idx) {
                                                return ListTileTheme(
                                                  selectedColor: Theme.of(context).colorScheme.secondary,
                                                  child: ListTile(
                                                    contentPadding: const EdgeInsets.only(left: 25.0, right: 25.0,),
                                                    title: Text(countries[idx],),
                                                    trailing: region == countries[idx] ? const Icon(Icons.check_rounded,) : const SizedBox(),
                                                    selected: region == countries[idx],
                                                    onTap: () {
                                                      region = countries[idx];
                                                      Hive.box(AppHiveConstants.settings).put('region', region,);
                                                      Navigator.pop(context,);
                                                      setState(() {});
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20.0,),
                                  GestureDetector(
                                    onTap: () {
                                      final userController = Get.find<UserController>();
                                      Hive.box(AppHiveConstants.settings).put('userId', userController.user!.id,);
                                      Navigator.popAndPushNamed(context, '/',);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                      ),
                                      height: 55.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 3.0),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          PlayerTranslationConstants.finish.tr,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
