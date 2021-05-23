import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_podcast/data/episode/episode_model.dart';
import 'package:flutter_podcast/data/episode/episode_provider.dart';
import 'package:flutter_podcast/data/podcast/podcast_provider.dart';
import 'package:device_info/device_info.dart';

import 'package:flutter_podcast/pages/player/presentations/controllers/player_controller.dart';

import '../../../../data/podcast/podcast_repository.dart';
import '../../../../data/podcast/podcast_model.dart';
import 'package:get/get.dart';

class PagePodcastController extends GetxController {
  List<Episode> selectedEpisodes = [];

  // Device info
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};


  var isSelectedEpisodesAvailabale = false.obs;

  // Minimized selected image
  var isImageSelectedPodcastMinimized = false.obs;

  PagePodcastController({this.podcastRepository});

  final IPodcastRepository podcastRepository;

  // Selected podcasts
  var isPodcastSelected = false.obs;
  PodcastModel selectedPodcast;

  // Selected episode
  var isEpisodeSelected = false.obs;
  Episode selectedEpisode;
  Episode toStartEpisode;

  // Changed episode
  var isEpisodeChanged = false.obs;

  // Open search routine
  var isSearchBar = false.obs;

  //Podcasts
  var podcasts = <PodcastModel>[].obs;

  //Device info
  String deviceId;
  String locale;

  @override
  Future<void> onInit() async {
    super.onInit();

    //Loading, Success, Error handle with 1 line of code
    await initPlatformState();
    PodcastProvider()
        .getAll("podcast/" +locale+ "/" +deviceId)
        .then((value) => this.podcasts.value = value.body.podcasts);
    //append(() => podcastRepository.getAll);

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

  bool reverseController() {
    bool res = false;
    if (isSearchBar.isTrue) {
      isSearchBar.value = false;
      res = false;
    } else {
      isSearchBar.value = true;
      res = true;
    }
    print(res);
    return res;
  }

  void fetchPodcasts() {
    var device = "device";
    final String defaultLocale = Platform.localeName;
    if (Platform.isAndroid){
      device = _deviceData["androidId"];
    }
    PodcastProvider()
        .getAll("podcast/" +locale+ "/" +deviceId)
        .then((value) => this.podcasts.value = value.body.podcasts);
  }



  void postEpisodeDuration(int episode, int duration) {
    EpisodeProvider().postEpisodeDuration("episodeDuration", episode, duration);
  }

  void selectPodcast(String id) {
    for (PodcastModel podcast in this.podcasts) {
      if (id == podcast.id) {
        this.selectedPodcast = podcast;
        isPodcastSelected.value = true;
        isImageSelectedPodcastMinimized.value = false;
      }
    }
  }

  PodcastModel getSelectedPodcast() {
    return this.selectedPodcast;
  }

  void setSelectedEpisode(Episode e) {
    PlayerController plc = Get.find();
    this.toStartEpisode = e;
    this.isEpisodeSelected.value = true;
    if (plc.playing.value == false) {
      mergeSelectedEpisode();
    }
    this.isImageSelectedPodcastMinimized.value = false;
    this.isEpisodeChanged.value = !this.isEpisodeChanged.value;
  }

  void mergeSelectedEpisode() {
    if (this.toStartEpisode != null) {
      this.selectedEpisode = this.toStartEpisode;
      this.toStartEpisode = null;
    }
  }



  // TODO create method episode promo
  Episode getPromroEpisodeFromNet() {}

  void minimizeImage() {
    this.isImageSelectedPodcastMinimized.value = true;
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    locale = Platform.localeName;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        deviceId = deviceData["androidId"];
        print(deviceData);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }



  }
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
