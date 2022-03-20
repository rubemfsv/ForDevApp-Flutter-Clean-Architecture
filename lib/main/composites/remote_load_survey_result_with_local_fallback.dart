import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/domain_error.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  RemoteLoadSurveyResult remote;
  LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<void> loadBySurvey({String surveyId}) async {
    final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: surveyResult);
  }
}
