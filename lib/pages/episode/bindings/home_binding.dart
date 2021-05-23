import 'package:flutter_podcast/data/episode/episode_provider.dart';
import 'package:flutter_podcast/data/episode/episode_repository.dart';
import 'package:flutter_podcast/pages/episode/presentations/controllers/episode_controller.dart';


import 'package:get/get.dart';

class PodcastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IEpisodeProvider>(() => EpisodeProvider());
    Get.lazyPut<IEpisodeRepository>(
        () => EpisodeRepository(provider: Get.find()));
    Get.lazyPut(() => SelectedPodcastEpisodesController(episodeRepository: Get.find()));
  }
}
