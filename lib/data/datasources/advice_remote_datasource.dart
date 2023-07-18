import 'dart:convert';

import 'package:advicer_project/data/exceptions/exceptions.dart';
import 'package:advicer_project/data/models/advice_model.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'https://api.flutter-community.com/api/v1';

abstract class AdviceRemoteDatasource {
  /// Requests a random advice from the API
  /// Returns an [AdviceModel] if success
  /// Trows a server Exception
  Future<AdviceModel> getRandomAdviceFromApi();
}

class AdviceRemoteDatasourceImpl implements AdviceRemoteDatasource {
  final http.Client client;

  AdviceRemoteDatasourceImpl({required this.client});

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    final http.Response response = await client.get(
      Uri.parse('$_baseUrl/advice'),
      headers: {
        'content-type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      return throw ServerException();
    }

    final responseBody = json.decode(response.body);

    return AdviceModel.fromJson(responseBody);
  }
}
