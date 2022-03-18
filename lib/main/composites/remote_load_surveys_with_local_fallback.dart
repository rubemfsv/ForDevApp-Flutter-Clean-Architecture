import 'package:meta/meta.dart';

import 'package:hear_mobile/data/usecases/usecases.dart';
import '../../domain/entities/entities.dart';

class RemoteLoadSurveysWithLocalFallback {
  RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({@required this.remote});

  Future<void> load() async {
    await remote.load();
  }
}
