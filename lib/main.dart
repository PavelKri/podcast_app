import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_podcast/pages/player/presentations/views/player_podcast_view.dart';

import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'package:flutter_podcast/bottom_bar.dart';
import 'package:flutter_podcast/body.dart';
import 'package:get_storage/get_storage.dart';

import 'bottom_bar.dart';
import 'lang/translation-service.dart';
import 'routes/app_pages.dart';
import 'shared/logger/logger_utils.dart';

Future main() async {
  await DotEnv.load();
  await GetStorage.init();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // status bar color
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      logWriterCallback: Logger.write,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
    );
  }
}

List<String> channels = [
  'teknoseyir.jpg',
  'acikbilim.jpg',
  'dnomak.jpg',
  'yalinkod.jpg',
  'unsalunlu.jpg',
  'teknolojivebilimnotlari.jpg',
  'oyungundemi.jpg',
  'mesutcevik.jpg',
  'gelecekbilimde.jpg',
  'studio71.jpg'
];

class MyApp1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  bool _searchbar = false;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    channels.shuffle();
    super.initState();
  }

  void _searchClicked() {
    setState(() {
      _searchbar = !_searchbar;
    });
  }

  Future<bool> _onBackPressed() {
    setState(() {
      _searchbar = false;
    });
    Navigator.pop(context, false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Podcasts',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
      ),
      home: WillPopScope(
        onWillPop: () async {
          if (_searchbar)
            return _onBackPressed();
          else
            return true;
        },
        child: Scaffold(
          appBar: _searchbar
              ? AppBar(
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
                  ))
              : AppBar(
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
                ),
          body: _searchbar
              ? Container(color: Colors.white)
              : Body(channels: channels),
          bottomNavigationBar: SizedBox()// AudioPlayerBar(ppc PagePodcastController()),
        ),
      ),
    );
  }
}
