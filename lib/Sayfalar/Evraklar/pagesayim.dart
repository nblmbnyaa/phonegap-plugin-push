import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formCiftButton.dart';
import 'package:prosis_mobile/Genel/formmiktarvebirim.dart';
import 'package:prosis_mobile/Genel/formtarih.dart';
import 'package:prosis_mobile/Genel/formtextaramali.dart';
import 'package:prosis_mobile/Genel/formtextaramaliciftbtn.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:intl/intl.dart' as intl;

import '../../main.dart';

class PageSayim extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageSayimState();
  }
}

class PageSayimState extends State<PageSayim> {
  int selectedTab = 0;
  TextEditingController txtDepo = TextEditingController();
  int depoNo = 0;
  bool readonlyDepo = false;
  DateTime sayimTarihi =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TextEditingController dtSayimTarihi = TextEditingController();
  bool readonlySayimTarihi = false;
  TextEditingController clcEvrakSira = TextEditingController();

  TextEditingController txtStokKodu = TextEditingController();
  FocusNode focusstokkodu = new FocusNode();
  TextEditingController txtStokAdi = TextEditingController();
  TextEditingController clcMiktar = TextEditingController();
  List<Birim> birimler = [];
  Birim selectedBirim;
  FocusNode focusmiktar = new FocusNode();
  List<EvrakSatir> dsevrak = new List<EvrakSatir>();

  void depoAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/DepoAra");
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

    List gelen = json.decode(sn.sonuc);

