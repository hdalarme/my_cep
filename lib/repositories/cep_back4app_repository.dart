import 'package:dio/dio.dart';
import 'package:my_cep/model/myceps_model.dart';
//import 'package:my_cep/repositories/back4app_custon_dio.dart';

class CEPBack4AppRepository {
  //final _custonDio = Back4AppCustonDio();

  //CEPBack4AppRepository();

  Future<MyCEPsModel> obterCEPs() async {
    var dio = Dio();
    dio.options.headers["X-Parse-Application-Id"] =
        "3XbZhMJuufuoFteqaWsbMdUYMxETK1KDNCO8hQB7";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "b1Hqf1hc0Vg0r8HnEp0Sggvw8Qeppjs6WpvdjTY4";
    dio.options.headers["content-Type"] = "application/json";
    var result = await dio.get("https://parseapi.back4app.com/classes/cep");
    //var url = "/cep";
    //var result = await _custonDio.dio.get(url);
    return MyCEPsModel.fromJson(result.data);
  }


  Future<MyCEPsModel> consultarCEP(String cep) async {
    print("teste");
    var cepParaPesquisa = formatarCEP(cep);
    var dio = Dio();
    dio.options.headers["X-Parse-Application-Id"] =
        "3XbZhMJuufuoFteqaWsbMdUYMxETK1KDNCO8hQB7";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "b1Hqf1hc0Vg0r8HnEp0Sggvw8Qeppjs6WpvdjTY4";
    dio.options.headers["content-Type"] = "application/json";
    var url = "https://parseapi.back4app.com/classes/cep?where={\"cep\":\"$cepParaPesquisa\"}";
    print(url);
    var result = await dio.get(url);
    //var url = "/cep";
    //url = "$url?where={\"cep\":\"$cep\"}"; 
    //var result = await _custonDio.dio.get(url);
    return MyCEPsModel.fromJson(result.data);
  }

  Future<void> criar(MyCEPModel cep) async {
    var dio = Dio();
    dio.options.headers["X-Parse-Application-Id"] =
        "3XbZhMJuufuoFteqaWsbMdUYMxETK1KDNCO8hQB7";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "b1Hqf1hc0Vg0r8HnEp0Sggvw8Qeppjs6WpvdjTY4";
    dio.options.headers["content-Type"] = "application/json";
    var url = "https://parseapi.back4app.com/classes/cep";
    
    try {
      await dio.post(url, data: cep.toJsonEndpoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> remover(String objectId) async {
    var dio = Dio();
    dio.options.headers["X-Parse-Application-Id"] =
        "3XbZhMJuufuoFteqaWsbMdUYMxETK1KDNCO8hQB7";
    dio.options.headers["X-Parse-REST-API-Key"] =
        "b1Hqf1hc0Vg0r8HnEp0Sggvw8Qeppjs6WpvdjTY4";
    dio.options.headers["content-Type"] = "application/json";
    var url = "https://parseapi.back4app.com/classes/cep/$objectId";

    try {
      await dio.delete(url);
    } catch (e) {
      throw e;
    }
  }


String formatarCEP(String cep) {
  RegExp regex = RegExp(r'^(\d{5})(\d{3})$');
  if (regex.hasMatch(cep)) {
    return cep.replaceFirstMapped(regex, (match) => '${match[1]}-${match[2]}');
  } else {
    // Retornar o CEP original se não corresponder ao formato esperado
    return cep;
  }
}

}
