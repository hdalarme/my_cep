import 'package:dio/dio.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_cep/repositories/back4app_dio_interceptor.dart';


class Back4AppCustonDio {
  final _dio = Dio();

  Dio get dio => _dio;

  Back4AppCustonDio() {
    _dio.options.headers["Content-Type"] = "application/json";
    //_dio.options.baseUrl = dotenv.get("BACK4APPBASEURL");
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
    _dio.interceptors.add(Back4AppDioInterceptor());
  }
}