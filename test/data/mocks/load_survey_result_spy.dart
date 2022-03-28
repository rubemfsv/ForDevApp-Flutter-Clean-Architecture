import 'package:mocktail/mocktail.dart';

import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoad(SurveyResultEntity data) =>
      this.mockLoadCall().thenAnswer((_) async => data);

  void mockLoadError(DomainError error) =>
      this.mockLoadCall().thenThrow(error);
}
