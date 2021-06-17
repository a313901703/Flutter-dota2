import 'package:dio/dio.dart';

class DioUtil {
  Dio dio;

  static BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.23.8:8199/v1/",
      connectTimeout: 30000,
      receiveTimeout: 3000,
      headers: {
        'Accept': 'application/json, text/plain, */*',
        //'Authorization': '124',
        'Content-Type': 'application/json;charset=UTF-8'
      });

  DioUtil() {
    dio = Dio(options);
    this.addInterceptors();
  }

  addInterceptors() {
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // add token
      options.headers['Authorization'] = 123;
      return options; //continue
      // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
      // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
      //
      // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
      // 这样请求将被中止并触发异常，上层catchError会被调用。`
    }, onResponse: (Response response) {
      var data = response.data;
      //print(data["data"]);
      if (data['code'] == 0) {
        var _data = data["data"];
        return _data;
      } else {
        return dio.reject(data['message'] ?? "请求错误");
      }

      // print('response');
      // print(response);
      // 在返回响应数据之前做一些预处理
      //return response; // continue
    }, onError: (DioError e) async {
      print("request error");
      print(e);
      // 当请求失败时做一些预处理
      return e; //continue
    }));
  }

  get(String uri, [Map<String, dynamic> params]) async {
    Response response =
        await dio.get(uri, queryParameters: params == null ? {} : params);
    return response;
  }

  post(String uri, Map data) async {
    Response response = await dio.post('uri', data: data);
    return response;
  }
}
