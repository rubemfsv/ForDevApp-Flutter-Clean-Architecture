import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';

class AuthorizeHttpClientDecorator {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({@required this.fetchSecureCacheStorage});

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}
