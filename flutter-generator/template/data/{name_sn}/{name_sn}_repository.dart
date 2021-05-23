import '{{name}}_model.dart';
import '{{name}}_provider.dart';
import 'package:meta/meta.dart';


// ignore: one_member_abstracts
abstract class I{{name_pc}}Repository {
  Future<{{name_pc}}Model> getAll();
  Future<{{name_pc}}Model> getId(int id);
}

class {{name_pc}}Repository implements I{{name_pc}}Repository {
  {{name_pc}}Repository({this.provider});
  final I{{name_pc}}Provider provider;

  @override
  Future<{{name_pc}}Model> getAll() async {
    final cases = await provider.getAll("/{{name}}");
    if (cases.status.hasError) {
      return Future.error(cases.statusText);
    } else {
      return cases.body;
    }
  }
  @override
  Future<{{name_pc}}Model> getId(int id) async {
    final cases = await provider.getAll("/{{name}}"+id.toString());
    if (cases.status.hasError) {
      return Future.error(cases.statusText);
    } else {
      return cases.body;
    }
  }
}
