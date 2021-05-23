import '../pages/podcast/bindings/home_binding.dart';

import '../pages/podcast/presentations/views/page_podcast_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

// ignore: avoid_classes_with_only_static_members
class AppPages {
  static const INITIAL = Routes.PODCAST;

  static final routes = [
    GetPage(
        name: Routes.PODCAST,
        page: () => PodcastView(),
        binding: PodcastBinding(),
        children: [
          /*
          GetPage(
            name: Routes.COUNTRY,
            page: () => CountryView(),
            children: [
              GetPage(
                name: Routes.DETAILS,
                page: () => DetailsView(),
              ),
            ],
          ),
          */
        ]),
  ];
}
