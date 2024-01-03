import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;

class BookData {
  final String title;
  final String? author;
  final String? thumbnail;
  final String link;
  final String md5;
  final String? publisher;
  final String? info;

  BookData(
      {required this.title,
        this.author,
        this.thumbnail,
        required this.link,
        required this.md5,
        this.publisher,
        this.info});
}

class BookInfoData extends BookData {
  final List<String>? mirrors;
  final String? description;
  final String? format;

  BookInfoData(
      {required String title,
        required String? author,
        required String? thumbnail,
        required String? publisher,
        required String? info,
        required String link,
        required String md5,
        required this.mirrors,
        required this.format,
        required this.description})
      : super(
      title: title,
      author: author,
      thumbnail: thumbnail,
      publisher: publisher,
      info: info,
      link: link,
      md5: md5);
}

class AnnasArchieve {
  String baseUrl = "https://annas-archive.org";

  final Dio dio = Dio();

  Map<String, dynamic> defaultDioHeaders = {
    "user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"
  };

  String getMd5(String url) {
    String md5 = url.toString().split('/').last;
    return md5;
  }

  List<BookData> _parser(resData, String fileType) {
    var document =
    parse(resData.toString().replaceAll(RegExp(r"<!--|-->"), ''));
    var books = document.querySelectorAll(
        'a[class="js-vim-focus custom-a flex items-center relative left-[-10px] w-[calc(100%+20px)] px-[10px] outline-offset-[-2px] outline-2 rounded-[3px] hover:bg-black/6.7 focus:outline "]');

    List<BookData> bookList = [];

    for (var element in books) {
      var data = {
        'title': element.querySelector('h3')?.text,
        'thumbnail': element.querySelector('img')?.attributes['src'],
        'link': element.attributes['href'],
        'author': element
            .querySelector(
            'div[class="max-lg:line-clamp-[2] lg:truncate leading-[1.2] lg:leading-[1.35] max-lg:text-sm italic"]')
            ?.text ??
            'unknown',
        'publisher': element
            .querySelector(
            'div[class="truncate leading-[1.2] lg:leading-[1.35] max-lg:text-xs"]')
            ?.text ??
            "unknown",
        'info': element
            .querySelector(
            'div[class="line-clamp-[2] leading-[1.2] text-[10px] lg:text-xs text-gray-500"]')
            ?.text ??
            ''
      };

      if ((data['title'] != null && data['title'] != '') &&
          (data['link'] != null && data['link'] != '') &&
          (data['info'] != null &&
              ((fileType == "") &&
                  (data['info']!.contains('pdf') ||
                      data['info']!.contains('epub') ||
                      data['info']!.contains('cbr') ||
                      data['info']!.contains('cbz')) ||
                  ((fileType != "") && data['info']!.contains(fileType))))) {
        String link = baseUrl + data['link']!;
        String publisher = ((data['publisher']?.contains('0') == true &&
            data['publisher']!.length < 2) ||
            data['publisher'] == "") ==
            true
            ? "unknown"
            : data['publisher'].toString();

        BookData book = BookData(
          title: data['title'].toString(),
          author: data['author'],
          thumbnail: data['thumbnail'],
          link: link,
          md5: getMd5(data['link'].toString()),
          publisher: publisher,
          info: data['info'],
        );
        bookList.add(book);
      }
    }
    return bookList;
  }

  String getFormat(String info) {
    if (info.contains('pdf') == true) {
      return 'pdf';
    } else {
      if (info.contains('cbr')) return "cbr";
      if (info.contains('cbz')) return "cbz";
      return "epub";
    }
  }

  Future<String?> _getMirrorLink(
      String url, String userAgent, String cookie) async {
    try {
      final response = await dio.get(url,
          options: Options(extra: {
            'withCredentials': true
          }, headers: {
            "Host": "annas-archive.org",
            "Origin": "https://annas-archive.org",
            "Upgrade-Insecure-Requests": "1",
            "Sec-Fetch-Dest": "secure",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "same-site",
            "Cookie": cookie,
            "User-Agent": userAgent
          }));

      var document = parse(response.data.toString());

      var pTag = document.querySelectorAll('p[class="mb-4"]');
      String? link = pTag[1].querySelector('a')?.attributes['href'];
      return link;
    } catch (e) {
      // print('${url} ${e}');
      if (e.toString().contains("403")) {
        throw jsonEncode({"code": "403", "url": url});
      }
      return null;
    }
  }

