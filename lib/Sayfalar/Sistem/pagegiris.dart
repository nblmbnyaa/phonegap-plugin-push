import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/Oturum.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formCiftButton.dart';
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

  //ProgressDialog pr;

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
    // pr.show();
    // pr.update(message: "Giriş yapılıyor");
    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisistem/Giris", context);
    if (sn.basarili) {
      MyApp.oturum = OturumBilgileri.fromJson(json.decode(sn.sonuc));

      if (beniHarla) {
        SharedPreferences prefs = await _prefs;
        prefs.setString("Sirket", txtSirket.text);
        prefs.setString("Kullanici", txtKullanici.text);
        prefs.setString("Sifre", txtSifre.text);
        //pr.hide();
      }
    } else {
      //pr.hide();
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
        Mesajlar().tamam(context, Text("$message"), Text("Bildirim mes"));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        Mesajlar().tamam(context, Text("$message"), Text("Bildirim lau"));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        Mesajlar().tamam(context, Text("$message"), Text("Bildirim res"));
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
    // pr = ProgressDialog(
    //   context,
    //   type: ProgressDialogType.Normal,
    //   textDirection: TextDirection.ltr,
    //   isDismissible: false,

    //  customBody: LinearProgressIndicator(
    //    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    //    backgroundColor: Colors.white,
    //  ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş"),
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/images/prosislogo.png"),
                            fit: BoxFit.cover),
                      ],
                    )),
                Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            FormCiftButton(
                              button1flex: 5,
                              button1icerik: "Giriş",
                              button1renk: Colors.green[300],
                              button1islem: giris,
                              button2flex: 3,
                              button2icerik: "Bağlantı Ayarları",
                              button2islem: baglantiAyarlari,
                              button2renk: Colors.orange[300],
                            ),
                          ],
                        )))
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
