import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;

part 'coffee_repository.freezed.dart';

/// A repository facilitating communication with the Coffee API.
///
class CoffeeRepository {
  /// Creates a [CoffeeRepository].
  ///
  CoffeeRepository() {
    _uri = Uri.parse('$_baseUrl$_randomEndpoint');
  }

  static const String _baseUrl = 'https://coffee.alexflipnote.dev';
  static const String _randomEndpoint = '/random.json';

  /// The [Uri] used to make requests to the Coffee API.
  ///
  late final Uri _uri;

  /// Attempts to fetch a random coffee image from the
  /// [https://coffee.alexflipnote.dev](https://coffee.alexflipnote.dev) API.
  ///
  /// The endpoint used is `/random.json`.
  ///
  /// Returns a [String] representing the URL of the image if successful,
  /// or a [CoffeeFailure] if unsuccessful.
  ///
  Future<Either<CoffeeFailure, String>> getRandomCoffeeImage() async {
    try {
      final response = await http.get(_uri);

      if (response.statusCode != 200) {
        return left(const CoffeeFailure.serverError());
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final imageUrl = data['file'] as String;

      if (imageUrl.isEmpty) {
        return left(const CoffeeFailure.unknownError());
      }

      return right(imageUrl);
    } on HttpException {
      // When the response is not a valid HTTP response,
      // a HttpException is thrown.
      return left(const CoffeeFailure.serverError());
    } on SocketException {
      return left(const CoffeeFailure.unknownError());
    }
  }
}

/// Class representing the possible failures that can occur
/// when interacting with the Coffee API.
///
@freezed
sealed class CoffeeFailure with _$CoffeeFailure {
  /// Creates a [CoffeeFailure].
  ///
  const CoffeeFailure._();

  /// A factory constructor that creates a [CoffeeFailure] that represents
  /// a server error. Such as the server returning a 500 status code.
  ///
  const factory CoffeeFailure.serverError() = _ServerError;

  /// A factory constructor that creates a [CoffeeFailure] that represents
  /// an unknown error. Such as the server returning an unexpected response.
  ///
  const factory CoffeeFailure.unknownError() = _UnknownError;
}
