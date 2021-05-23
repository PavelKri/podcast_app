
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/data/episode/episode_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marquee/marquee.dart';

import 'package:flutter_podcast/data/episode/episode_provider.dart';
import 'package:flutter_podcast/pages/player/presentations/controllers/player_controller.dart';
import 'package:flutter_podcast/pages/podcast/presentations/controllers/page_podcast_controller.dart';
import 'package:flutter_podcast/playing_sheet.dart';

class AudioPlayerBar extends StatelessWidget {
  AudioPlayerBar() {
    this.plc = Get.put(PlayerController());
    this.ppc = Get.find();
    this.box = GetStorage();

  }

  PlayerController plc;
  PagePodcastController ppc;
  GetStorage box;

  // add it to your class as a static member
  // or as a local variable
  //final player = AudioCache();
  IconData _playButton = Icons.play_arrow;
  IconData _pauseButton = Icons.pause;

  void _playPause(plc) {
    if (plc.isPlaying()) {
      _stop();
    } else {
      _play();
    }
  }

  // call this method when desired
  void _play() async {
    // print("play - " + ppc.selectedEpisode.enclosure.toString());
    plc.play();
    print("play");
  }

  void _stop() async {
    plc.stop();
    print("stop");

  }

  @override
  Widget build(BuildContext context) {
    this.plc = Get.put(PlayerController());
    return GestureDetector(
        onTap: () {
          PlayingSheet().playingModalBottomSheet(context);
        },
        onPanUpdate: (details) {
          if (details.delta.dy < 0) {
            PlayingSheet().playingModalBottomSheet(context);
          }
        },
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 60.0,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
                        child: Obx(
                          () => CachedNetworkImage(
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              width: 55,
                              height: 55,
                              imageUrl: plc.updated.value
                                  ? plc.getEpisode().image
                                  : plc.getEpisode().image),
                        )),
                    Expanded(
                      child: Marquee(
                        text: 'Haftalık Gündem Değerlendirmesi 2020/05',
                        blankSpace: 80.0,
                        velocity: 30.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 0.0,
                      ),
                      child: Obx(
                        () => IconButton(
                          icon: plc.audioPlaying.value
                              ? Icon(_pauseButton)
                              : Icon(_playButton),
                          alignment: Alignment.centerRight,
                          iconSize: 45,
                          onPressed: () {
                            _playPause(plc);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Obx(() => LinearProgressIndicator(
                    color: Colors.green,
                    value: plc.indicator.value,
                    minHeight: 10,
                  ))
            ]));
  }

  Episode getEpisode() {
    var arrKeys = plc.getStorageEpisodesKeys();
    // Selected episode
    if (ppc.selectedEpisode != null) {
      return ppc.selectedEpisode;
      // Newest episode from cache
    } else if (ppc.selectedEpisode == null && ppc.toStartEpisode != null) {
      ppc.mergeSelectedEpisode();
      return ppc.selectedEpisode;
    } else if (ppc.selectedEpisode == null && arrKeys.length > 0) {
      Episode selectedElement;
      int nearestTime = 0;
      for (var key in arrKeys) {
        Episode e = Episode.fromJson(box.read(key));
        if (e.pausedTime > nearestTime) {
          nearestTime = e.pausedTime;
          ppc.selectedEpisode = e;
        }
      }
      if (nearestTime > 0) {
        return ppc.selectedEpisode;
      }
    } else if (ppc.selectedEpisodes.length > 0) {
      ppc.selectedEpisode = ppc.selectedEpisodes[0];
      return ppc.selectedEpisode;
    }
    if (ppc.selectedEpisode == null && arrKeys.length > 0) {
      int nearestTime = 0;
      for (var key in arrKeys) {
        Episode e = Episode.fromJson(box.read(key));
        if (e.pubdate > nearestTime) {
          nearestTime = e.pubdate;
          ppc.selectedEpisode = e;
        }
      }
      if (nearestTime > 0) {
        return ppc.selectedEpisode;
      }
    }
    Episode e = ppc.getPromroEpisodeFromNet();
    ppc.selectedEpisode = e;
    return ppc.selectedEpisode;
  }

  Icon getIcon(PlayerController plc) {
    print(plc);
    return Icon(_playButton);
  }

}
