import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './splash.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  SplashPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(title: Text("Hear")),
      body: Builder(builder: (context) {
        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
