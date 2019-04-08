import 'package:flutter_muyi/data/api/api_options.dart';
import 'package:flutter_muyi/data/api/api_response.dart';
import 'package:flutter_muyi/log/mlog.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class Api{

  ApiOptions apiOptions;

  Api(this.apiOptions);

  Future<ApiResponse> get(String url,
      {Map<String, String> params, Map<String, String> headers}) async {
    if(_isMockApi(url)){
      return _mock(url, params: params, headers: headers);
    }else{
      return _get(url, params: params, headers: headers);
    }
  }

  Future<ApiResponse> _get(String url,
      {Map<String, String> params, Map<String, String> headers}) async {
    ApiResponse apiResponse;
    try{
      params = _getParams(params);
      headers = _getHeaders(headers);
      url = _getUrl(url, params: params);
      MLog.d("request get url : $url");
      final response = await http.get(url, headers: headers);
      MLog.d("response get url : $url \n response : \n ${response.body}");
      apiResponse = ApiResponse.success(response.body, response.headers, _isScuessful(response));
    }catch(e){
      apiResponse = ApiResponse.fail(false, e.toString());
    }
    return apiResponse;
  }

  Future<ApiResponse> post(String url, {Map<String, String> headers, body}) async {
    if(_isMockApi(url)){
      return _mock(url, params: body, headers: headers);
    }else{
      return _post(url, body: body, headers: headers);
    }
  }

  Future<ApiResponse> _post(String url, {Map<String, String> headers, body}) async {
    ApiResponse apiResponse;
    try{
      headers = _getHeaders(headers);
      url = _getUrl(url);
      MLog.d("request post url : ${url.toString()}");
      final response = await http.post(url, headers: headers, body: body);
      MLog.d(
          "request post url : ${url.toString()} \n response : \n ${response.body}");
      apiResponse = ApiResponse.success(response.body, response.headers, _isScuessful(response));
    }catch(e){
      apiResponse = ApiResponse.fail(false, e.toString());
    }
    return apiResponse;
  }


  String _getUrl(String url, {Map<String, String> params}){
    var result = new StringBuffer();
    if(apiOptions.baseUrl != null){
      result = new StringBuffer(apiOptions.baseUrl);
    }
    result.write(url);

    if(params == null || params.isEmpty){
      return result.toString();
    }
    var separator = "";
    if(!result.toString().endsWith("?")){
      separator = "?";
    }
    params.forEach((key, value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      if (value != null && value.isNotEmpty) {
        result.write("=");
        result.write(Uri.encodeQueryComponent(value));
      }
    });
    return result.toString();
  }

  Map<String, String> _getHeaders(Map<String, String> headers){
    Map<String, String> result = {};
    if(headers != null && headers.isNotEmpty){
      result.addAll(headers);
    }
    if(apiOptions.commonHeader != null && apiOptions.commonHeader.isNotEmpty){
      result.addAll(apiOptions.commonHeader);
    }
    return result;
  }

  Map<String, String> _getParams(Map<String, String> params){
    Map<String, String> result = {};
    if(params != null && params.isNotEmpty){
      result.addAll(params);
    }
    if(apiOptions.commonParams != null && apiOptions.commonParams.isNotEmpty){
      result.addAll(apiOptions.commonParams);
    }
    return result;
  }

  bool _isScuessful(http.Response response){
    bool result = false;
    if(response.statusCode >= 200 && response.statusCode <300){
      result = true;
    }
    return result;
  }

  bool _isMockApi(String url){
    return apiOptions.mock != null && apiOptions.mock.containsKey(url);
  }

  Future<ApiResponse> _mock(String url,
      {Map<String, String> params, Map<String, String> headers}) async{
    await Future.delayed(Duration(seconds: 3));
    return ApiResponse.success(apiOptions.mock[url], headers, true);
  }
}


