import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hear_mobile/ui/pages/surveys/components/survey_item.dart';
import '../../helpers/i18n/i18n.dart';

class SurveysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(R.translations.surveys)),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CarouselSlider(
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 1,
          ),
          items: [SurveyItem(), SurveyItem(), SurveyItem()],
        ),
      ),
    );
  }
}
