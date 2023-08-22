import 'package:http/http.dart' as http;

// http 응답을 받아 error message를 반환하는 함수
String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final errorMessage =
      'Request failed\nStatus code: $statusCode\nReason: $reasonPhrase';

  return errorMessage;
}
