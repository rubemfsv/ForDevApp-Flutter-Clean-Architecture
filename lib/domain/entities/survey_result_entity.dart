import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final bool didAnswer;

  List get props => [surveyId, question, didAnswer];

  @override
  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.didAnswer,
  });
}
