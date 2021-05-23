class PodcastGetResponseModel {
  List<PodcastModel> podcasts;
  List<String> promo;
  PodcastGetResponseModel.fromJson(Map<String, dynamic> json) {
    this.podcasts = PodcastModel.listFromJson(json['podcasts']);
    // this.promo = json['promo'];
  }
}

class PodcastModel {
  String id;
  String image;
  String category;
  String type;
  String title;
  String subtitle;
  String description;
  String link;
  String language;

  PodcastModel(
      {id,
      image,
      category,
      type,
      title,
      subtitle,
      description,
      link,
      language});

  PodcastModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.image = json['image'];
    this.category = json['category'];
    this.type = json['type'];
    this.title = json['title'];
    this.subtitle = json['subtitle'];
    this.description = json['description'];
    this.link = json['link'];
    this.language = json['language'];
  }

  static List<PodcastModel> listFromJson(list) => List<PodcastModel>.from(
      (list as Iterable).map((x) => PodcastModel.fromJson(x))).toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['category'] = this.category;
    data['type'] = this.type;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['description'] = this.description;
    data['link'] = this.link;
    data['language'] = this.language;
    return data;
  }
}
