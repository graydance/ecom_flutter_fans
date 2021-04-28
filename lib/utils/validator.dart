bool validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validatePassowrd(String email) {
  return email.length >= 8;
}

String matchStoreName(String host) {
  bool hasMatch = RegExp(r"^\w+[^\s]+(.store.olaak.com)$").hasMatch(host);
  if (hasMatch) {
    return host.split('.').first;
  }
  return null;
}
