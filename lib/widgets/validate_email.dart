bool? validateEmail(String email) {
  String pattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(email)) {
    return false;
  }

  return true;
}


