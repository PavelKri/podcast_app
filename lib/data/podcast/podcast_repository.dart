import 'dart:io';

import 'podcast_model.dart';
import 'package:get/get.dart';
import 'podcast_provider.dart';
import 'package:meta/meta.dart';

// ignore: one_member_abstracts
abstract class IPodcastRepository {
  Future<PodcastGetResponseModel> getAll();
  Future<PodcastModel> getId(int id);
}

class PodcastRepository implements IPodcastRepository {
  PodcastRepository({this.provider});
  final IPodcastProvider provider;

  @override
  Future<PodcastGetResponseModel> getAll() async {
    final rsp = await provider.getAll("podcast");
    // rsp.body.map((val) => PodcastModel.fromJson(val as Map<String,dynamic>)).cast<PodcastModel>().toList();
    // rsp.body.map((e) => e).toList().cast<List<PodcastModel>>();

    if (rsp.status.hasError) {
      return Future.error(rsp.statusText);
    } else {
      return rsp.body;
    }
    /*
    print(rsp.body);
    if (rsp.statusCode != 400) {
      var responseBode = rsp.body;
      // json.decode(responseBode)
      List<PodcastModel> res = responseBode
          .map((obj) => PodcastModel.fromJson(obj))
          .toList()
          .cast<PodcastModel>();
      // print(res.toString());
      return res;
    }
    */
  }

  @override
  Future<PodcastModel> getId(int id) async {
    final cases = await provider.getId("/podcast" + id.toString());
    if (cases.status.hasError) {
      return Future.error(cases.statusText);
    } else {
      return cases.body;
    }
  }
}
