class ApiResponse {

  String body;

  Map<String, String> headers;

  bool isSuccess;

  String message;

  ApiResponse.success(this.body, this.headers, this.isSuccess);

  ApiResponse.fail(this.isSuccess, this.message);
}