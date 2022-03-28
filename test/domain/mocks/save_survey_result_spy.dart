import 'package:mocktail/mocktail.dart';

import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/domain/helpers/domain_error.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveSurveyResultCall() =>
      when(() => this.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) =>
      mockSaveSurveyResultCall().thenAnswer((_) async => data);

  void mockSaveSurveyResultError(DomainError error) =>
      mockSaveSurveyResultCall().thenThrow(error);
}
