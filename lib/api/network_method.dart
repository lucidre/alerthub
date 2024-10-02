import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alerthub/common_libs.dart';

const String hostUrl = 'https://alerthub-demo.onrender.com/api/v1/';

final Map<String, String> defaultHeaders = {
  'content-type': 'application/json',
  "accept": "application/json",
  "apiUsername": "temp",
};

print(String text) {
  debugPrint(text);
}

Future<NetworkResponse> $post(
  String url, {
  Map<String, dynamic> body = const {},
  Map<String, String>? headers,
  String? accessToken,
  bool addAutorization = true,
}) async {
  final authorization = accessToken ?? '';

  try {
    print("$hostUrl$url");
    print({
      ...defaultHeaders,
      ...(headers ?? {}),
      if (addAutorization && authorization.isNotEmpty)
        'Authorization': 'Bearer $authorization',
    }.toString());
    print(jsonEncode(body).toString());

    final response = await http.post(
      Uri.parse("$hostUrl$url"),
      body: jsonEncode(body),
      headers: {
        ...defaultHeaders,
        ...(headers ?? {}),
        if (addAutorization && authorization.isNotEmpty)
          'Authorization': 'Bearer $authorization',
      },
    );

    final jsonData = jsonDecode(response.body);
    print(response.statusCode.toString());
    print(jsonData.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        jsonData,
        false,
        response.statusCode,
        jsonData['message'],
      );
    } else {
      return NetworkResponse(
        jsonData,
        true,
        response.statusCode,
        jsonData['message'],
      );
    }
  } catch (exception) {
    print('EXCEPTION:   ${exception.toString()}');
    throw exception.toString();
  }
}

Future<NetworkResponse> $patch(
  String url, {
  Map<String, dynamic> body = const {},
  Map<String, String>? headers,
  String? accessToken,
  bool addAutorization = true,
}) async {
  final authorization = accessToken ?? '';

  try {
    print("$hostUrl$url");

    print({
      ...defaultHeaders,
      ...(headers ?? {}),
      if (addAutorization && authorization.isNotEmpty)
        'Authorization': 'Bearer $authorization',
    }.toString());
    print(jsonEncode(body).toString());

    final response = await http.patch(
      Uri.parse("$hostUrl$url"),
      body: jsonEncode(body),
      headers: {
        ...defaultHeaders,
        ...(headers ?? {}),
        if (addAutorization && authorization.isNotEmpty)
          'Authorization': 'Bearer $authorization',
      },
    );
    print('response: ${response.statusCode}');
    print('body:  ${response.body.toString()}');
    print('body:  ${response.request.toString()}');
    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        jsonData,
        false,
        response.statusCode,
        jsonData['message'],
      );
    } else {
      return NetworkResponse(
        jsonData,
        true,
        response.statusCode,
        jsonData['message'],
      );
    }
  } catch (exception) {
    print('EXCEPTION:   ${exception.toString()}');
    throw exception.toString();
  }
}

Future<NetworkResponse> $put(
  String url, {
  Map<String, dynamic> body = const {},
  String? accessToken,
  Map<String, String>? headers,
  bool addAutorization = true,
}) async {
  final authorization = accessToken ?? '';

  try {
    print("url: $hostUrl$url");
    print('header: ${{
      ...defaultHeaders,
      ...(headers ?? {}),
      if (addAutorization && authorization.isNotEmpty)
        'Authorization': 'Bearer $authorization',
    }.toString()}');

    print('body: ${jsonEncode(body)}');

    final response = await http.put(
      Uri.parse("$hostUrl$url"),
      body: jsonEncode(body),
      headers: {
        ...defaultHeaders,
        ...(headers ?? {}),
        if (addAutorization && authorization.isNotEmpty)
          'Authorization': 'Bearer $authorization',
      },
    );

    final jsonData = jsonDecode(response.body);
    print('response: ${response.statusCode}');
    print(jsonData.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        jsonData,
        false,
        response.statusCode,
        jsonData['message'],
      );
    } else {
      return NetworkResponse(
        jsonData,
        true,
        response.statusCode,
        jsonData['message'],
      );
    }
  } catch (exception) {
    print('EXCEPTION:   ${exception.toString()}');
    throw exception.toString();
  }
}

Future<NetworkResponse> $get(
  String url, {
  Map<String, String>? headers,
  String? accessToken,
  bool addAutorization = true,
}) async {
  final authorization = accessToken ?? '';

  try {
    final response = await http.get(
      Uri.parse("$hostUrl$url"),
      headers: {
        ...defaultHeaders,
        ...(headers ?? {}),
        if (addAutorization && authorization.isNotEmpty)
          'Authorization': 'Bearer $authorization',
      },
    );
    print("url: $hostUrl$url");
    print('header: ${{
      ...defaultHeaders,
      ...(headers ?? {}),
      if (addAutorization && authorization.isNotEmpty)
        'Authorization': 'Bearer $authorization',
    }}');
    final jsonData = jsonDecode(response.body);
    print('response: ${response.statusCode}');
    print('response: $jsonData');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        jsonData,
        false,
        response.statusCode,
        jsonData['message'],
      );
    } else if (response.statusCode == 500) {
      throw 'Something went wrong. Please retry later.';
    } else {
      return NetworkResponse(
        jsonData,
        true,
        response.statusCode,
        jsonData['message'],
      );
    }
  } catch (exception) {
    print('EXCEPTION:   ${exception.toString()}');
    throw exception.toString();
  }
}

Future<NetworkResponse> $delete(
  String url, {
  Map<String, String>? headers,
  String? accessToken,
  bool addAutorization = true,
}) async {
  final authorization = accessToken ?? '';

  try {
    final response = await http.delete(
      Uri.parse("$hostUrl$url"),
      headers: {
        ...defaultHeaders,
        ...(headers ?? {}),
        if (addAutorization && authorization.isNotEmpty)
          'Authorization': 'Bearer $authorization',
      },
    );
    print("$hostUrl$url");
    print({
      ...defaultHeaders,
      ...(headers ?? {}),
      if (addAutorization && authorization.isNotEmpty)
        'Authorization': 'Bearer $authorization',
    }.toString());

    final jsonData = jsonDecode(response.body);
    print('response: ${response.statusCode}');
    print(jsonData.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        jsonData,
        false,
        response.statusCode,
        jsonData['message'],
      );
    } else if (response.statusCode == 500) {
      throw 'Something went wrong. Please retry later.';
    } else {
      return NetworkResponse(
        jsonData,
        true,
        response.statusCode,
        jsonData['message'],
      );
    }
  } catch (exception) {
    print('EXCEPTION:   ${exception.toString()}');
    throw exception.toString();
  }
}

class NetworkResponse {
  final dynamic data;
  final dynamic message;
  final bool isError;
  final int statusCode;

  NetworkResponse(this.data, this.isError, this.statusCode, this.message);
}
