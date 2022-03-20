import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/domain_error.dart';
import '../../data/usecases/usecases.dart';
import '../../domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  RemoteLoadSurveyResult remote;
  LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback(
      {@required this.remote, @required this.local});

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult: surveyResult);

      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;

      await local.validate(surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}
