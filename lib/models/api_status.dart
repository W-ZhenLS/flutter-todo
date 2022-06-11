class Success {
  String resBodyJSON;

  Success({required this.resBodyJSON}); 
}

class Failure {
  int code;
  Object errorResponse;

  Failure({required this.code, required this.errorResponse}); 
}