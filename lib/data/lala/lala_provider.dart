import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'lala_model.dart';

class LalaApiClient {
  String baseUrl = "";
  final http.Client httpClient;
  LalaApiClient(this.httpClient) {
    this.baseUrl = DotEnv.env['HOME_URL'];
  }


getAll() async {
  try {
    var response = await httpClient.get(baseUrl + '/' + 'lala' as Uri);
    if(response.statusCode == 200){
      Iterable jsonResponse = json.decode(response.body);
        List<LalaModel> listMyModel = jsonResponse.map((model) => LalaModel.fromJson(model)).toList();
      return listMyModel;
    }else print ('erro');
  } catch(_){ }
}

getId(id) async {
  try {
    var response = await httpClient.get(baseUrl + '/' + 'lala' +'/'+ id as Uri);
    if(response.statusCode == 200){
      //Map<String, dynamic> jsonResponse = json.decode(response.body);
    }else print ('erro -get');
  } catch(_){ }
}


}
