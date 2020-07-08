import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formtextaramasiz.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:prosis_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class PageGirisAyarlari extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageGirisAyarlariState();
  }
}

class PageGirisAyarlariState extends State<PageGirisAyarlari> {
  final txtApiUrl = TextEditingController();
  final txtApiSifre = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  baglantiTesti() async {
    final parametreler = List<String>();
    parametreler.add(txtApiSifre.text);

    if (!txtApiUrl.text.startsWith("http")) {
      txtApiUrl.text = "http://" + txtApiUrl.text;
      setState(() {});
    }
    if (!txtApiUrl.text.endsWith("/")) {
      txtApiUrl.text = txtApiUrl.text + "/";
      setState(() {});
    }

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, txtApiUrl.text + "apisistem/Test");
    if (sn.basarili) {
      Mesajlar().tamam(context, Text("Başarılı"), Text("Bağlantı Testi"));
    } else {
      Mesajlar().tamam(
          context,
          Text(
            sn.sonuc,
            style: TextStyle(color: Colors.red),
          ),
          Text("HATA"));
    }
  }

  kaydet() async {
    SharedPreferences prefs = await _prefs;
    prefs.setString("ApiUrl", txtApiUrl.text);
    prefs.setString("ApiSifre", txtApiSifre.text);

    MyApp.apiUrl = txtApiUrl.text;
    MyApp.apiSifre = txtApiSifre.text;

    Navigator.pop(context);
  }

  getir() async {
    Future<String> apiUrl = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('ApiUrl') ?? "");
    });
    Future<String> apiSifre = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('ApiSifre') ?? "");
    });
    apiUrl.then((value) => (txtApiUrl.text = value));
    apiSifre.then((value) => (txtApiSifre.text = value));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getir();
  }

////////////////////////////TASARIM////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Ayarları"),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            FormTextAramasiz(
              labelicerik: "Api Url",
              txtkod: txtApiUrl,
            ),
            FormTextAramasiz(
              labelicerik: "Api Şifresi",
              txtkod: txtApiSifre,
              isPassword: true,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: RaisedButton(
                          color: Colors.orange,
                          child: Text("Bağlantı Testi"),
                          onPressed: baglantiTesti,
                        ))),
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: RaisedButton(
                          color: Colors.lightBlue,
                          child: Text("Kaydet"),
                          onPressed: kaydet,
                        ))),
              ],
            ),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(style: TextStyle(color: Colors.black), children: [
                TextSpan(
                    text:
                        "Programımız API aracılığı ile çalışmaktadır.\nUygulamayı denemek için 'Bağlantı Bilgileri' ni boş bırakınız.\nAPI'nin sunucunuza yüklenmesi için "),
                LinkTextSpan(
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                    url: "tel:08502021422",
                    text: "0850 202 14 22"),
                TextSpan(
                    text:
                        " numaralı telefondan bizimle irtibata geçebilirsiniz."),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () => launcher.launch(url));
}
