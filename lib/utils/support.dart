import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicButton extends StatelessWidget {
  final String buttonText;
  final Function onPressedCallback;
  final Color backgroundColor;
  final Color textColor;

  const DynamicButton({
    Key? key,
    required this.buttonText,
    required this.onPressedCallback,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        onPressed: () {
          onPressedCallback();
        },
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> fetchImageAsBytes(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  } catch (e) {
    throw Exception('Error fetching image: $e');
  }
}

class Storage {
  static Future<String> leggi(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name) ?? "";
  }

  static Future<void> salva(String name, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, value);
  }

  static Future<void> rimuovi(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(name);
  }
}

class Verifica {
  static bool verificaIntero(String? valore) {
    return valore == null ? false : int.tryParse(valore) != null;
  }

  static bool verificaDouble(String? valore) {
    return valore == null ? false : double.tryParse(valore) != null;
  }

  static int castBooltoInt(bool value) {
    return value ? 1 : 0;
  }

  static String castDate(DateTime dt) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dt);
  }
}

class Log {
  static Future<void> error(String err) async {
    print(err);
  }
}

void alert(BuildContext context, String title, String message, AlertType type) {
  Alert(context: context, type: type, title: title, desc: message).show();
}
