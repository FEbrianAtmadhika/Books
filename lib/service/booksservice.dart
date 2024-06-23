import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:books/models/booksmodel.dart';
import 'package:books/service/authservice.dart';
import 'package:books/shared/baseapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http_parser/http_parser.dart';

class BooksService extends ChangeNotifier {
  String baseUrl = BaseApi().url;
  Future<List<BookModel>> getAllBook() async {
    try {
      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse('$baseUrl/books'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      Map<dynamic, dynamic> rawdata = jsonDecode(res.body);
      print(rawdata);
      if (res.statusCode != 200) {
        return throw res.statusCode;
      }
      if (rawdata['code'] != 200 || rawdata['message'] != 'success') {
        return throw rawdata['message'];
      }

      List<dynamic> bookdata = rawdata['data'];
      List<BookModel> books = [];
      for (var element in bookdata) {
        books.add(BookModel.fromjson(element));
      }
      return books;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookModel>> deleteBook(List<BookModel> book, int id) async {
    try {
      final token = await AuthService().getToken();

      final res = await http.delete(
        Uri.parse('$baseUrl/books/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      Map<dynamic, dynamic> rawdata = jsonDecode(res.body);
      print(rawdata);
      if (res.statusCode != 200) {
        return throw res.statusCode;
      }
      if (rawdata['message'] != 'Book deleted successfully.') {
        return throw rawdata['message'];
      }

      book.removeAt(book.indexWhere((element) => element.id == id));

      return book;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookModel>> addBooks(
      List<BookModel> book, BookModel data, File pdf, File image) async {
    try {
      final token = await AuthService().getToken();

      final streamImage = http.ByteStream(image.openRead());
      final streamPdf = http.ByteStream(pdf.openRead());
      final lengthImage = image.lengthSync();
      final lengthPdf = pdf.lengthSync();
      String mimeType = getMimeType(image.path);
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/books'))
        ..fields['title'] = data.judul!
        ..fields['author'] = data.author!
        ..fields['isbn'] = data.isbn!
        ..fields['page'] = data.judul!
        ..files.add(http.MultipartFile(
          'pdf',
          streamPdf,
          lengthPdf,
          filename: pdf.path.split('/').last,
          contentType: MediaType('application', 'pdf'),
        ))
        ..files.add(http.MultipartFile(
          'cover_image',
          streamImage,
          lengthImage,
          filename: image.path.split('/').last,
          contentType: MediaType.parse(mimeType),
        ));
      request.headers['Authorization'] = 'Bearer $token';
      final res = await request.send();
      final resbody = await http.Response.fromStream(res);
      Map<dynamic, dynamic> rawdata = jsonDecode(resbody.body);
      if (res.statusCode != 200) {
        return throw res.statusCode;
      }
      if (rawdata['code'] != 200 ||
          rawdata['message'] != 'Book created successfully.') {
        return throw rawdata['message'];
      }
      Map<String, dynamic> bookdata = rawdata['data'];
      data = BookModel.fromjson(bookdata);
      book.add(data);
      return book;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookModel>> UpdateBooks(
      List<BookModel> book, BookModel data, File pdf, File image) async {
    try {
      final token = await AuthService().getToken();

      final streamImage = http.ByteStream(image.openRead());
      final streamPdf = http.ByteStream(pdf.openRead());
      final lengthImage = image.lengthSync();
      final lengthPdf = pdf.lengthSync();
      String mimeType = getMimeType(image.path);
      final request =
          http.MultipartRequest('PATCH', Uri.parse('$baseUrl/books/${data.id}'))
            ..fields['title'] = data.judul!
            ..fields['author'] = data.author!
            ..fields['isbn'] = data.isbn!
            ..fields['page'] = data.judul!
            ..files.add(http.MultipartFile(
              'pdf',
              streamPdf,
              lengthPdf,
              filename: pdf.path.split('/').last,
              contentType: MediaType('application', 'pdf'),
            ))
            ..files.add(http.MultipartFile(
              'cover_image',
              streamImage,
              lengthImage,
              filename: image.path.split('/').last,
              contentType: MediaType.parse(mimeType),
            ));
      request.headers['Authorization'] = 'Bearer $token';
      final res = await request.send();
      final resbody = await http.Response.fromStream(res);
      Map<dynamic, dynamic> rawdata = jsonDecode(resbody.body);
      if (res.statusCode != 200) {
        return throw res.statusCode;
      }
      if (rawdata['code'] != 200 ||
          rawdata['message'] != 'Book updated successfully.') {
        return throw rawdata['message'];
      }
      Map<String, dynamic> bookdata = rawdata['data'];
      data = BookModel.fromjson(bookdata);
      int index = book.indexWhere((element) => element.id == data.id);
      book[index] = data;
      return book;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downlaod(String url, String name) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw 'Storage permission not granted';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final downloadsDir = Directory('${directory!.path}/Download');

        if (!downloadsDir.existsSync()) {
          downloadsDir.createSync(recursive: true);
        }

        final filePath = '${downloadsDir.path}/$name.pdf';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } else {
        throw 'Failed to download PDF';
      }
    } catch (e) {
      throw 'Error downloading PDF: $e';
    }
  }

  String getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.svg':
        return 'image/svg+xml';
      default:
        return 'application/octet-stream'; // Default binary type if unknown
    }
  }
}
