import '../../../data/podcast/podcast_provider.dart';
import '../../../data/podcast/podcast_repository.dart';

import '../presentations/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPodcastProvider>(() => PodcastProvider());
    Get.lazyPut<IPodcastRepository>(
        () => PodcastRepository(provider: Get.find()));
    Get.lazyPut(() => HomeController(podcastRepository: Get.find()));
  }
}
