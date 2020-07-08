import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formTekButton.dart';
import 'package:prosis_mobile/Genel/formtarih.dart';
import 'package:prosis_mobile/Genel/formtextaramali.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:intl/intl.dart' as intl;
import '../../main.dart';

class PageCariHesapEkstresi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageCariHesapEkstresiState();
  }
}

class PageCariHesapEkstresiState extends State<PageCariHesapEkstresi> {
  bool ustPanelVisibility = true;
  TextEditingController txtCariKod = TextEditingController();
  TextEditingController txtCariUnvan = TextEditingController();
  TextEditingController dtIlkTarih = TextEditingController();
  DateTime ilkTarih = DateTime(DateTime.now().year, DateTime.now().month, 1);
  TextEditingController dtSonTarih = TextEditingController();
  DateTime sonTarih =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool raporVisibility = false;
  List<dynamic> dataList = [];

  void cariKodAra() {
    cariAra(true);
  }

  void cariUnvanAra() {
    cariAra(false);
  }

  void cariAra(bool kod) async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    String url = "";
    if (kod) {
      url = MyApp.apiUrl + "apicarihesapekstresi/CariKodAra";
      parametreler.add(txtCariKod.text);
    } else {
      url = MyApp.apiUrl + "apicarihesapekstresi/CariUnvanAra";
      parametreler.add(txtCariUnvan.text);
    }

    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler, url);
    if (!sn.basarili) {
      Mesajlar().tamam(
          context,
          Text(
            sn.sonuc,
            style: TextStyle(color: Colors.red),
          ),
          Text("Hata"));
      return;
    }

    List cariler = json.decode(sn.sonuc);

    BasariUtilities().f10(
        context,
        "Cari Listesi",
        ListView.builder(
            itemCount: cariler.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return GestureDetector(
                child: Container(
                    color: index % 2 == 0 ? Colors.blue[100] : Colors.blue[200],
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(cariler[index]["carikod"]),
                            flex: 1,
                          ),
                          Expanded(
                            child: Text(cariler[index]["cariunvan"]),
                            flex: 2,
                          )
                        ],
                      ),
                    )),
                onTap: () {
                  txtCariKod.text = cariler[index]["carikod"];
                  setState(() {});
                  Navigator.of(context).pop();
                  cariGetir();
                },
              );
            }));
  }

  void cariGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtCariKod.text);
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicarihesapekstresi/CariBilgileri");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtCariUnvan.text = gelen["cari_unvan1"];
    }
    setState(() {});
  }

  void raporAl() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> raporparams = {
      'carikod': txtCariKod.text,
      'ilktarih': ilkTarih.toIso8601String(),
      'sontarih': sonTarih.toIso8601String(),
    };
    parametreler.add(jsonEncode(raporparams));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicarihesapekstresi/RaporAl");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      //List<dynamic> gelen2 = gelen[0];

      dataList = json.decode(gelen[0]);
      raporVisibility = true;
      ustPanelVisibility = false;
    }
    setState(() {});
  }

  void parametreleriAc() {
    ustPanelVisibility = true;
    raporVisibility = false;
    setState(() {});
  }

  Future<bool> backPressed() {
    return Mesajlar().yesno(context, Text("Çıkmak istediğinizden emin misiniz"),
            Text("Uyarı"), "Çık", "Vazgeç") ??
        false;
  }

  void onLoad() async {
    dtIlkTarih.text = intl.DateFormat("dd.MM.yyyy").format(ilkTarih);
    dtSonTarih.text = intl.DateFormat("dd.MM.yyyy").format(sonTarih);
  }

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Cari Hesap Ekstresi"),
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              Visibility(
                  visible: ustPanelVisibility,
                  child: Column(
                    children: <Widget>[
                      FormTextAramali(
                        buttonVisible: true,
                        labelicerik: "Cari Kod",
                        onKeyDown: cariGetir,
                        onPressedAra: cariKodAra,
                        readOnly: false,
                        txtkod: txtCariKod,
                      ),
                      FormTextAramali(
                        buttonVisible: true,
                        labelicerik: "Cari Unvan",
                        onKeyDown: cariGetir,
                        onPressedAra: cariUnvanAra,
                        readOnly: false,
                        txtkod: txtCariUnvan,
                      ),
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
                        icerik: "Ekstre Getir",
                        islem: raporAl,
                        renk: Colors.green[600],
                      )
                    ],
                  )),
              Visibility(
                  visible: raporVisibility,
                  child: Column(
                    children: <Widget>[
                      FormTekButton(
                        icerik: "Parametreler",
                        islem: parametreleriAc,
                        renk: Colors.yellow[300],
                      ),
                      SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                showCheckboxColumn: true,
                                columnSpacing: 10,
                                columns: [
                                  DataColumn(label: Text("Tarih")),
                                  DataColumn(label: Text("Evrak Tipi")),
                                  DataColumn(label: Text("Evrak No")),
                                  DataColumn(label: Text("Belge No")),
                                  DataColumn(label: Text("Belge Tarihi")),
                                  DataColumn(label: Text("Evrak Cinsi")),
                                  DataColumn(label: Text("Hareket Cinsi")),
                                  DataColumn(label: Text("Vade")),
                                  DataColumn(
                                      label: Text("Borç"), numeric: true),
                                  DataColumn(
                                      label: Text("Alacak"), numeric: true),
                                  DataColumn(
                                      label: Text("Bakiye"), numeric: true),
                                ],
                                rows: dataList
                                    .map((e) => DataRow(
                                      onSelectChanged: (b){

                                      },
                                      cells: [
                                          DataCell(
                                            GestureDetector(
                                              child: Text(intl.DateFormat(
                                                  "dd.MM.yyyy")
                                              .format(
                                                  DateTime.parse(e["Tarih"])))
                                                  ,onLongPress: ()
                                                  {
                                                    Mesajlar().tamam(context, Text(e["EvrakNo"].toString()), Text("baslik"));
                                                  },
                                                  ),
                                                  
                                            )
                                            ,
                                          DataCell(
                                              Text(e["EvrakTipi"].toString())),
                                          DataCell(
                                              Text(e["EvrakNo"].toString())),
                                          DataCell(
                                              Text(e["BelgeNo"].toString())),
                                          DataCell(Text(
                                              intl.DateFormat("dd.MM.yyyy")
                                                  .format(DateTime.parse(
                                                      e["BelgeTarihi"])))),
                                          DataCell(
                                              Text(e["EvrakCinsi"].toString())),
                                          DataCell(Text(
                                              e["HareketCinsi"].toString())),
                                          DataCell(Text(intl.DateFormat(
                                                  "dd.MM.yyyy")
                                              .format(
                                                  DateTime.parse(e["Vade"])))),
                                          DataCell(Text(
                                              intl.NumberFormat("#,##0.00")
                                                  .format(BasariUtilities()
                                                      .getdeci(e["Borç"].toString())))),
                                          DataCell(Text(
                                              intl.NumberFormat("#,##0.00")
                                                  .format(BasariUtilities()
                                                      .getdeci(e["Alacak"].toString())))),
                                                      DataCell(Text(
                                              intl.NumberFormat("#,##0.00")
                                                  .format(BasariUtilities()
                                                      .getdeci(e["Bakiye"].toString())))),

                                          //     intl.NumberFormat("#,##0.00").format(e["Borç"]))),
                                          // DataCell(Text(
                                          //     intl.NumberFormat("#,##0.00").format(e["Alacak"]))),
                                          // DataCell(Text(
                                          //     intl.NumberFormat("#,##0.00").format(e["Bakiye"]))),
                                        ]))
                                    .toList(),
                              )))
                    ],
                  ))
            ],
          )),
        ),
        onWillPop: backPressed);
  }
}
