import 'package:meta/meta.dart';

import './survey_result.dart';

abstract class SurveyResultPresenter {
  Stream<bool> get isLoadingStream;
  Stream<SurveyResultViewModel> get surveyResultStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();
  Future<void> save({@required String answer});
}
