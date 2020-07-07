import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/Oturum.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formtextaramasiz.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:prosis_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PageGiris extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageGirisState();
  }
}

class PageGirisState extends State<PageGiris> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final txtSirket = TextEditingController();
  final txtKullanici = TextEditingController();
  final txtSifre = TextEditingController();
  bool beniHarla = false;
  String _homeScreenText = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  giris() async {
    //api url ve api ve şifre varsa giriş yap.
    //yoksa hata ver
    //oturum bilgilerini al
    //benihatirla işaretliyse kaydet

    if (MyApp.apiUrl == "" || MyApp.apiSifre == "") {
      Mesajlar().tamam(
          context, Text("Api Url ve Api Şifre girilmelidir"), Text("Uyarı"));
      return;
    }

    LoginParams lg = new LoginParams();
    lg.anasifre = MyApp.apiSifre;
    lg.sirket = txtSirket.text;
    lg.kullaniciadi = txtKullanici.text;
    lg.sifre = txtSifre.text;
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(lg));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisistem/Giris");
    if (sn.basarili) {
      MyApp.oturum = OturumBilgileri.fromJson(json.decode(sn.sonuc));

      if (beniHarla) {
        SharedPreferences prefs = await _prefs;
        prefs.setString("Sirket", txtSirket.text);
        prefs.setString("Kullanici", txtKullanici.text);
        prefs.setString("Sifre", txtSifre.text);
      }
    } else {
      Mesajlar().tamam(
          context,
          Text(
            sn.sonuc,
            style: TextStyle(color: Colors.red),
          ),
          Text("Hata"));
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/anamenu', (_) => false);
  }

  baglantiAyarlari() {
    Navigator.pushNamed(context, '/girisayarlari');
  }

  onload() {
    Future<String> apiUrl = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('ApiUrl') ?? "");
    });
    Future<String> apiSifre = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('ApiSifre') ?? "");
    });
    Future<String> sirket = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('Sirket') ?? "");
    });
    Future<String> kullanici = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('Kullanici') ?? "");
    });
    Future<String> sifre = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('Sifre') ?? "");
    });

    apiUrl.then((value) => (MyApp.apiUrl = value));
    apiSifre.then((value) => (MyApp.apiSifre = value));
    sirket.then((value) => (txtSirket.text = value));
    kullanici.then((value) {
      txtKullanici.text = value;
      if (value.length > 0) {
        beniHarla = true;
        setState(() {});
      }
    });
    sifre.then((value) => (txtSifre.text = value));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

//messaging

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });

//endmessagin

    onload();
  }

  /////////////////////TASARIM///////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş"),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                FormTextAramasiz(
                  labelicerik: "Şirket",
                  txtkod: txtSirket,
                ),
                FormTextAramasiz(
                  labelicerik: "Kullanıcı",
                  txtkod: txtKullanici,
                ),
                FormTextAramasiz(
                  labelicerik: "Şifre",
                  txtkod: txtSifre,
                  isPassword: true,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: beniHarla,
                      onChanged: (value) {
                        setState(() {
                          beniHarla = value;
                        });
                      },
                    ),
                    Text("Beni Hatırla"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Visibility(
                      visible: false,
                      child: Text(_homeScreenText),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: RaisedButton(
                            child: Text("Giriş"),
                            onPressed: giris,
                            color: Colors.green[300],
                          ),
                        )),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: RaisedButton(
                            child: Text("Bağlantı Ayarları"),
                            onPressed: baglantiAyarlari,
                            color: Colors.orange[300],
                          ),
                        )),
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class LoginParams {
  String anasifre;
  String sirket;
  String kullaniciadi;
  String sifre;
  Map<String, dynamic> toJson() => {
        'anasifre': anasifre,
        'sirket': sirket,
        'kullaniciadi': kullaniciadi,
        'sifre': sifre,
      };
}
