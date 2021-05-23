import 'package:get_storage/get_storage.dart';

class Episode {
  int id;
  int porcastId;
  String image;
  String enclosure;
  String length;
  int duration;
  String title;
  String summary;
  String description;
  int same;
  String subtitle;
  String season;
  String episode;
  String episodeType;
  int pubdate;
  int paused;
  int pausedTime;

  Episode(id, porcastId, image, enclosure, length, duration, title, summary,
      description, same, subtitle, season, episode, episodeType, pubdate,
      {paused = 0, pausedTime = 0}) {
    this.id = id;
    this.porcastId = porcastId;
    this.image = image;
    this.enclosure = enclosure;
    this.length = length;
    this.duration = duration;
    this.title = title;
    this.summary = summary;
    this.description = description;
    this.same = same;
    this.subtitle = subtitle;
    this.season = season;
    this.episode = episode;
    this.episodeType = episodeType;
    this.pubdate = pubdate;
    this.paused = paused;
    if (paused == null) {
      this.paused = 0;
    }
    this.pausedTime = pausedTime;
    if (pausedTime == null) {
      this.pausedTime = 0;
    }
  }

  static List<Episode> updateFromLocalStorage(List<Episode> list) {
    GetStorage storage = GetStorage();
    List<Episode> _list = [];
    for (Episode e in list) {
      var mapEpisode = storage.read("e" + e.id.toString());
      if (mapEpisode != null) {
        Episode storageEpisode;
        if (mapEpisode is Episode){
          storageEpisode = mapEpisode;
        }else{
          storageEpisode = Episode.fromJson(mapEpisode);
        }
        if (storageEpisode.paused != null) {
          e.paused = storageEpisode.paused;
          e.pausedTime = storageEpisode.pausedTime;
        }else{
          e.paused = 0;
          e.pausedTime = 0;
        }
      }
      _list.add(e);
    }
    return _list;
  }

  Episode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    porcastId = json['porcast_id'];
    image = json['image'];
    enclosure = json['enclosure'];
    length = json['length'];
    duration = json['duration'];
    title = json['title'];
    summary = json['summary'];
    description = json['description'];
    same = json['same'];
    subtitle = json['subtitle'];
    season = json['season'];
    episode = json['episode'];
    episodeType = json['episode_type'];
    pubdate = json['pubdate'];
    if (json['paused'] == null){
      paused = 0;
    } else {
      paused = json['paused'];
    }
    if (json['pausedTime'] == null){
      pausedTime = 0;
    } else {
      pausedTime = json['pausedTime'];
    }
  }

  setPause(int pause, int pausedTime) {
    this.paused = pause;
    this.pausedTime = pausedTime;
  }

  static List<Episode> listFromJson(list) =>
      List<Episode>.from((list as Iterable).map((x) => Episode.fromJson(x)))
          .toList();

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['porcast_id'] = porcastId;
    data['image'] = image;
    data['enclosure'] = enclosure;
    data['length'] = length;
    data['duration'] = duration;
    data['title'] = title;
    data['summary'] = summary;
    data['description'] = description;
    data['same'] = same;
    data['subtitle'] = subtitle;
    data['season'] = season;
    data['episode'] = episode;
    data['episode_type'] = episodeType;
    data['pubdate'] = pubdate;
    data['paused'] = paused;
    data['pausedTime'] = pausedTime;
    return data;
  }
}
