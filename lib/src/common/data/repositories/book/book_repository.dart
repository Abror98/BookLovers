import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:openlib/src/common/common.dart';
import 'package:xml2json/xml2json.dart';

typedef BookRepositoryData = ({CategoryFeed? feed, HttpFailure? failure});

abstract class BookRepository {
  final Dio httpClient;

  const BookRepository(this.httpClient);

  Future<BookRepositoryData> getCategory(String url) async {
    try {
      final res = await httpClient.get(url);
      CategoryFeed category;
      final Xml2Json xml2json = Xml2Json();
      xml2json.parse(res.data.toString());
      final json = jsonDecode(xml2json.toGData());
      category = CategoryFeed.fromJson(json as Map<String, dynamic>);
      return (feed: category, failure: null);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode ?? 500;
      if (statusCode == 404) {
        return (feed: null, failure: HttpFailure.notFound);
      }
      return (feed: null, failure: HttpFailure.unknown);
    }
  }
}
