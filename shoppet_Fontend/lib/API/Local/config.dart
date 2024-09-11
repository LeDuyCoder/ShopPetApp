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
  static String apiUrl = "http://192.168.1.8:8080";
  static String ERROR_SERVER = 'Have error form server. Server don\'t run?';
}
