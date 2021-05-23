import 'lala_provider.dart';
import 'package:meta/meta.dart';

class LalaRepository {
  final LalaApiClient apiClient;

  LalaRepository({@required this.apiClient}) : assert(apiClient != null);

  getAll() {
    return apiClient.getAll();
  }

  getId(id) {
    return apiClient.getId(id);
  }



}
