import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formTekButton.dart';
import 'package:prosis_mobile/Genel/formtarih.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:intl/intl.dart' as intl;
import '../../main.dart';

class PageKasaOzetRapor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageKasaOzetRaporState();
  }
}

class PageKasaOzetRaporState extends State<PageKasaOzetRapor> {
  TextEditingController dtIlkTarih = TextEditingController();
  DateTime ilkTarih =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TextEditingController dtSonTarih = TextEditingController();
  DateTime sonTarih =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<dynamic> dataList = [];

  void raporAl() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> raporparams = {
      'ilktarih': ilkTarih.toIso8601String(),
      'sontarih': sonTarih.toIso8601String(),
    };
    parametreler.add(jsonEncode(raporparams));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apiKasaRaporlari/OzetRapor", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      //List<dynamic> gelen2 = gelen[0];

      dataList = json.decode(gelen[0]);
    }
    setState(() {});
  }

  Future<bool> backPressed() {
    return Mesajlar().yesno(context, Text("Çıkmak istediğinizden emin misiniz"),
            Text("Uyarı"), "Çık", "Vazgeç") ??
        false;
  }

  void onLoad() async {
    dtIlkTarih.text = BasariUtilities().getStringDate(ilkTarih);
    dtSonTarih.text = BasariUtilities().getStringDate(sonTarih);
  }

  @override
  void initState() {
    onLoad();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Özet Rapor"),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              Visibility(
                  visible: true,
                  child: Column(
                    children: <Widget>[
                      FormTarih(
                          dttarih: dtIlkTarih,
                          labelicerik: "İlk Tarih",
                          readonlytarih: false,
                          setTarih: (value) {
                            ilkTarih = value;
                          },
                          tarih: ilkTarih),
                      FormTarih(
                          dttarih: dtSonTarih,
                          labelicerik: "Son Tarih",
                          readonlytarih: false,
                          setTarih: (value) {
                            sonTarih = value;
                          },
                          tarih: sonTarih),
                      FormTekButton(
                        icerik: "Rapor Al",
                        islem: raporAl,
                        renk: Colors.green[600],
                      )
                    ],
                  )),
              Visibility(
                  visible: true,
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: true,
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(label: Text("Tarih")),
                                  DataColumn(label: Text("Mağaza")),
                                  DataColumn(label: Text("Toplam Nakit")),
                                  DataColumn(label: Text("Toplam Kredi Kartı")),
                                  DataColumn(label: Text("Toplam Açık Hesap")),
                                  DataColumn(label: Text("Toplam Satış")),
                                  DataColumn(label: Text("Toplam İskonto")),
                                  DataColumn(label: Text("Toplam İade Alınan")),
                                  DataColumn(label: Text("Net Satış")),
                                  DataColumn(
                                      label: Text("Net Satış Kdv Hariç")),
                                  DataColumn(label: Text("Sepet Sayısı")),
                                  DataColumn(
                                      label: Text("Ortalama Sepet Tutarı")),
                                ],
                                rows: dataList
                                    .map((e) => DataRow(
                                            onSelectChanged: (b) {},
                                            cells: [
                                              DataCell(
                                                GestureDetector(
                                                  child: Text(intl.DateFormat(
                                                          "dd.MM.yyyy")
                                                      .format(DateTime.parse(
                                                          e["Tarih"]))),
                                                ),
                                              ),
                                              DataCell(Text(
                                                  e["Mağaza No"].toString() +
                                                      " " +
                                                      e["Mağaza Adı"])),
                                              DataCell(Text(e["Toplam Nakit"]
                                                  .toString())),
                                              DataCell(Text(
                                                  e["Toplam Kredi Kartı"]
                                                      .toString())),
                                              DataCell(Text(
                                                  e["Toplam Açık Hesap"]
                                                      .toString())),
                                              DataCell(Text(e["Toplam Satış"]
                                                  .toString())),
                                              DataCell(Text(e["Toplam İskonto"]
                                                  .toString())),
                                              DataCell(Text(
                                                  e["Toplam İade Alınan"]
                                                      .toString())),
                                              DataCell(Text(
                                                  e["Net Satış"].toString())),
                                              DataCell(Text(
                                                  e["Net Satış Kdv Hariç"]
                                                      .toString())),
                                              DataCell(Text(e["Sepet Sayısı"]
                                                  .toString())),
                                              DataCell(Text(
                                                  e["Ortalama Sepet Tutarı"]
                                                      .toString())),
                                            ]))
                                    .toList(),
                              )))
                    ],
                  ))
            ],
          )),
        ),
        onWillPop: () => Mesajlar().backPressed(context));
  }
}
