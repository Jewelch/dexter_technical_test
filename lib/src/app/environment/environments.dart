// ignore_for_file: unused_element

enum Environment {
  mock(),
  dev(baseUrl: "https://adexter.health/api/"),
  preprod(baseUrl: "https://adexter.health/api/"),
  prod(baseUrl: "https://adexter.health/api/");

  final String baseUrl;
  final int connectTimeout;
  final int sendTimeout;
  final int receiveTimeout;

  const Environment({
    this.baseUrl = "",
    this.connectTimeout = 20000,
    this.sendTimeout = 30000,
    this.receiveTimeout = 25000,
  });
}
