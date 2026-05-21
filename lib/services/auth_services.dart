import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  //---------------------------------------------------------
  // SIGNUP
  //---------------------------------------------------------

  static Future<String> signup({
    required String name,
    required String email,
    required String password,
  }) async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    //---------------------------------------------------------
    // GET OLD USERS
    //---------------------------------------------------------

    List<String> users =
        prefs.getStringList("users") ?? [];

    //---------------------------------------------------------
    // CHECK EXISTING EMAIL
    //---------------------------------------------------------

    for (String user in users) {

      Map<String, dynamic> decodedUser =
          jsonDecode(user);

      if (decodedUser["email"] == email) {

        return "User already exists";
      }
    }

    //---------------------------------------------------------
    // CREATE USER
    //---------------------------------------------------------

    Map<String, dynamic> newUser = {
      "name": name,
      "email": email,
      "password": password,
    };

    //---------------------------------------------------------
    // SAVE USER
    //---------------------------------------------------------

    users.add(jsonEncode(newUser));

    await prefs.setStringList(
      "users",
      users,
    );

    return "Signup Success";
  }

  //---------------------------------------------------------
  // LOGIN
  //---------------------------------------------------------

  static Future<String> login({
    required String email,
    required String password,
  }) async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    List<String> users =
        prefs.getStringList("users") ?? [];

    //---------------------------------------------------------
    // FIND USER
    //---------------------------------------------------------

    for (String user in users) {

      Map<String, dynamic> decodedUser =
          jsonDecode(user);

      if (decodedUser["email"] == email &&
          decodedUser["password"] ==
              password) {

        //---------------------------------------------------------
        // SAVE CURRENT SESSION
        //---------------------------------------------------------

        await prefs.setBool(
          "isLoggedIn",
          true,
        );

        await prefs.setString(
          "currentUserEmail",
          email,
        );

        await prefs.setString(
          "currentUserName",
          decodedUser["name"],
        );

        return "Login Success";
      }
    }

    return "Invalid Email or Password";
  }

  //---------------------------------------------------------
  // LOGOUT
  //---------------------------------------------------------

  static Future<void> logout() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      "isLoggedIn",
      false,
    );
  }

  //---------------------------------------------------------
  // GET USER NAME
  //---------------------------------------------------------

  static Future<String> getUserName() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
            "currentUserName") ??
        "";
  }

  //---------------------------------------------------------
  // GET CURRENT EMAIL
  //---------------------------------------------------------

  static Future<String> getCurrentEmail() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
            "currentUserEmail") ??
        "";
  }

  //---------------------------------------------------------
  // LOGIN CHECK
  //---------------------------------------------------------

  static Future<bool> isLoggedIn() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
            "isLoggedIn") ??
        false;
  }
}