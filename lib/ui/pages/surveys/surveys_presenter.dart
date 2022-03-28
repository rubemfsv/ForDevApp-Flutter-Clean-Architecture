import 'package:flutter/material.dart';

import 'surveys.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String?> get navigateToStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
}
