import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:hear_mobile/domain/helpers/helpers.dart';
import 'package:hear_mobile/domain/usecases/usecases.dart';

import 'package:hear_mobile/data/http/http.dart';
import 'package:hear_mobile/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient<Map> {}

void main() {
  RemoteAddAccount sut;
  HttpClientSpy httpClient;
  String url;
  String password;
  AddAccountParams params;
  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    password = faker.internet.password();
    params = AddAccountParams(
      name: faker.person.firstName(),
      email: faker.internet.email(),
      password: password,
      passwordConfirmation: password,
    );
    mockHttpData(mockValidData());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(httpClient.request(url: url, method: 'post', body: {
      'name': params.name,
      'email': params.email,
      'password': params.password,
      'passwordConfirmation': params.passwordConfirmation,
    }));
  });

  test('Should return an Account if HpptClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.add(params);

    expect(account.token, validData['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HpptClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HpptClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HpptClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should throw UnexpectedError if HpptClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HpptClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
