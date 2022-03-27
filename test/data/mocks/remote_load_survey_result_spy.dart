import 'package:mocktail/mocktail.dart';

import '../../../lib/data/usecases/load_survey_result/remote_load_survey_result.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/domain_error.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoad(SurveyResultEntity data) =>
      this.mockLoadCall().thenAnswer((_) async => data);

  void mockLoadError(DomainError error) =>
      this.mockLoadCall().thenThrow(error);
}
