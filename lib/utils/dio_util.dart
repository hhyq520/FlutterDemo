import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class DioUtil {
  static Dio _dio;
  static final DioUtil _singleton = DioUtil._init();
  Options _options = getDefOptions();

  /// 是否是debug模式.
  static bool _isDebug = false;

  /// BaseResp [String status]字段 key, 默认：status.
  String _stautsKey = "stauts";

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  String _msgKey = "msg";

  /// BaseResp [T data]字段 key, 默认：data.
  String _dataKey = "data";

  /// PEM证书内容.
  String _pem;

  /// PKCS12 证书路径.
  String _pKCSPath;

  /// PKCS12 证书密码.
  String _pKCSPwd;

  static DioUtil getInstance() {
    return _singleton;
  }

  factory DioUtil() {
    return _singleton;
  }

  DioUtil._init() {
    _dio = new Dio(_options);
  }

  /// 打开debug模式.
  static void openDebug() {
    _isDebug = true;
  }

  /// get dio.
  Dio getDio() {
    return _dio;
  }

  /// create new dio.
  static Dio createNewDio([Options options]) {
    options = options ?? getDefOptions();
    Dio dio = new Dio(options);
    return dio;
  }

  static Options getDefOptions() {
    Options options = new Options();
    options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    options.connectTimeout = 1000 * 10;
    options.receiveTimeout = 1000 * 20;
    return options;
  }

  void setConfig(HttpConfig config) {
    _stautsKey = config.stauts ?? _stautsKey;
    _msgKey = config.msg ?? _msgKey;
    _dataKey = config.data ?? _dataKey;
    _mergeOption(config.options);
    _pem = config.pem ?? _pem;
    if (_dio != null) {
      _dio.options = _options;
      if (_pem != null) {
        _dio.onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) {
            if (cert.pem == _pem) {
              // 证书一致，则放行
              return true;
            }
            return false;
          };
        };
      }
      if (_pKCSPath != null) {
        _dio.onHttpClientCreate = (HttpClient client) {
          SecurityContext sc = new SecurityContext();
          //file为证书路径
          sc.setTrustedCertificates(_pKCSPath, password: _pKCSPwd);
          HttpClient httpClient = new HttpClient(context: sc);
          return httpClient;
        };
      }
    }
  }

  /// check Options.
  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseResp<T> 返回 status code msg data .
  Future<BaseResp<T>> request<T>(String method, String path,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.request(path,
        data: data,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    _printHttpLog(response);
    int _status;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _status = (response.data[_stautsKey] is String)
              ? int.tryParse(response.data[_stautsKey])
              : response.data[_stautsKey];
          _msg = response.data[_msgKey];
          _data = response.data[_dataKey];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _status = (_dataMap[_stautsKey] is String)
              ? int.tryParse(_dataMap[_stautsKey])
              : _dataMap[_stautsKey];
          _msg = _dataMap[_msgKey];
          _data = _dataMap[_dataKey];
        }
        return new BaseResp(_status, _msg, _data);
      } catch (e) {
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
  }

  /// decode response data.
  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return new Map();
    }
    return json.decode(response.data.toString());
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// <BaseRespR<T> 返回 status code msg data  Response.
  Future<BaseRespR<T>> requestR<T>(String method, String path,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.request(path,
        data: data,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    _printHttpLog(response);
    int _status;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _status = (response.data[_stautsKey] is String)
              ? int.tryParse(response.data[_stautsKey])
              : response.data[_stautsKey];
          _msg = response.data[_msgKey];
          _data = response.data[_dataKey];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _status = (_dataMap[_stautsKey] is String)
              ? int.tryParse(_dataMap[_stautsKey])
              : _dataMap[_stautsKey];
          _msg = _dataMap[_msgKey];
          _data = _dataMap[_dataKey];
        }
        return new BaseRespR(_status, _msg, _data, response);
      } catch (e) {
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }



    /// Download the file and save it in local. The default http method is "GET",you can custom it by [Options.method].
    /// [urlPath]: The file url.
    /// [savePath]: The path to save the downloading file later.
    /// [onProgress]: The callback to listen downloading progress.please refer to [OnDownloadProgress].
    Future<Response> download(
        String urlPath,
        savePath, {
          OnDownloadProgress onProgress,
          CancelToken cancelToken,
          data,
          Options options,
        }) {
      return _dio.download(urlPath, savePath,
          onProgress: onProgress,
          cancelToken: cancelToken,
          data: data,
          options: options);
    }
  }


  Future<BaseResp<T>> upload<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.post(path,
        data: data,
        options: _checkOptions(Method.post, options),
        cancelToken: cancelToken);
    _printHttpLog(response);
    int _status;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _status = (response.data[_stautsKey] is String)
              ? int.tryParse(response.data[_stautsKey])
              : response.data[_stautsKey];
          _msg = response.data[_msgKey];
          _data = response.data[_dataKey];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _status = (_dataMap[_stautsKey] is String)
              ? int.tryParse(_dataMap[_stautsKey])
              : _dataMap[_stautsKey];
          _msg = _dataMap[_msgKey];
          _data = _dataMap[_dataKey];
        }
        return new BaseResp(_status, _msg, _data);
      } catch (e) {
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
  }


  /// merge Option.
  void _mergeOption(Options opt) {
    _options.method = opt.method ?? _options.method;
    _options.headers = (new Map.from(_options.headers))
      ..addAll(opt.headers);
    _options.baseUrl = opt.baseUrl ?? _options.baseUrl;
    _options.connectTimeout = opt.connectTimeout ?? _options.connectTimeout;
    _options.receiveTimeout = opt.receiveTimeout ?? _options.receiveTimeout;
    _options.responseType = opt.responseType ?? _options.responseType;
    _options.data = opt.data ?? _options.data;
    _options.extra = (new Map.from(_options.extra))
      ..addAll(opt.extra);
    _options.contentType = opt.contentType ?? _options.contentType;
    _options.validateStatus = opt.validateStatus ?? _options.validateStatus;
    _options.followRedirects =
        opt.followRedirects ?? _options.followRedirects;
  }

  /// print Http Log.
  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    try {
      print("----------------Http Log----------------" +
          "\n[statusCode]:   " +
          response.statusCode.toString() +
          "\n[request   ]:   " +
          _getOptionsStr(response.request));
      _printDataStr("reqdata ", response.request.data);
      _printDataStr("response", response.data);
    } catch (ex) {
      print("Http Log" + " error......");
    }
  }

  /// get Options Str.
  String _getOptionsStr(Options request) {
    return "method: " +
        request.method +
        "  baseUrl: " +
        request.baseUrl +
        "  path: " +
        request.path;
  }

  /// print Data Str.
  void _printDataStr(String tag, Object value) {
    String da = value.toString();
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("[$tag  ]:   " + da.substring(0, 512));
        da = da.substring(512, da.length);
      } else {
        print("[$tag  ]:   " + da);
        da = "";
      }
    }
  }
}


  /// <BaseResp<T> 返回 status code msg data.
  class BaseResp<T> {
  int stauts;
  String msg;
  T data;

  BaseResp(this.stauts, this.msg, this.data);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"stauts\":\"$stauts\"");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
  }

/// <BaseRespR<T> 返回 status code msg data Response.
class BaseRespR<T> {
  int stauts;
  String msg;
  T data;
  Response response;

  BaseRespR(this.stauts, this.msg, this.data, this.response);

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"stauts\":\"$stauts\"");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }
}

/// 请求方法.
class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

///Http配置.
class HttpConfig {
  /// constructor.
  HttpConfig({
    this.stauts,
    this.msg,
    this.data,
    this.options,
    this.pem,
    this.pKCSPath,
    this.pKCSPwd,
  });

  /// BaseResp [int status]字段 key, 默认：status.
  int stauts;

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  String msg;

  /// BaseResp [T data]字段 key, 默认：data.
  String data;

  /// Options.
  Options options;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PEM证书内容.
  String pem;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书路径.
  String pKCSPath;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书密码.
  String pKCSPwd;
}

