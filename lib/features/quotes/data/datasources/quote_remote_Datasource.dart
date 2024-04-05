import 'dart:convert';
import 'dart:math';
import 'package:assignmenttask/core/error/exceptions.dart';
import 'package:assignmenttask/features/quotes/data/models/quotes_model.dart';
import 'package:dio/dio.dart';

abstract class QuoteRemoteDataSource {
  Future<QuotesModel> getQuotes();
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final Dio dio;

  QuoteRemoteDataSourceImpl({required this.dio});

  @override
  Future<QuotesModel> getQuotes() async {
  final response = await dio.get('https://type.fit/api/quotes');

  Random random = Random();

  // Assuming response.data is already in JSON format, you don't need to decode it
  List<dynamic> quotesList = jsonDecode(response.data);

  return (response.statusCode == 200)
      ? QuotesModel.fromJson(
          quotesList[random.nextInt(quotesList.length)])
      : throw ServerException();
}
}
