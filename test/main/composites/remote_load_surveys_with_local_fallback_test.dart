import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/main/composites/composites.dart';
import 'package:hear_mobile/data/usecases/usecases.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });
  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });
}
