import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/data/podcast/podcast_model.dart';
import 'package:flutter_podcast/pages/episode/presentations/controllers/episode_controller.dart';
import 'package:flutter_podcast/pages/episode/presentations/views/episode_select_panel.dart';
import 'package:flutter_podcast/pages/player/presentations/views/player_podcast_view.dart';
import 'package:flutter_podcast/pages/podcast/presentations/controllers/page_podcast_controller.dart';
import 'package:flutter_podcast/widgets/appbar/presentations/views/app_view_widget.dart';
import 'package:get/get.dart';
import 'selected_podcast_body.dart';

class EpisodePageView extends StatelessWidget{
  PodcastModel _selectedPodcast;
  SelectedPodcastEpisodesController spec;
  SwitchXListUpdated sx;

  EpisodePageView(PodcastModel podcast){
    this._selectedPodcast = podcast;
    spec = Get.put(SelectedPodcastEpisodesController());
    sx = Get.put(SwitchXListUpdated());
    spec.init();
    spec.selectedPodcast =  this._selectedPodcast;
    spec.fetchEpisodes(int.parse(this._selectedPodcast.id));
  }

  @override
  Widget build(BuildContext context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Podcasts',
        theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
        ),
        home: WillPopScope(
            onWillPop: () async {
              if (true == true) {
                return true;
              } else {
                return false;
              }
            },
            child: Scaffold(
              appBar: AppBarViewWidget("episode").getWidget(),
              body: EpisodeBody(UniqueKey(),this._selectedPodcast),
              bottomNavigationBar: AudioPlayerBar(),
            )));
  }
}
