import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: "get");

    return httpResponse
        .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}
