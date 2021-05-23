import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/episode/presentations/views/episode_main_view.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_podcast/for_you.dart';
import 'package:flutter_podcast/listings.dart';
import 'package:flutter_podcast/pages/podcast/presentations/controllers/page_podcast_controller.dart';

class MainPodcastBody extends StatefulWidget {
  MainPodcastBody(

  ) {
    // this.podcasts = PodcastProvider().getAll("podcast") as List<PodcastModel>;
  }

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<MainPodcastBody> {
  @override
  Widget build(BuildContext context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final PagePodcastController m = Get.find();
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Obx(
            () => Container(
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(4),
                crossAxisCount: 4,
                children: m.podcasts
                    .map((podcast) => GestureDetector(
                          onTap: () {
                            m.selectPodcast(podcast.id);
                            Get.to(EpisodePageView(podcast));
                          },
                          child: Card(
                              child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: podcast.image,
                          )),
                        ))
                    .toList(),
              ),
            ),
          ),
          ForYouPanel(),
          Listings(),
        ],
      ),
    );
  }
}
