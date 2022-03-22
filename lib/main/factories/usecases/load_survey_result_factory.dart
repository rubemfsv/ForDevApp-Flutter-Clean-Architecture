import '../../../domain/usecases/usecases.dart';
import '../../../data/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) {
  return RemoteLoadSurveyResultWithLocalFallback(
    remote: makeRemoteLoadSurveyResult(surveyId),
    local: makeLocalLoadSurveyResult(surveyId),
  );
}
