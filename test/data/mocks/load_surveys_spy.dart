import 'package:mocktail/mocktail.dart';

import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {
  When mockLoadCall() => when(() => this.load());

  void mockLoad(List<SurveyEntity> surveys) =>
      this.mockLoadCall().thenAnswer((_) async => surveys);

  void mockLoadError(DomainError error) =>
      this.mockLoadCall().thenThrow(error);
}