  Future<BookInfoData?> _bookInfoParser(resData, url, userAgent, cookie) async {
    var document = parse(resData.toString());
    var main = document.querySelector('main[class="main"]');
    var ul = main?.querySelectorAll('ul[class="mb-4"]');

    List<String> mirrors = [];

    if (ul != null) {
      var anchorTags = [];
      if (ul.length == 2) {
        anchorTags = ul[1].querySelectorAll('a');
      } else {
        anchorTags = ul[0].querySelectorAll('a');
      }

      for (var element in anchorTags) {
        if (element.attributes['href']!.startsWith('https://')) {
          if (element.attributes['href'] != null &&
              element.attributes['href'].startsWith('https://1lib.sk') !=
                  true) {
            mirrors.add(element.attributes['href']!);
          }
        } else if (element.attributes['href'] != null &&
            element.attributes['href']!.startsWith('/slow_download')) {
          String? url = await _getMirrorLink(
              '$baseUrl${element.attributes['href']!}', userAgent, cookie);
          if (url != null && url.isNotEmpty) {
            mirrors.add(url);
          }
        }
      }
    }

    // print(mirrors);

    var data = {
      'title': main?.querySelector('div[class="text-3xl font-bold"]')?.text,
      'author': main?.querySelector('div[class="italic"]')?.text ?? "unknown",
      'thumbnail': main?.querySelector('img')?.attributes['src'],
      'link': url,
      'publisher':
      main?.querySelector('div[class="text-md"]')?.text ?? "unknown",
      'info':
      main?.querySelector('div[class="text-sm text-gray-500"]')?.text ?? '',
      'description': main
          ?.querySelector(
          'div[class="mt-4 line-clamp-[5] js-md5-top-box-description"]')
          ?.text ??
          " "
    };

    if ((data['title'] != null && data['title'] != '') &&
        (data['link'] != null && data['link'] != '')) {
      String title = data['title'].toString().characters.skipLast(1).toString();
      String author =
      data['author'].toString().characters.skipLast(1).toString();
      String publisher = ((data['publisher']?.contains('0') == true &&
          data['publisher']!.length < 2) ||
          data['publisher'] == "") ==
          true
          ? "unknown"
          : data['publisher'].toString();

      return BookInfoData(
        title: title,
        author: author,
        thumbnail: main?.querySelector('img')?.attributes['src'],
        publisher: publisher,
        info: data['info'],
        link: data['link'],
        md5: getMd5(data['link'].toString()),
        format: getFormat(data['info']),
        mirrors: mirrors,
        description: data['description'],
      );
    } else {
      return null;
    }
  }

  String urlEncoder(
      {required String searchQuery,
        required String content,
        required String sort,
        required String fileType,
        required bool enableFilters}) {
    searchQuery = searchQuery.replaceAll(" ", "+");
    if (enableFilters == false) return '$baseUrl/search?q=$searchQuery';
    if (content == "" && sort == "" && fileType == "") {
      return '$baseUrl/search?q=$searchQuery';
    }
    return '$baseUrl/search?index=&q=$searchQuery&content=$content&ext=$fileType&sort=$sort';
  }

  Future<List<BookData>> searchBooks(
      {required String searchQuery,
        String content = "",
        String sort = "",
        String fileType = "",
        bool enableFilters = true}) async {
    try {
      final String encodedURL = urlEncoder(
          searchQuery: searchQuery,
          content: content,
          sort: sort,
          fileType: fileType,
          enableFilters: enableFilters);

      final response = await dio.get(encodedURL,
          options: Options(headers: defaultDioHeaders));
      if (!enableFilters) {
        return _parser(response.data, "");
      }
      return _parser(response.data, fileType);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        throw "socketException";
      }
      rethrow;
    }
  }

  Future<BookInfoData> bookInfo(
      {required String url,
        required String userAgent,
        required String cookie}) async {
    try {
      final response =
      await dio.get(url, options: Options(headers: defaultDioHeaders));
      BookInfoData? data =
      await _bookInfoParser(response.data, url, userAgent, cookie);
      if (data != null) {
        return data;
      } else {
        throw 'unable to get data';
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown) {
        throw "socketException";
      }
      rethrow;
    }
  }
}