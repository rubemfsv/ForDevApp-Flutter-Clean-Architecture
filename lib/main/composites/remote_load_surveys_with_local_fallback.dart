import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  RemoteLoadSurveys remote;
  LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<List<SurveyEntity>> load() async {
    final surveys = await remote.load();
    await local.save(surveys);

    return surveys;
  }
}
