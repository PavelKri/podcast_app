import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/pages/player/presentations/views/player_podcast_view.dart';
import 'package:flutter_podcast/widgets/appbar/presentations/views/app_view_widget.dart';
import 'package:get/get.dart';
import '../../../../bottom_bar.dart';
import '../controllers/page_podcast_controller.dart';
import 'main_podcast_body.dart';

class PodcastView extends GetView<PagePodcastController> {
  bool _searchClicked() {
    controller.fetchPodcasts();
    return controller.reverseController();
  }

  @override
  Widget build(BuildContext context) {
    PagePodcastController ppc = Get.find();
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Podcasts',
        theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
        ),
        home: WillPopScope(onWillPop: () async {
          if (ppc.isSearchBar.isTrue) {
            return true;
          } else {
            return false;
          }
        }, child:
           Scaffold(
            appBar: AppBarViewWidget("").getWidget(),
            body: MainPodcastBody(),
            bottomNavigationBar: AudioPlayerBar(),
          )));
  }

  getAppBar() {
    PagePodcastController controller = Get.find();
    if (controller.isSearchBar.value) {
      controller.isPodcastSelected.value = false;
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
    } else if (controller.isPodcastSelected.value) {
      controller.isSearchBar.value = false;
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
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[400],
              backgroundImage: AssetImage('assets/photo.jpg'),
              radius: 17.5,
            ),
          ),
          SizedBox(
            width: 5,
          )
        ],
        title: Image.asset(
          'assets/logo.png',
          height: 35.0,
        ),
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: _searchClicked,
          icon: Icon(
            Icons.search,
            color: Colors.grey[600],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.settings,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
            width: 5,
          )
        ],
        title: Image.asset(
          'assets/logo.png',
          height: 35.0,
        ),
      );
    }
  }

  getBody() {
    PagePodcastController controller = Get.find();
    if (controller.isSearchBar.isTrue) {
      return Container(color: Colors.white);
     } else {
      return MainPodcastBody();
    }
  }
}
