class Validators {
  static String phoneNumberValidator(String value) {
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }

  static String isStringHasMoreChars(String value) {
    if (value.length < 4) {
      return 'Name should be greater than 4 characters.';
    } else if (value.length > 4) {
      return 'Name can not be greater than 4 characters.';
    } else {
      return null;
    }
  }

  static String validatePassword(String value) {
    if (value.length < 4) {
      return 'Password should be greater than 4 characters.';
    } else if (value.length > 4) {
      return 'Password can not be greater than 4 characters.';
    } else {
      return null;
    }
  }

  static String isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return 'Enter Valid Email';
    else
      return null;
  }
}
