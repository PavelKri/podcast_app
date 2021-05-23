import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:audiofileplayer/audio_system.dart';
import 'package:flutter/services.dart';
import 'package:flutter_podcast/data/episode/episode_model.dart';
import 'package:flutter_podcast/data/episode/episode_provider.dart';
import 'package:flutter_podcast/pages/podcast/presentations/controllers/page_podcast_controller.dart';
import 'package:logging/logging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

final Logger _logger = Logger("podcast_player");

class PlayerController extends GetxController {
  /// Identifiers for the two custom Android notification buttons.
  static const String replayButtonId = 'replayButtonId';
  static const String newReleasesButtonId = 'newReleasesButtonId';

  /// Preloaded audio data for the first card.
  Audio _audio;
  RxBool audioPlaying = false.obs;
  Episode _playedEpisode = null;
  Episode _promoEpisode = null;
  double _audioDurationSeconds;
  double _audioPositionSeconds;
  double _audioVolume = 1.0;
  double _seekSliderValue = 0.0; // Normalized 0.0 - 1.0.

  /// On-the-fly audio data for the second card.
  int _spawnedAudioCount = 0;
  ByteData _audioByteData;

  /// Remote url audio data for the third card.
  Audio _remoteAudio;
  bool _remoteAudioPlaying = false;
  bool _remoteAudioLoading = false;
  String _remoteErrorMessage;

  /// Background audio data for the fourth card.
  Audio _backgroundAudio;
  bool _backgroundAudioPlaying;
  double _backgroundAudioDurationSeconds;
  double _backgroundAudioPositionSeconds = 0;

  /// Local file data for the fifth card.
  String _documentsPath;
  Audio _documentAudio;
  bool _documentAudioPlaying = false;
  String _documentErrorMessage;

  /// The iOS audio category dropdown item in the last (iOS-only) card.
  IosAudioCategory _iosAudioCategory = IosAudioCategory.playback;

  final count = 0.obs;
  var playing = false.obs;
  var isChangedstate = false.obs;
  var updated = false.obs;
  String localFilePath;
  var box = GetStorage();
  PagePodcastController ppc = Get.find();

  // Current position
  int currentPosition = 0;
  var currentPositionUpdated = false.obs;
  var indicator = 0.05.obs;

  // Calc by 50 secunds
  var timer = 0.obs;

  Future _loadFile(url) async {
    final bytes = await readBytes(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      localFilePath = file.path;
    }
  }

