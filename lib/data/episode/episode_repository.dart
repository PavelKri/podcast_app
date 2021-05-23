import 'episode_model.dart';
import 'episode_provider.dart';

// ignore: one_member_abstracts
abstract class IEpisodeRepository {
  Future<List<Episode>> getEpisode(int podcast, String path);
  Future<Episode> getId(int id);
  Future<Episode> getPromo();
}

class EpisodeRepository implements IEpisodeRepository {
  EpisodeRepository({this.provider});
  final IEpisodeProvider provider;

  @override
  Future<List<Episode>> getEpisode(int id, String path) async {
    final cases = await provider.getEpisodes(path, id);
    if (cases.status.hasError) {
      return Future.error(cases.statusText);
    } else {
      return cases.body;
    }
  }

  @override
  Future<Episode> getId(int id) async {
    final cases = await provider.getId("episode/$id");
    if (cases.status.hasError) {
      return Future.error(cases.statusText);
    } else {
      return cases.body;
    }
  }

  @override
  Future<Episode> getPromo() {
    // TODO: implement getPromo
    throw UnimplementedError();
  }
}
