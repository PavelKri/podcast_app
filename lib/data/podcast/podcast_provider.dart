import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:get/get.dart';

import 'podcast_model.dart';

// ignore: one_member_abstracts
abstract class IPodcastProvider {
  Future<Response<PodcastGetResponseModel>> getAll(String s);
  Future<Response<PodcastModel>> getId(String path);
}

class PodcastProvider extends GetConnect implements IPodcastProvider {
  String baseUrl = "";
  PodcastProvider() {
    this.baseUrl = DotEnv.env['HOME_URL'];
    print(this.baseUrl);
  }

  @override
  void onInit() {
    print("start onInit");
    httpClient.defaultDecoder =
        (val) => PodcastModel.fromJson(val as Map<String, dynamic>);
    httpClient.baseUrl = this.baseUrl;
  }

  @override
  Future<Response<PodcastGetResponseModel>>getAll(String path) {
    var response = get(path,
        query: {
          // 'page': '$pageNumber',
        },
        decoder: (podcastsGetResponse) => PodcastGetResponseModel.fromJson(podcastsGetResponse as Map<String, dynamic>));
    print(response);
    return response;
  }

  @override
  Future<Response<PodcastModel>> getId(String path) => get(path);
}