  @override
  void onInit() {
    super.onInit();
    AudioSystem.instance.addMediaEventListener(_mediaEventListener);
    _getSelectedEpisode();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void increment() => count.value++;

  void changeState() {
    this.isChangedstate.value = !this.isChangedstate.value;
  }

  void setUpdate() {
    //this.updated.value = !this.updated.value;
    updateIndicator();
    initTimer();
  }

  Duration getCurrentPosition(int id) {
    Duration res = const Duration(seconds: 0);
    Episode e;
    try {
      var _episode = this.box.read("e" + id.toString());
      if (_episode != null) {
        if (_episode.runtimeType != Episode) {
          e = Episode.fromJson(_episode);
        } else {
          e = _episode;
        }

        if (e.paused > 0) {
          res = Duration(seconds: e.paused);
        }
      }
    } catch (err) {
      print(err.toString());
    }
    return res;
  }

  void savePosition(pausaPosition) {
    if (pausaPosition != 0) {
      ppc.selectedEpisode.paused = pausaPosition;
      for (var e in ppc.selectedEpisodes) {
        if (e.id == ppc.selectedEpisode.id) {
          var pausaTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          if (pausaPosition > e.paused) {
            e = e.setPause(pausaPosition, pausaTime);
            ppc.selectedEpisode.setPause(pausaPosition, pausaTime);
          }
          break;
        }
      }
    }
    box.write('e' + ppc.selectedEpisode.id.toString(), ppc.selectedEpisode);
  }

  List getStorageEpisodesKeys() {
    List res = [];
    var arrKeys = box.getKeys();
    for (var i in arrKeys) {
      print(i);
      if (i.indexOf("e") == 0) {
        res.add(i);
      }
    }
    return res;
  }

  void setCurrentPosition(int i) {
    bool toUpdate = false;
    if ((i + 50) > this.currentPosition) {
      PagePodcastController ppc = Get.find();
      this.indicator.value =
          1 - (ppc.selectedEpisode.duration - i) / ppc.selectedEpisode.duration;
      toUpdate = true;
      this.timer.value++;
    }
    this.currentPosition = i;
    if (toUpdate) {
      currentPositionUpdated.value = !currentPositionUpdated.value;
    }
  }

  void updateIndicator() {
    // PagePodcastController ppc = Get.find();
    // this.indicator.value = 1-(ppc.selectedEpisode.duration - ppc.selectedEpisode.paused) / ppc.selectedEpisode.duration;
  }

  void initTimer() {
    this.timer.value = 0;
  }

  void stop() {
    _pauseBackgroundAudio();
    audioPlaying.value = false;
  }

  void play() {
    if (_remoteAudio == null) _loadRemoteAudio(getUrl());
    // Note call to resume(), not play(). play() attempts to
    // seek to the start of a file, which, for streams, will
    // fail with an error on Android platforms, so streams
    // should use resume() to begin playback.
    _resumeBackgroundAudio();
    audioPlaying.value = true;
  }

  void _loadRemoteAudio(url) {
    _remoteErrorMessage = null;
    _remoteAudioLoading = true;
    _backgroundAudio = Audio.loadFromRemoteUrl(url,
        onDuration: (dur) => _onDuration(dur.toInt()),
        onPosition: (pos) => _saveActualPosition(pos),
        onError: (String message) => _onError(message));
  }

  void postEpisodeDuration(int episode, int duration) {
    EpisodeProvider().postEpisodeDuration("episodeDuration", episode, duration);
  }

  _onDuration(int dur) {
    if (_playedEpisode.duration == 0) {
      postEpisodeDuration(_playedEpisode.id,dur);
    }
    print("Duration - " + dur.toString());
  }

  _onError(String message) {
    print("message");
  }

  /// Listener for transport control events from the OS.
  ///
  /// Note that this example app does not handle all event types.
  void _mediaEventListener(MediaEvent mediaEvent) {
    _logger.info('App received media event of type: ${mediaEvent.type}');
    final MediaActionType type = mediaEvent.type;
    if (type == MediaActionType.play) {
      print("media_action_play");
      _resumeBackgroundAudio();
    } else if (type == MediaActionType.pause) {
      _pauseBackgroundAudio();
    } else if (type == MediaActionType.playPause) {
      _backgroundAudioPlaying
          ? _pauseBackgroundAudio()
          : _resumeBackgroundAudio();
    } else if (type == MediaActionType.stop) {
      _stopBackgroundAudio();
    } else if (type == MediaActionType.seekTo) {
      _backgroundAudio.seek(mediaEvent.seekToPositionSeconds);
      AudioSystem.instance
          .setPlaybackState(true, mediaEvent.seekToPositionSeconds);
    } else if (type == MediaActionType.skipForward) {
      final double skipIntervalSeconds = mediaEvent.skipIntervalSeconds;
      _logger.info(
          'Skip-forward event had skipIntervalSeconds $skipIntervalSeconds.');
      _logger.info('Skip-forward is not implemented in this example app.');
    } else if (type == MediaActionType.skipBackward) {
      final double skipIntervalSeconds = mediaEvent.skipIntervalSeconds;
      _logger.info(
          'Skip-backward event had skipIntervalSeconds $skipIntervalSeconds.');
      _logger.info('Skip-backward is not implemented in this example app.');
    } else if (type == MediaActionType.custom) {
      if (mediaEvent.customEventId == replayButtonId) {
        _backgroundAudio.play();
        AudioSystem.instance.setPlaybackState(true, 0.0);
      } else if (mediaEvent.customEventId == newReleasesButtonId) {
        _logger
            .info('New-releases button is not implemented in this exampe app.');
      }
    }
  }

  Future<void> _resumeBackgroundAudio() async {
    _backgroundAudio.resume();
    final Uint8List imageBytes = await generateImageBytes();
    AudioSystem.instance.setMetadata(AudioMetadata(
        title: "Great title",
        artist: "Great artist",
        album: "Great album",
        genre: "Great genre",
        durationSeconds: _backgroundAudioDurationSeconds,
        artBytes: imageBytes));

    AudioSystem.instance
        .setPlaybackState(true, _backgroundAudioPositionSeconds);

    AudioSystem.instance.setAndroidNotificationButtons(<dynamic>[
      AndroidMediaButtonType.pause,
      AndroidMediaButtonType.stop,
      const AndroidCustomMediaButton(
          'replay', replayButtonId, 'ic_replay_black_36dp')
    ], androidCompactIndices: <int>[
      0
    ]);

    AudioSystem.instance.setSupportedMediaActions(<MediaActionType>{
      MediaActionType.playPause,
      MediaActionType.pause,
      MediaActionType.next,
      MediaActionType.previous,
      MediaActionType.skipForward,
      MediaActionType.skipBackward,
      MediaActionType.seekTo,
    }, skipIntervalSeconds: 30);
  }

  /// Generates a 200x200 png, with randomized colors, to use as art for the
  /// notification/lockscreen.
  static Future<Uint8List> generateImageBytes() async {
    // Random color generation methods: pick contrasting hues.
    final Random random = Random();
    final double bgHue = random.nextDouble() * 360;
    final double fgHue = (bgHue + 180.0) % 360;
    final HSLColor bgHslColor =
        HSLColor.fromAHSL(1.0, bgHue, random.nextDouble() * .5 + .5, .5);
    final HSLColor fgHslColor =
        HSLColor.fromAHSL(1.0, fgHue, random.nextDouble() * .5 + .5, .5);

    final Size size = const Size(200.0, 200.0);
    final Offset center = const Offset(100.0, 100.0);
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Rect rect = Offset.zero & size;
    final Canvas canvas = Canvas(recorder, rect);
    final Paint bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = bgHslColor.toColor();
    final Paint fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = fgHslColor.toColor()
      ..strokeWidth = 8;
    // Draw background color.
    canvas.drawRect(rect, bgPaint);
    // Draw 5 inset squares around the center.
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
          Rect.fromCenter(center: center, width: i * 40.0, height: i * 40.0),
          fgPaint);
    }
    // Render to image, then compress to PNG ByteData, then return as Uint8List.
    final ui.Image image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final ByteData encodedImageData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return encodedImageData.buffer.asUint8List();
  }

  bool isPlaying() {
    return this.audioPlaying.value;
  }

  void _pauseBackgroundAudio() {
    _backgroundAudio.pause();
    _storageEpisode();
    audioPlaying.value = false;
    AudioSystem.instance
        .setPlaybackState(false, _backgroundAudioPositionSeconds);

    AudioSystem.instance.setAndroidNotificationButtons(<dynamic>[
      AndroidMediaButtonType.play,
      AndroidMediaButtonType.stop,
      const AndroidCustomMediaButton(
          'new releases', newReleasesButtonId, 'ic_new_releases_black_36dp'),
    ], androidCompactIndices: <int>[
      0
    ]);

    AudioSystem.instance.setSupportedMediaActions(<MediaActionType>{
      MediaActionType.playPause,
      MediaActionType.play,
      MediaActionType.next,
      MediaActionType.previous,
    });
  }

  void _stopBackgroundAudio() {
    _backgroundAudio.pause();
    audioPlaying.value = false;
    AudioSystem.instance.stopBackgroundDisplay();
  }

  String getUrl() {
    return _playedEpisode.enclosure;
  }

  void setSelectedEpisode(Episode ep) {
    _playedEpisode = ep;
    updated.value = !updated.value;
  }

  Episode getEpisode() {
    return _playedEpisode;
  }

  void _saveActualPosition(double pos) {
    _audioPositionSeconds = pos;
    // print("Position - "+pos.toString());
  }

  void _storageEpisode() {
    var pausaTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (_audioPositionSeconds > _playedEpisode.paused) {
      _playedEpisode.setPause(_audioPositionSeconds.toInt(), pausaTime);
    }
    this.box.write("e" + _playedEpisode.id.toString(), _playedEpisode);
    this.box.write("se", _playedEpisode);
  }

  void _getSelectedEpisode() {
    var jsonEpisode = box.read("se");
    if (jsonEpisode != null) {
      _playedEpisode = Episode.fromJson(jsonEpisode);
    }
  }
}
