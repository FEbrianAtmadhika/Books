import 'package:books/models/signinformmodel.dart';
import 'package:books/models/signupformmodel.dart';
import 'package:books/models/usermodel.dart';
import 'package:books/shared/baseapi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final String baseUrl = BaseApi().url;

  Future<UserModel> register(SignUpFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/register',
        ),
        body: {'name': data.name, 'email': data.email, 'password': data.email},
      );
      Map<String, dynamic> rawdata = jsonDecode(res.body);
      print(rawdata);
      if (rawdata['code'] == 200) {
        UserModel user = UserModel(
            id: rawdata['user']['id'],
            name: rawdata['user']['name'],
            email: rawdata['user']['email'],
            role: rawdata['user']['role_id'],
            createdAt: rawdata['user']['created_at'],
            updatedAt: rawdata['user']['update_at'],
            token: rawdata['access_token'],
            password: data.password,
            tokenType: rawdata['token_type']);
        await storeCredentialToLocal(user);
        return user;
      } else {
        throw rawdata['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(SignInFormModel data) async {
    try {
      print("${data.email}  ${data.password}");

      final res = await http.post(
        Uri.parse(
          '$baseUrl/login',
        ),
        body: {'email': data.email, 'password': data.password},
      );
      Map<String, dynamic> rawdata = jsonDecode(res.body);
      if (rawdata['code'] == 200 && rawdata['message'] == "Authenticated") {
        final user = UserModel.fromjson(rawdata);
        user.password = data.password;
        await storeCredentialToLocal(user);
        return user;
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      String? token = await getToken();
      final url = "$baseUrl/logout";
      final res = await http.post(
        Uri.parse(
          url,
        ),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      Map<dynamic, dynamic> rawdata = jsonDecode(res.body);
      if (rawdata['code'] == 200) {
        await clearLocalStorage();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: user.token);
      await storage.write(key: 'email', value: user.email);
      await storage.write(key: 'password', value: user.password);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getToken() async {
    String token = '';

    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'token');

    if (value != null) {
      token = value;
    }

    return token;
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();
      Map<String, String> values = await storage.readAll();

      if (values['token'] != null) {
        final SignInFormModel data = SignInFormModel(
          email: values['email'],
          password: values['password'],
        );

        return data;
      } else {
        throw 'unauthenticated';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearLocalStorage() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
    } catch (e) {
      rethrow;
    }
  }
}
