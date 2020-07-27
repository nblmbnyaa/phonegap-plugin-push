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

class PageKasaStokDetayliRapor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageKasaStokDetayliRaporState();
  }
}

class PageKasaStokDetayliRaporState extends State<PageKasaStokDetayliRapor> {
  bool depoVisible = false;
  String depoGosterGizleText = "Depoları Göster";

  TextEditingController dtIlkTarih = TextEditingController();
  DateTime ilkTarih =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TextEditingController dtSonTarih = TextEditingController();
  DateTime sonTarih =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<dynamic> dataList = [];
  List<dynamic> dtDepolar = [];

  void raporAl() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    List<int> depolar = [];
    for (var i = 0; i < dtDepolar.length; i++) {
      if (dtDepolar[i]["sec"]) {
        depolar.add(dtDepolar[i]["dep_no"]);
      }
    }
    Map<String, dynamic> raporparams = {
      'ilktarih': ilkTarih.toIso8601String(),
      'sontarih': sonTarih.toIso8601String(),
      'Depolar': depolar,
    };
    parametreler.add(jsonEncode(raporparams));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apiKasaRaporlari/StokDetayliRapor", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      //List<dynamic> gelen2 = gelen[0];

      dataList = json.decode(gelen[0]);
    }
    setState(() {});
  }

  void depoGosterGizle() {
    setState(() {
      if (depoVisible) {
        depoVisible = false;
        depoGosterGizleText = "Depoları Göster";
      } else {
        depoVisible = true;
        depoGosterGizleText = "Depoları Gizle";
      }
    });
  }

  void onLoad() async {
    dtIlkTarih.text = BasariUtilities().getStringDate(ilkTarih);
    dtSonTarih.text = BasariUtilities().getStringDate(sonTarih);
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apiKasaRaporlari/Depolar", context);
    if (sn.basarili) {
      dtDepolar = json.decode(sn.sonuc);
    }
    setState(() {});
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
            title: Text("Stok Detaylı Rapor"),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              Visibility(
                  visible: true,
                  child: Column(
                    children: <Widget>[
                      FormTekButton(
                        icerik: depoGosterGizleText,
                        islem: depoGosterGizle,
                        renk: Colors.grey[200],
                      ),
                      Visibility(
                          visible: depoVisible,
                          child: ListView.builder(
                              itemCount: dtDepolar.length,
                              itemBuilder: (BuildContext ctx, int ind) {
                                return Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: dtDepolar[ind]["sec"],
                                        onChanged: (vl) {
                                          setState(() {
                                            dtDepolar[ind]["sec"] = vl;
                                          });
                                        }),
                                    Expanded(
                                        child: Text(
                                            "${dtDepolar[ind]["dep_no"]}-${dtDepolar[ind]["dep_adi"]}"))
                                  ],
                                );
                              })),
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
                                  DataColumn(label: Text("Ana Grup")),
                                  DataColumn(label: Text("Stok Kodu")),
                                  DataColumn(label: Text("Stok Adı")),
                                  DataColumn(label: Text("Miktar")),
                                  DataColumn(
                                      label: Text("Tutar"), numeric: true),
                                  DataColumn(
                                      label: Text("İskonto Tutarı"),
                                      numeric: true),
                                  DataColumn(
                                      label: Text("İskonto Oranı"),
                                      numeric: true),
                                  DataColumn(
                                      label: Text("Toplam"), numeric: true),
                                  DataColumn(
                                      label: Text("Vergi"), numeric: true),
                                  DataColumn(
                                      label: Text("Matrah"), numeric: true),
                                  DataColumn(
                                      label: Text("Birim Fiyat"), numeric: true),
                                ],
                                rows: dataList
                                    .map((e) => DataRow(
                                            onSelectChanged: (b) {},
                                            cells: [
                                              DataCell(Text(e["AnaGrup"])),
                                              DataCell(Column(
                                                children: <Widget>[
                                                  Text(e["StokKodu"]),
                                                  Text(e["StokAdi"])
                                                ],
                                              )),
                                              DataCell(Text(
                                                  "${e["Miktar"]} ${e["Birim"]}")),
                                              DataCell(
                                                  Text(e["Tutar"].toString())),
                                              DataCell(Text(e["IskontoTutari"]
                                                  .toString())),
                                              DataCell(Text(e["IskontoOrani"]
                                                  .toString())),
                                              DataCell(
                                                  Text(e["Toplam"].toString())),
                                              DataCell(
                                                  Text(e["Vergi"].toString())),
                                              DataCell(Text(e["VergiMatrahi"]
                                                  .toString())),
                                              DataCell(Text(
                                                  e["BirimFiyat"].toString())),
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
