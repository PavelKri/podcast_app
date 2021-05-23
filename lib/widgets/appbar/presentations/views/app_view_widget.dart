import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/episode/presentations/controllers/episode_controller.dart';
import 'package:flutter_podcast/pages/podcast/presentations/views/main_podcast_body.dart';
import 'package:flutter_podcast/widgets/appbar/presentations/controllers/app_bar_controller.dart';
import 'package:get/get.dart';

class AppBarViewWidget {
  final page;
  AppBar appBar;
  AppBarController abc = Get.put(AppBarController());

  AppBarViewWidget(this.page);

  getWidget() {
    if (page == "podcast") {
      return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: _searchClicked,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[600],
            ),
          ),
          title: TextField(
            autofocus: true,
            decoration: new InputDecoration(
              hintText: 'Search podcast ',
              border: InputBorder.none,
            ),
          ));
    } else if (page == "episode") {
      return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: ((){
              Get.to(MainPodcastBody());
            }),
            icon: Icon(
              Icons.home,
              color: Colors.grey[600],
            ),
          ),
          title: TextField(
            autofocus: true,
            decoration: new InputDecoration(
              hintText: 'Search podcast ',
              border: InputBorder.none,
            ),
          ));
    } else {
      return AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: _searchClicked,
            icon: Icon(
              Icons.backpack,
              color: Colors.grey[600],
            ),
          ));
    }
  }

  void _searchClicked() {
    print("appBar");
  }
}
