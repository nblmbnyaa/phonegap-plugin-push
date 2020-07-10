import 'package:flutter/material.dart';

class Mesajlar {
  Future<bool> tamam(BuildContext context, Text mesaj, Text baslik) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: baslik,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  mesaj,
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  Future<bool> yesno(BuildContext context, Text mesaj, Text baslik,String truetext,String falsetext) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: baslik,
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  mesaj,
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(truetext),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text(falsetext),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  Future<bool> backPressed(BuildContext context) {
    return yesno(context, Text("Çıkmak istediğinizden emin misiniz"),
            Text("Uyarı"), "Çık", "Vazgeç") ??
        false;
  }

}
