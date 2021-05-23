
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:get/get.dart';


import '{{name}}_model.dart';

// ignore: one_member_abstracts
abstract class I{{name_pc}}Provider {
  Future<Response<{{name_pc}}Model>> getAll(String path);
  Future<Response<{{name_pc}}Model>> getId(String path);
}

class {{name_pc}}Provider extends GetConnect implements I{{name_pc}}Provider {
  String baseUrl = "";
  PodcastApiClient() {
    this.baseUrl = DotEnv.env['HOME_URL'];
  }
  @override
  void onInit() {
    httpClient.defaultDecoder =
        (val) => {{name_pc}}Model.fromJson(val as Map<String, dynamic>);
    httpClient.baseUrl = this.baseUrl;
  }

  @override
  Future<Response<{{name_pc}}Model>> getAll(String path) => get(path);

  @override
  Future<Response<{{name_pc}}Model>> getId(String path) =>
      get(path);
}
