import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_podcast/pages/episode/presentations/controllers/episode_controller.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

import 'package:flutter_podcast/data/episode/episode_model.dart';
import 'package:flutter_podcast/data/podcast/podcast_model.dart';
import 'package:flutter_podcast/pages/player/presentations/controllers/player_controller.dart';
import 'package:flutter_podcast/utils/utils.dart';
import 'package:get/get.dart';

import 'package:flutter_podcast/pages/podcast/presentations/controllers/page_podcast_controller.dart';

class SelectedPodcastPanel extends StatelessWidget {
  PodcastModel selectedPodcast;
  SelectedPodcastEpisodesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var listHeight = MediaQuery.of(context).size.height - 110;

    controller.isSelectedEpisodesAvailabale.value = false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 0),
              ),
            ),
            Container(
                child: TabBar(
              isScrollable: true,
              controller: controller.tabController,
              labelStyle: TextStyle(fontSize: 25),
              tabs: getTabs(),
            )),
            Divider(),
            getTabViewContainer(listHeight)
          ],
        ),
      ),
    );
  }

  getTabs() {
    return this.controller.myTabs;
  }

  getTabViewContainer(height) {
    SelectedPodcastEpisodesController controller = Get.find();
    SwitchXListUpdated sx = Get.find();
    return Container(
      height: height,
      child: TabBarView(
        controller: controller.tabController,
        physics: ScrollPhysics(),
        children: <Widget>[
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  // Text(
                  Html(
                data: getDescription(this.selectedPodcast),
                defaultTextStyle: TextStyle(fontSize: 15),
              ),
              // textAlign: TextAlign.center,
              //  ),
            ),
          ),
          Card(
            elevation: 0,
            child: Obx(() => controller.isSelectedEpisodesAvailabale.value
                ? ListView.builder(
                    physics: ScrollPhysics(),
                    primary: true,
                    itemCount: controller.selectedEpisodes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: GestureDetector(
                            onTap: () =>
                                tapGesture(controller.selectedEpisodes[index]),
                            child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(Utils.getIntColor(
                                    controller.selectedEpisodes[index].title)),
                                child: Text(
                                  getText(
                                      controller.selectedEpisodes[index].title),
                                  textScaleFactor: 2,
                                )),
                          ),
                          title: Text(covertToUTFandSubstring(
                              controller.selectedEpisodes[index].title, 45)),
                          subtitle: Text(Utils.getTimesAgo(
                                  controller.selectedEpisodes[index].pubdate) +
                              " Duration :" +
                              geDuration(controller.selectedEpisodes[index])),
                          trailing: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                imageUrl:
                                    controller.selectedEpisodes[index].image,
                              ),
                            ),
                          ),
                        ),
                        LinearProgressIndicator(
                          backgroundColor: Colors.white70,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                          value:
                              _getIndicator(controller.selectedEpisodes[index]),
                        ),
                      ]);
                    })
                : SizedBox()),
          ),
        ],
      ),
    );
  }

  getDescription(PodcastModel podcast) {
    String htmlOpeningString = "<!DOCTYPE html><html><body>";
    String htmlClosingString = "</body></html>";
    return (htmlOpeningString +
        utf8.decode(podcast.description.runes.toList()) +
        htmlClosingString);
  }

  List<Widget> getEpisodesList() {
    SelectedPodcastEpisodesController c = Get.find();
    List<Episode> episodes = c.selectedEpisodes;
    List<Widget> arrwWidgets = [];
    if (episodes != null) {
      for (Episode e in episodes) {
        print(e.title);
        arrwWidgets.add(
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  imageUrl: e.image,
                ),
              ),
            ),
            title: Text(covertToUTFandSubstring(e.title, 45)),
            subtitle: Text(
                Utils.getTimesAgo(e.pubdate) + " Duration :" + geDuration(e)),
            trailing: XGestureDetector(
              // onTap: onListItemTap(e),
              child: CircleAvatar(
                backgroundColor: Colors.green,
              ),
            ),
            onTap: onListItemTap(e),
          ),
          /*
          doubleTapTimeConsider: 300,
          longPressTimeConsider: 350,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onLongPressEnd: onLongPressEnd,
          onMoveStart: onMoveStart,
          onMoveEnd: onMoveEnd,
          onMoveUpdate: onMoveUpdate,
          onScaleStart: onScaleStart,
          onScaleUpdate: onScaleUpdate,
          onScaleEnd: onScaleEnd,
          bypassTapEventOnDoubleTap: false,
          */
        );
        if (e.paused > 0) {
          var indicatorValue = 1 / (e.duration / e.paused);
          arrwWidgets.add(LinearProgressIndicator(
            backgroundColor: Colors.white70,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.green,
            ),
            value: indicatorValue < 0.05 ? 0.05 : indicatorValue,
          ));
        }

        arrwWidgets.add(Divider(height: 0));
      }
    }
    arrwWidgets.add(ListTile(
      leading: Icon(
        Icons.arrow_forward,
        color: Colors.blueAccent,
      ),
      title: Text(
        'All new Episodes',
        style: TextStyle(color: Colors.blueAccent, letterSpacing: 0),
      ),
      onTap: () {},
    ));
    return arrwWidgets;
  }

  String covertToUTFandSubstring(String str, int length) {
    String _str = utf8.decode(str.runes.toList());
    if (_str.length <= length) {
      return _str;
    } else {
      return _str.substring(0, length - 3) + "...";
    }
  }

  onListItemTap(e) {
    print("press");
    PagePodcastController ppc = Get.find();
    PlayerController plc = Get.find();
    ppc.setSelectedEpisode(e);
    plc.setUpdate();
  }

  SelectedPodcastPanel(PodcastModel podcast) {
    this.selectedPodcast = podcast;
  }

  tapGesture(Episode ep) {
    PlayerController plc = Get.find();
    plc.setSelectedEpisode(ep);
    print(ep.enclosure);
  }

  String getText(String title) {
    title = Utils.textToUTF(title);
    var res = "";
    for (var i = 0; i < title.length; i++) {
      if (title[i] == " " ||
          title[i] == "," ||
          title[i] == "-" ||
          title[i] == "." ||
          title[i] == "#" ||
          title[i] == "»" ||
          title[i] == "«" ||
          title[i] == ":" ||
          title[i] == "\"") {
        continue;
      }
      if (title[i].toUpperCase() == title[i]) {
        res += title[i];
        if (res.length == 2) {
          break;
        }
      }
    }
    return res;
  }

  String getHexColor(String str) {
    String strMD5 = "0xff" + Utils.generateMd5(str).substring(0, 6);
    return strMD5;
  }

  double _getIndicator(Episode selectedEpisode) {
    if (selectedEpisode.paused == 0) return 0.0;
    if (selectedEpisode.duration == 0) selectedEpisode.duration = (int.parse(selectedEpisode.length) ~/ 24000);
    double res = 1 / (selectedEpisode.duration / selectedEpisode.paused);
    if (res < 0.05) return 0.05;
    return res;
  }
}

String geDuration(Episode e) {
  if (e.duration == 0) {
    return Utils.getMinutsFromLength(e.length);
  } else {
    return Utils.getMinutsFromDuration(e.duration);
  }
}

/// GetX Controller for holding Switch's current value
class SwitchXListUpdated extends GetxController {
  RxBool isListAvailable = false.obs; // our observable
  // swap true/false & save it to observable
  void setAvailable(bool val) => isListAvailable.value = val;
}
