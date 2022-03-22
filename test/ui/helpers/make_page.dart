import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makePage(
    {required String initialRoute, required Widget Function() page}) {
  final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());
  final getPages = [
    GetPage(name: initialRoute, page: page),
    GetPage(
      name: '/any_route',
      page: () => Scaffold(
        appBar: AppBar(title: Text('any title')),
        body: Text('fake page'),
      ),
    ),
  ];

  if (initialRoute != '/login') {
    getPages.add(GetPage(
      name: '/login',
      page: () => Scaffold(
        body: Text('fake login'),
      ),
    ));
  }

  return GetMaterialApp(
    initialRoute: initialRoute,
    navigatorObservers: [routeObserver],
    getPages: getPages,
  );
}
