import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import './splash.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  final SplashPresenter presenter;

  SplashPage({required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
      appBar: AppBar(title: Text(R.translations.appTitle)),
      body: Builder(builder: (context) {
        handleNavigation(presenter.navigateToStream, clear: true);

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
