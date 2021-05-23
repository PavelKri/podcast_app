import 'package:flutter_podcast/utils/utils.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'episode_model.dart';

abstract class IEpisodeProvider {
  Future<Response<List<Episode>>> getEpisodes(String path, int id);
  Future<Response<Episode>> getId(String path);
  Future<Response<Episode>> getPromo(String path);
  Future<Response> postEpisodeDuration(String s, int episode, int duration);
}

class EpisodeProvider extends GetConnect implements IEpisodeProvider {
  EpisodeProvider() {
    this.baseUrl = DotEnv.env['HOME_URL'];
    print(this.baseUrl);
  }

  @override
  void onInit() {
    httpClient.baseUrl = this.baseUrl;
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Episode.fromJson(map);
      if (map is List)
        return map.map((item) => Episode.fromJson(item)).toList();
    };
  }

  @override
  Future<Response<List<Episode>>> getEpisodes(String path, int id) async {
    var response = get(path,
        query: {
          'podcast': id.toString(),
        },
        decoder: (list) => Episode.listFromJson(list));
    print(response);
    return response;
  }

  Future<Response<Episode>> postEpisode(Episode episode) async =>
      await post('episode', episode);
  Future<Response> deleteEpisode(int id) async => await delete('episode/$id');

  @override
  Future<Response<Episode>> getId(String path) {
    // TODO: implement getId
    throw UnimplementedError();
  }

  @override
  Future<Response> postEpisodeDuration(
      String s, int episode, int duration) async {
    var data = {
      "episode": episode,
      "duration": duration,
      "hash": Utils.generateMd5(episode.toString() + "podcast"),
    };
    await post(s, data);
  }

  @override
  Future<Response<Episode>> getPromo(String path) {
    // TODO: implement getProm
  }
}
