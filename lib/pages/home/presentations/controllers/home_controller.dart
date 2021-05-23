import 'package:flutter_podcast/data/podcast/podcast_provider.dart';

import '../../../../data/podcast/podcast_repository.dart';
import '../../../../data/podcast/podcast_model.dart';
import 'package:get/get.dart';

class HomeController extends SuperController<PodcastModel> {
  var podcasts = <PodcastModel>[].obs;

  HomeController({this.podcastRepository});

  void fetchPodcasts() {
    PodcastProvider().getAll("podcast").then((val) => print(val.body.podcasts));
  }

  final IPodcastRepository podcastRepository;

  @override
  void onInit() {
    super.onInit();

    //Loading, Success, Error handle with 1 line of code
    PodcastProvider().getAll("podcast").then((value) {
      this.podcasts = value.body.podcasts;
    });
  }

  @override
  void onReady() {
    print('The build method is done. '
        'Your controller is ready to call dialogs and snackbars');
    super.onReady();
  }

  @override
  void onClose() {
    print('onClose called');
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    print('the window size did change');
    super.didChangeMetrics();
  }

  @override
  void didChangePlatformBrightness() {
    print('platform change ThemeMode');
    super.didChangePlatformBrightness();
  }

  @override
  Future<bool> didPushRoute(String route) {
    print('the route $route will be open');
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPopRoute() {
    print('the current route will be closed');
    return super.didPopRoute();
  }

  @override
  void onDetached() {
    print('onDetached called');
  }

  @override
  void onInactive() {
    print('onInative called');
  }

  @override
  void onPaused() {
    print('onPaused called');
  }

  @override
  void onResumed() {
    print('onResumed called');
  }
}
