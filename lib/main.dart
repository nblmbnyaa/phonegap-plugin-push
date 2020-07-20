import 'package:flutter/material.dart';
import 'package:prosis_mobile/Sayfalar/Crm/baskasindaBekleyenler.dart';
import 'package:prosis_mobile/Sayfalar/Crm/bendeBekleyenler.dart';
import 'package:prosis_mobile/Sayfalar/Crm/musterikarti.dart';
import 'package:prosis_mobile/Sayfalar/Crm/planlama.dart';
import 'package:prosis_mobile/Sayfalar/Crm/talepkarti.dart';
import 'package:prosis_mobile/Sayfalar/Crm/ziyaretPlanlarim.dart';
import 'package:prosis_mobile/Sayfalar/Evraklar/pagealinansiparis.dart';
import 'package:prosis_mobile/Sayfalar/Evraklar/pagecikisirsaliyesi.dart';
import 'package:prosis_mobile/Sayfalar/Evraklar/pagegirisirsaliyesi.dart';
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
      "/132001": (context) => PageCrmMusteriKarti(),
      "/132002": (context) => PageTalepKarti(
            talepNo: 0,
          ),
      "/132006": (context) => PageCrmBaskasindaBekleyenler(),
      "/132007": (context) => PageCrmBendeBekleyenler(),
      "/132010": (context) => PageCrmZiyaretPlanlarim(),
      "/132011": (context) => PageCrmPlanlama(),
      "/201003": (context) => PageAlinanSiparis(),
      "/201005": (context) => PageCariHesapEkstresi(),
      "/201006": (context) => PageSayim(),
      "/201009": (context) => PageCikisIrsaliyesi(),
      "/201011": (context) => PageGirisIrsaliyesi(),
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
