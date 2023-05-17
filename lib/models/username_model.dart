import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class Username {
  String fname;
  String lname;

  Username({
    required this.fname,
    required this.lname,
  });

  // Factory constructor to instantiate object from json format
  factory Username.fromJson(Map<String, dynamic> json) {
    return Username(
      fname: json['fname'],
      lname: json['lname'],
    );
  }
  static List<Username> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Username>((dynamic d) => Username.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Username user) {
    return {
      'fname': user.fname,
      'lname': user.lname,
    };
  }
}