    BasariUtilities().f10(
        context,
        "Depo Listesi",
        DataTable(
            dataRowHeight: 35.0,
            columnSpacing: 10,
            showCheckboxColumn: false,
            columns: <DataColumn>[
              DataColumn(label: Text("No")),
              DataColumn(label: Text("Adı"))
            ],
            rows: gelen
                .map((e) => DataRow(
                        onSelectChanged: (b) {
                          if (b) {
                            txtDepo.text = e["dep_adi"];
                            depoNo = e["dep_no"];
                            setState(() {});
                            Navigator.of(context).pop();
                          }
                        },
                        cells: <DataCell>[
                          DataCell(Text(e["dep_no"].toString())),
                          DataCell(Text(e["dep_adi"])),
                        ]))
                .toList()));
  }

  void evrakAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> sbp = {
      "sayimtarihi": sayimTarihi.toIso8601String(),
      "depono": depoNo,
      "evrakno": BasariUtilities().tamsayi(clcEvrakSira.text),
    };
    parametreler.add(jsonEncode(sbp));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/EvrakAra");
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

    List f10data = json.decode(sn.sonuc);

    BasariUtilities().f10(
      context,
      "Evrak Listesi",
      DataTable(
          dataRowHeight: 35.0,
          columnSpacing: 10,
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Text("No")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        if (b) {
                          clcEvrakSira.text = e["evrakno"].toString();
                          evrakGetir();
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(e["evrakno"].toString())),
                      ]))
              .toList()),
    );
  }

  void evrakGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> sbp = {
      "sayimtarihi": sayimTarihi.toIso8601String(),
      "depono": depoNo,
      "evrakno": BasariUtilities().tamsayi(clcEvrakSira.text),
    };
    parametreler.add(jsonEncode(sbp));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/EvrakGetir");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      dsevrak = (gelen as List).map((e) => EvrakSatir.fromJson(e)).toList();
      stokTemizle();
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("HATA"));
    }
    setState(() {});
  }

  void stokKoduAra() {
    stokAra(true);
  }

  void stokAdiAra() {
    stokAra(false);
  }

  void stokAra(bool kod) async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    String url = "";
    if (kod) {
      url = MyApp.apiUrl + "apisayim/StokKoduAra";
      parametreler.add(txtStokKodu.text);
    } else {
      url = MyApp.apiUrl + "apisayim/StokAdiAra";
      parametreler.add(txtStokAdi.text);
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

    List f10data = json.decode(sn.sonuc);

    BasariUtilities().f10(
        context,
        "Stok Listesi",
        DataTable(
            dataRowHeight: 35.0,
            columnSpacing: 10,
            showCheckboxColumn: false,
            columns: <DataColumn>[
              DataColumn(label: Text("Stok Kodu")),
              DataColumn(label: Text("Stok Adı"))
            ],
            rows: f10data
                .map((e) => DataRow(
                        onSelectChanged: (b) {
                          if (b) {
                            txtStokKodu.text = e["stokkodu"];
                            setState(() {});
                            Navigator.of(context).pop();
                            stokGetir();
                          }
                        },
                        cells: <DataCell>[
                          DataCell(Text(e["stokkodu"])),
                          DataCell(Text(e["stokadi"])),
                        ]))
                .toList()));
  }

  void stokGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> sbp = {
      "stokkodu": txtStokKodu.text,
      "depo": depoNo,
    };
    parametreler.add(jsonEncode(sbp));
    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/StokBilgileri");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtStokKodu.text = gelen["stokkodu"];
      txtStokAdi.text = gelen["stokadi"];
      birimler =
          (gelen["birimler"] as List).map((i) => Birim.fromJson(i)).toList();
      selectedBirim = birimler
          .where((element) => element.birimNo == gelen["birimno"])
          .first;
      focusmiktar.requestFocus();
    }
    setState(() {});
  }

  void barkodAra() async {
    ScanResult scanResult;

    final _possibleFormats = BarcodeFormat.values.toList()
      ..removeWhere((e) => e == BarcodeFormat.unknown);
    List<BarcodeFormat> selectedFormats = [..._possibleFormats];
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "Vazgeç",
          "flash_on": "Flaşı Aç",
          "flash_off": "Flaşı Kapat",
        },
        restrictFormat: selectedFormats,
        useCamera: -1,
        autoEnableFlash: true,
        android: AndroidOptions(
          aspectTolerance: 0.00,
          useAutoFocus: true,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      setState(() {
        scanResult = result;
        txtStokKodu.text = scanResult.rawContent;
        stokGetir();
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {
        scanResult = result;
      });
    }
  }

  void ekle() async {
    if (txtStokKodu.text.length == 0) {
      Mesajlar().tamam(context, Text("Stok kodu geçersiz"), Text("Hata"));
      return;
    }

    if (BasariUtilities().getdeci(clcMiktar.text) <= 0) {
      Mesajlar().tamam(context, Text("Stok kodu geçersiz"), Text("Hata"));
      return;
    }
    Map<String, dynamic> ekleparams = {
      'stok': txtStokKodu.text,
      'partikodu': '',
      'lotno': 0,
      'partibarkodu': '',
      'birimno': selectedBirim.birimNo,
      'miktar': BasariUtilities().getdeci(clcMiktar.text),
      'eklenenler': dsevrak,
      'evraksira': BasariUtilities().tamsayi(clcEvrakSira.text),
      'sayimtarihi': sayimTarihi.toIso8601String(),
      'depono': depoNo,
    };

    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(jsonEncode(ekleparams));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/Ekle");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      clcEvrakSira.text = gelen["evraksira"].toString();
      dsevrak = (gelen["eklenenler"] as List)
          .map((e) => EvrakSatir.fromJson(e))
          .toList();
      stokTemizle();
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("HATA"));
    }
    setState(() {});
  }

  void stokTemizle() {
    txtStokKodu.text = "";
    txtStokAdi.text = "";
    clcMiktar.text = "";
    birimler.clear();
    focusstokkodu.requestFocus();
    setState(() {});
  }

  Future onLoad() async {
    dtSayimTarihi.text = intl.DateFormat("dd.MM.yyyy").format(sayimTarihi);
    clcEvrakSira.text = "0";
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/FormLoad");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      List<Parametre> params = (gelen["listparams"] as List)
          .map((e) => Parametre.fromJson(e))
          .toList();
      txtDepo.text = gelen["depoadi"];

      for (int i = 0; i < params.length; i++) {
        switch (params[i].parametreno) {
          case 12001:
            depoNo = params[i].sonuc;
            break;
          case 13008:
            if (params[i].sonuc == 0) {
              readonlySayimTarihi = true;
            }
            break;
          case 13010:
            if (params[i].sonuc == 0) {
              readonlyDepo = true;
            }
            break;
          default:
            //console.log(params[i].parametreno+" "+params[i].sonuc);
            break;
        }
      }
    } else {
      Mesajlar().tamam(context, Text("Parametreler okunamadı"), Text("Uyarı"));
    }
  }

  void satirSil(EvrakSatir es) async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(jsonEncode(es.kayitrecno));
    parametreler.add(jsonEncode(es.kayitguid));

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apisayim/SatirSil");
    if (sn.basarili) {
      dsevrak.remove(es);
      setState(() {});
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("HATA"));
    }
    setState(() {});
  }

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
          initialIndex: selectedTab,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Sayım"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Depo"),
                  Tab(text: "Stok"),
                  Tab(text: "Evrak"),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                //////////////////// Depo Sayfası//////////////
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Depo",
                          onPressedAra: depoAra,
                          txtkod: txtDepo,
                          buttonVisible: !readonlyDepo,
                        ),
                        FormTarih(
                          labelicerik: "Sayım Tarihi",
                          dttarih: dtSayimTarihi,
                          tarih: sayimTarihi,
                          setTarih: (DateTime foo) {
                            sayimTarihi = foo;
                          },
                          readonlytarih: readonlySayimTarihi,
                          //ctx: context,
                        ),
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Evrak No",
                          txtkod: clcEvrakSira,
                          onPressedAra: evrakAra,
                          buttonVisible: true,
                        ),
                      ],
                    )),

