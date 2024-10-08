enum HTTPReult {
  conflict,
  created,
  nofound,
  error,
  ok,
  forbidden,
  badrequire,
  Unauthorized
}

class config {
  static String apiUrl = "http://172.16.130.121:8080";
  static String ERROR_SERVER = 'Have error form server. Server don\'t run?';
}



