import 'package:mocktail/mocktail.dart';

import '../../../lib/data/usecases/load_survey_result/local_load_survey_result.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/domain_error.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    this.mockValidate();
    this.mockSave();
  }

  When mockLoadCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoad(SurveyResultEntity data) =>
      this.mockLoadCall().thenAnswer((_) async => data);
  void mockLoadError() => this.mockLoadCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate(any()));
  void mockValidate() => this.mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => this.mockValidateCall().thenThrow(Exception());

  When mockSaveCall() =>
      when(() => this.save(surveyResult: any(named: 'surveyResult')));
  void mockSave() => this.mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => this.mockSaveCall().thenThrow(Exception());
}
