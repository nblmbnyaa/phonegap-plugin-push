import 'package:flutter/material.dart';
import 'package:prosis_mobile/Sayfalar/Crm/talepkarti.dart';
import 'package:prosis_mobile/Sayfalar/Evraklar/pagealinansiparis.dart';
import 'package:prosis_mobile/Sayfalar/Raporlar/pageCariHesapEkstresi.dart';
import 'package:prosis_mobile/Sayfalar/Sistem/pagealtmenu.dart';
import 'package:prosis_mobile/Sayfalar/Sistem/pageanamenu.dart';
import 'package:prosis_mobile/Sayfalar/Sistem/pagegiris.dart';
import 'package:prosis_mobile/Sayfalar/Sistem/pagegirisayarlari.dart';
import 'package:prosis_mobile/Sayfalar/Evraklar/pagesayim.dart';

import 'Genel/Oturum.dart';

void main() {
  // runApp(LoadingProvider(
  //     themeData: LoadingThemeData(
  //         // tapDismiss: false,
  //         ),
  //     child: MaterialApp(
  //           initialRoute: '/',
  //           routes: {
  //             "/": (context) => PageGiris(),
  //             "/girisayarlari": (context) => PageGirisAyarlari(),
  //             "/anamenu": (context) => PageAnaMenu(),
  //             "/altmenu": (context) => PageAltMenu(
  //                   ustmenu: "",
  //                 ),
  //             "/201003": (context) => PageAlinanSiparis(),
  //           },
  //         )));

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      "/": (context) => PageGiris(),
      "/girisayarlari": (context) => PageGirisAyarlari(),
      "/anamenu": (context) => PageAnaMenu(),
      "/altmenu": (context) => PageAltMenu(
            ustmenu: "",
          ),
      "/201003": (context) => PageAlinanSiparis(),
      "/201006": (context) => PageSayim(),
      "/201005": (context) => PageCariHesapEkstresi(),
      "/132002": (context) => TalepKarti(
            talepNo: 0,
          ),
    },
    //           locale: const Locale('de'), // change to locale you want. not all locales are supported
    // localizationsDelegates: [

    //   GlobalMaterialLocalizations.delegate,
    //   GlobalWidgetsLocalizations.delegate,
    // ],
  ));
}

class MyApp {
  static String apiUrl = "";
  static String apiSifre = "";
  static OturumBilgileri oturum = OturumBilgileri();
}
