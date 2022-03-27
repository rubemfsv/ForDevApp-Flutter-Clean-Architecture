import 'package:mocktail/mocktail.dart';

import '../../../lib/data/usecases/load_surveys/load_surveys.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/domain_error.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {
  When mockLoadCall() => when(() => this.load());

  void mockLoad(List<SurveyEntity> surveys) =>
      this.mockLoadCall().thenAnswer((_) async => surveys);

  void mockLoadError(DomainError error) =>
      this.mockLoadCall().thenThrow(error);
}