/////////////////////////////////// Stok sayfası /////////////////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormTextAramaliCiftBtn(
                        txtkod: txtStokKodu,
                        onPressedAra: stokKoduAra,
                        labelicerik: "Stok Kodu",
                        onKeyDown: stokGetir,
                        onPressedBar: barkodAra,
                        readOnly: false,
                        focusnode: focusstokkodu,
                      ),
                      FormTextAramali(
                        labelicerik: "Stok Adı",
                        txtkod: txtStokAdi,
                        onPressedAra: stokAdiAra,
                      ),
                      FormMiktarveBirim(
                        labelicerik: "Miktar",
                        birimler: birimler,
                        clcmiktar: clcMiktar,
                        selectedValue: selectedBirim,
                        setBirim: (Birim foo) {
                          selectedBirim = foo;
                        },
                        focusnode: focusmiktar,
                      ),
                      FormCiftButton(
                        button1flex: 5,
                        button1icerik: "Ekle",
                        button1islem: ekle,
                        button1renk: Colors.green[400],
                        button2flex: 3,
                        button2icerik: "Temizle",
                        button2islem: stokTemizle,
                        button2renk: Colors.red[400],
                      ),
                    ],
                  ),
                ),
                /////////////////////////////EVRAK//////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        columnSpacing: 10,
                        dataRowHeight: 40,
                        showCheckboxColumn: false,
                        columns: <DataColumn>[
                          DataColumn(label: Text("Stok")),
                          DataColumn(label: Text("Miktar"), numeric: true),
                          DataColumn(label: Text("Sil")),
                        ],
                        rows: dsevrak
                            .map((e) => DataRow(cells: [
                                  DataCell(Column(
                                    children: <Widget>[
                                      Text(e.stokkodu),
                                      Text(e.stokadi),
                                    ],
                                  )),
                                  DataCell(Text("${e.miktar} ${e.birimadi}")),
                                  DataCell(RaisedButton(
                                      child: Text("Satır Sil"),
                                      onPressed: () {
                                        Future<bool> cevap = Mesajlar().yesno(
                                            context,
                                            Text(
                                                "Seçili satırı silmek istediğinizden emin misiniz?"),
                                            Text("Uyarı"),
                                            "Sil",
                                            "Vazgeç");
                                        cevap.then((value) {
                                          if (value) {
                                            satirSil(e);
                                          }
                                        });
                                      }))
                                ]))
                            .toList()),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () => Mesajlar().backPressed(context));
  }
}

class EvrakSatir {
  int kayitrecno;
  String kayitguid;
  String stokkodu;
  String stokadi;
  String partikodu;
  int lotno;
  String partilotbarkod;
  double miktar;
  String birimadi;
  String guid;

  EvrakSatir(
      {this.kayitrecno,
      this.kayitguid,
      this.stokkodu,
      this.stokadi,
      this.partikodu,
      this.lotno,
      this.partilotbarkod,
      this.miktar,
      this.birimadi,
      this.guid});

  factory EvrakSatir.fromJson(Map<String, dynamic> json) {
    return EvrakSatir(
      kayitrecno: json["kayitrecno"],
      kayitguid: json["kayitguid"],
      stokkodu: json["stokkodu"],
      stokadi: json["stokadi"],
      partikodu: json["partikodu"],
      lotno: json["lotno"],
      partilotbarkod: json["partilotbarkod"],
      miktar: json["miktar"],
      birimadi: json["birimadi"],
      guid: json["guid"],
    );
  }

  Map<String, dynamic> toJson() => {
        'kayitrecno': kayitrecno,
        'kayitguid': kayitguid,
        'stokkodu': stokkodu,
        'stokadi': stokadi,
        'partikodu': partikodu,
        'lotno': lotno,
        'partilotbarkod': partilotbarkod,
        'miktar': miktar,
        'birimadi': birimadi,
        'guid': guid,
      };
}
