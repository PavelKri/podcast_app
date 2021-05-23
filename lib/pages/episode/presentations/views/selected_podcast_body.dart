import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/data/podcast/podcast_model.dart';
import 'package:flutter_podcast/pages/episode/presentations/controllers/episode_controller.dart';
import 'package:flutter_podcast/pages/episode/presentations/views/episode_select_panel.dart';
import 'package:flutter_podcast/utils/utils.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_podcast/listings.dart';

class EpisodeBody extends StatelessWidget {
  PodcastModel _selectedPodcast;

  EpisodeBody(
    Key key, this._selectedPodcast,
  ) {
    // this.podcasts = PodcastProvider().getAll("podcast") as List<PodcastModel>;
  }
  PodcastModel get selectedPodcast => _selectedPodcast;

  @override
  Widget build(BuildContext context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final SelectedPodcastEpisodesController spec =
        Get.put(SelectedPodcastEpisodesController());
    Future.delayed(const Duration(seconds: 3), () {
      // PagePodcastController ppc = Get.find();
      spec.minimizeImage();
    });
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            child: Obx(
              () => spec.isImageSelectedPodcastMinimized.isTrue
                  ? getMinimitzedImage(spec)
                  : AnimatedContainerWidget(spec.selectedPodcast.image)
            ),
          ),
          SelectedPodcastPanel(selectedPodcast),
          Listings(),
        ],
      ),
    );
  }

  Widget getMinimitzedImage(controller) {
    String title = Utils.textToUTF(controller.selectedPodcast.title);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              imageUrl: controller.selectedPodcast.image,
            ),
            title: Text(
              title,
              textScaleFactor: 1.5,
            ),
            subtitle: Text('TWICE'),
          ),
        ],
      ),
    );
  }
}

class AnimatedContainerWidget extends StatefulWidget {
  var image;
  @override
  _AnimatedContainerWidgetState createState() => _AnimatedContainerWidgetState(this.image);
  AnimatedContainerWidget(this.image);
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double _width = 350;
  double _height = 350;
  final src;
  final Color _color = Colors.white;
  final BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  _AnimatedContainerWidgetState(this.src) {
    new Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _width = 100;
        _height = 100;
      });
    });
  }

  get _src => src;

  @override
  Widget build(BuildContext context) {
   return AnimatedContainer(
      // Use the properties stored in the State class.
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: _color,
      ),
      // Define how long the animation should take.
      duration: Duration(seconds: 3),
      // Provide an optional curve to make the animation feel smoother.
      curve: Curves.fastOutSlowIn,
      child: CachedNetworkImage(
        alignment:Alignment.centerLeft,
        placeholder: (context, url) =>
            CircularProgressIndicator(),
        imageUrl: _src,
      ),
    );
  }
}
