import 'package:flutter/material.dart';
import 'package:flutter_podcast/data/episode/episode_model.dart';
import 'package:flutter_podcast/data/episode/episode_provider.dart';
import 'package:flutter_podcast/data/episode/episode_repository.dart';
import 'package:flutter_podcast/data/podcast/podcast_model.dart';
import 'package:flutter_podcast/pages/podcast/presentations/controllers/page_podcast_controller.dart';
import 'package:get/get.dart';

class SelectedPodcastEpisodesController extends GetxController
    with SingleGetTickerProviderMixin {
  //TODO: Implement SelectedPodcasPaneltControllerController

  final count = 0.obs;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Description'),
    Tab(text: 'Episodies'),
  ];

  var isSelectedEpisodesAvailabale = false.obs;

  // Minimized selected image
  var isImageSelectedPodcastMinimized = false.obs;

  // Selected podcasts
  var isPodcastSelected = false.obs;
  PodcastModel selectedPodcast;
  final IEpisodeRepository episodeRepository;

  TabController tabController;
  List<Episode> selectedEpisodes = [];
  SelectedPodcastEpisodesController({this.episodeRepository});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);
    tabController.addListener(() {
      print("tap tab controller");
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void fetchEpisodes(int id) {
    EpisodeProvider().getEpisodes("episode", id).then((val) {
      this.selectedEpisodes = Episode.updateFromLocalStorage(val.body);
      new Future.delayed(const Duration(seconds: 1),
          () => this.isSelectedEpisodesAvailabale.value = true);
    });
  }

  void minimizeImage() {
    this.isImageSelectedPodcastMinimized.value = true;
  }

  void init() {
    this.selectedEpisodes = [];
    this.selectedPodcast = null;
    isSelectedEpisodesAvailabale.value = false;
    isImageSelectedPodcastMinimized.value = false;
    isPodcastSelected.value = false;
  }

  void addSelectedPodcast(PodcastModel podcast) {
    this.selectedPodcast = podcast;
    this.isPodcastSelected.value = true;
  }


}
