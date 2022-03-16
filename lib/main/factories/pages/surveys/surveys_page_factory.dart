import 'package:flutter/material.dart';
import './surveys.dart';

import '../../../../ui/pages/pages.dart';

Widget makeSurveysPage() {
  return SurveysPage(makeGetxSurveysPresenter());
}
