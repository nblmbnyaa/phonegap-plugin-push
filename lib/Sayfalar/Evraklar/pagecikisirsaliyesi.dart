import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/form2sayisal.dart';
import 'package:prosis_mobile/Genel/form3sayisal.dart';
import 'package:prosis_mobile/Genel/formCiftButton.dart';
import 'package:prosis_mobile/Genel/formTekButton.dart';
import 'package:prosis_mobile/Genel/formevrakserisira.dart';
import 'package:prosis_mobile/Genel/formmiktarvebirim.dart';
import 'package:prosis_mobile/Genel/formbirimfiyatvedoviz.dart';
import 'package:prosis_mobile/Genel/formtarih.dart';
import 'package:prosis_mobile/Genel/formtextaramali.dart';
import 'package:prosis_mobile/Genel/formtextaramaliciftbtn.dart';
import 'package:prosis_mobile/Genel/formtextaramasiz.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:prosis_mobile/main.dart';
import 'package:intl/intl.dart' as intl;
import 'package:barcode_scan/barcode_scan.dart';

class PageCikisIrsaliyesi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageCikisIrsaliyesiState();
  }
}

class PageCikisIrsaliyesiState extends State<PageCikisIrsaliyesi> {
  BasariUtilities bu = BasariUtilities();
  TextEditingController txtCariKod = TextEditingController();
  TextEditingController txtCariUnvan = TextEditingController();
  TextEditingController txtEvrakSeri = TextEditingController();
  bool readonlyseri = false;
  TextEditingController clcEvrakSira = TextEditingController();
  bool readonlysira = false;

  DateTime evrakTarihi =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TextEditingController dtEvrakTarihi = TextEditingController();
  bool readonlyevraktarihi = false;
  TextEditingController txtBelgeNo = new TextEditingController();
  TextEditingController dtBelgeTarihi = TextEditingController();
  DateTime belgeTarihi =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  TextEditingController txtOdemePlani = TextEditingController();
  int odemePlani = 0;
  bool readonlyOdemePlani = false;
  TextEditingController txtDepo = TextEditingController();
  int depoNo = 0;
  bool readonlyDepo = false;
  TextEditingController txtPlasiyer = TextEditingController();
  String plasiyerKodu = "";
  bool readonlyPlasiyer = false;
  TextEditingController txtProje = TextEditingController();
  String projeKodu = "";
  bool readonlyProje = false;
  TextEditingController txtSrmMrk = TextEditingController();
  String srmMrkKodu = "";
  bool readonlySrmMer = false;
  bool plasiyerCaridenGelsinmi = false;
  List<dynamic> dsSiparisler = [];

  TextEditingController txtStokKodu = TextEditingController();
  FocusNode focusstokkodu = new FocusNode();
  TextEditingController txtStokAdi = TextEditingController();
  TextEditingController clcMiktar = TextEditingController();
  List<Birim> birimler = [];
  Birim selectedBirim;
  FocusNode focusmiktar = new FocusNode();
  TextEditingController clcBirimFiyat = TextEditingController();
  bool readonlyBirimFiyat = false;
  List<Doviz> dovizler = [];
  Doviz selectedDoviz;
  num vergiorani = 0;
  num birincifiyat = 0;
  TextEditingController clcIsk1 = TextEditingController();
  TextEditingController clcIsk2 = TextEditingController();
  TextEditingController clcIsk3 = TextEditingController();
  bool readOnlyIsk1 = false;
  bool readOnlyIsk2 = false;
  bool readOnlyIsk3 = false;
  TextEditingController clcTutarKdvHaric = TextEditingController();
  TextEditingController clcTutarKdvDahil = TextEditingController();
  bool readOnlyTutarKdvHaric = true;
  bool readOnlyTutarKdvDahil = true;
  List<EvrakSatir> dsevrak = new List<EvrakSatir>();
  String ozettempguid;
  TextEditingController txtEvrakAciklama1 = TextEditingController();
  TextEditingController txtEvrakAciklama2 = TextEditingController();
  TextEditingController txtEvrakAciklama3 = TextEditingController();
  TextEditingController txtEvrakAciklama4 = TextEditingController();
  TextEditingController txtEvrakAciklama5 = TextEditingController();
  TextEditingController txtEvrakAciklama6 = TextEditingController();
  TextEditingController txtEvrakAciklama7 = TextEditingController();
  TextEditingController txtEvrakAciklama8 = TextEditingController();
  TextEditingController txtEvrakAciklama9 = TextEditingController();
  TextEditingController txtEvrakAciklama10 = TextEditingController();
  bool readOnlyEvrakAciklama1 = false;
  bool readOnlyEvrakAciklama2 = false;
  bool readOnlyEvrakAciklama3 = false;
  bool readOnlyEvrakAciklama4 = false;
  bool readOnlyEvrakAciklama5 = false;
  bool readOnlyEvrakAciklama6 = false;
  bool readOnlyEvrakAciklama7 = false;
  bool readOnlyEvrakAciklama8 = false;
  bool readOnlyEvrakAciklama9 = false;
  bool readOnlyEvrakAciklama10 = false;
  TextEditingController txtToplamTutar = TextEditingController();
  TextEditingController txtToplamIskonto = TextEditingController();
  TextEditingController txtToplamMatrah = TextEditingController();
  TextEditingController txtToplamVergi = TextEditingController();
  TextEditingController txtToplamYekun = TextEditingController();
  int selectedTab = 0;

  Future onLoad() async {
    dtEvrakTarihi.text = intl.DateFormat("dd.MM.yyyy").format(evrakTarihi);
    dtBelgeTarihi.text = intl.DateFormat("dd.MM.yyyy").format(belgeTarihi);

    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/FormLoad", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      List<Parametre> params = (gelen["listparams"] as List)
          .map((e) => Parametre.fromJson(e))
          .toList();
      clcEvrakSira.text = gelen["evraksira"].toString();
      txtDepo.text = gelen["depoadi"];
      txtPlasiyer.text = gelen["plasiyeradi"];
      ozettempguid = gelen["ozettempguid"];

      for (int i = 0; i < params.length; i++) {
        switch (params[i].parametreno) {
          case 11001:
            txtEvrakSeri.text = params[i].sonuc;
            break;
          case 13006:
            if (params[i].sonuc == 0) {
              readonlyseri = true;
            }
            break;
          case 13007:
            if (params[i].sonuc == 0) {
              readonlysira = true;
            }
            break;
          case 13008:
            if (params[i].sonuc == 0) {
              readonlyevraktarihi = true;
            }
            break;
          case 13009:
            if (params[i].sonuc == 0) {
              readonlyOdemePlani = true;
            }
            break;
          case 13010:
            if (params[i].sonuc == 0) {
              readonlyDepo = true;
            }
            break;
          case 12001:
            depoNo = params[i].sonuc;
            break;
          case 13011:
            if (params[i].sonuc == 0) {
              readonlyPlasiyer = true;
            }
            break;
          case 12010:
            plasiyerKodu = params[i].sonuc;
            break;
          case 14008:
            if (params[i].sonuc == 1) {
              plasiyerCaridenGelsinmi = true;
            }
            break;
          case 13012:
            if (params[i].sonuc == 0) {
              readonlyProje = true;
            }
            break;
          case 13013:
            if (params[i].sonuc == 0) {
              readonlySrmMer = true;
            }
            break;
          case 13014:
            if (params[i].sonuc == 0) {
              readonlyBirimFiyat = true;
            }
            break;
          case 13015:
            if (params[i].sonuc == 0) {
              readOnlyIsk1 = true;
            }
            break;
          case 13016:
            if (params[i].sonuc == 0) {
              readOnlyIsk2 = true;
            }
            break;
          case 13017:
            if (params[i].sonuc == 0) {
              readOnlyIsk3 = true;
            }
            break;
          case 13018:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama1 = true;
            }
            break;
          case 13019:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama2 = true;
            }
            break;
          case 13020:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama3 = true;
            }
            break;
          case 13021:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama4 = true;
            }
            break;
          case 13022:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama5 = true;
            }
            break;
          case 13023:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama6 = true;
            }
            break;
          case 13024:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama7 = true;
            }
            break;
          case 13025:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama8 = true;
            }
            break;
          case 13026:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama9 = true;
            }
            break;
          case 13027:
            if (params[i].sonuc == 0) {
              readOnlyEvrakAciklama10 = true;
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
      url = MyApp.apiUrl + "apicikisirsaliyesi/CariKodAra";
      parametreler.add(txtCariKod.text);
    } else {
      url = MyApp.apiUrl + "apicikisirsaliyesi/CariUnvanAra";
      parametreler.add(txtCariUnvan.text);
    }

    DefaultReturn sn =
        await BasariUtilities().getApiSonuc(parametreler, url, context);
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
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Cari Kod")),
            DataColumn(label: Text("Cari Unvan")),
          ],
          rows: cariler
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtCariKod.text = e["carikod"];
                        setState(() {});
                        Navigator.of(context).pop();
                        cariGetir();
                      },
                      cells: [
                        DataCell(
                          Text(e["carikod"]),
                        ),
                        DataCell(
                          Text(e["cariunvan"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void cariGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtCariKod.text);
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apicikisirsaliyesi/CariBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtCariKod.text = gelen["cari_kod"];
      txtCariUnvan.text = gelen["cari_unvan1"];
      odemePlani = gelen["cari_odemeplan_no"];
      txtOdemePlani.text = gelen["odp_adi"];
      dsSiparisler = gelen["siparisler"];
      if (gelen["efaturami"] == true && gelen["evraksira"] > 0) {
        txtEvrakSeri.text = gelen["evrakseri"];
        clcEvrakSira.text = gelen["evraksira"];
      }
      if (plasiyerCaridenGelsinmi) {
        plasiyerKodu = gelen["cari_temsilci_kodu"];
        txtPlasiyer.text = gelen["temsilciadi"];
      }
    }
    setState(() {});
  }

  void odemePlaniAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apicikisirsaliyesi/OdemePlaniAra", context);
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
      "Ödeme Planı Listesi",
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
                          txtOdemePlani.text = e["odp_adi"];
                          odemePlani = e["odp_no"];
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(e["odp_no"].toString())),
                        DataCell(Text(e["odp_adi"])),
                      ]))
              .toList()),
    );
  }

  void depoAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/DepoAra", context);
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

  void plasiyerAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/PlasiyerAra", context);
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
      "Plasiyer Listesi",
      DataTable(
          dataRowHeight: 35.0,
          columnSpacing: 10,
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Text("Kod")),
            DataColumn(label: Text("Adı"))
          ],
          rows: gelen
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        if (b) {
                          txtPlasiyer.text = e["adi"];
                          plasiyerKodu = e["cari_per_kod"];
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(e["cari_per_kod"])),
                        DataCell(Text(e["adi"])),
                      ]))
              .toList()),
    );
  }

  void projeAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/ProjeAra", context);
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
      "Proje Listesi",
      DataTable(
          dataRowHeight: 35.0,
          columnSpacing: 10,
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Text("Kod")),
            DataColumn(label: Text("Adı"))
          ],
          rows: gelen
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        if (b) {
                          txtProje.text = e["pro_adi"];
                          projeKodu = e["pro_kodu"];
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(e["pro_kodu"])),
                        DataCell(Text(e["pro_adi"])),
                      ]))
              .toList()),
    );
  }

  void srmMrkAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/SrmMrkAra", context);
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
      "Sorumluluk Merkezi Listesi",
      DataTable(
          dataRowHeight: 35.0,
          columnSpacing: 10,
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Text("Kod")),
            DataColumn(label: Text("Adı"))
          ],
          rows: gelen
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        if (b) {
                          txtSrmMrk.text = e["som_isim"];
                          srmMrkKodu = e["som_kod"];
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(e["som_kod"])),
                        DataCell(Text(e["som_isim"])),
                      ]))
              .toList()),
    );
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
      url = MyApp.apiUrl + "apicikisirsaliyesi/StokKoduAra";
      parametreler.add(txtStokKodu.text);
    } else {
      url = MyApp.apiUrl + "apicikisirsaliyesi/StokAdiAra";
      parametreler.add(txtStokAdi.text);
    }

    DefaultReturn sn =
        await BasariUtilities().getApiSonuc(parametreler, url, context);
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
      "Stok Listesi",
      DataTable(
          dataRowHeight: 35.0,
          columnSpacing: 10,
          showCheckboxColumn: false,
          columns: <DataColumn>[
            DataColumn(label: Text("Stok Kodu")),
            DataColumn(label: Text("Stok Adı"))
          ],
          rows: gelen
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
              .toList()),
    );
  }

  void stokGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> sbp = {
      'carikod': txtCariKod.text,
      "stokkodu": txtStokKodu.text,
      "depo": depoNo,
      "siparisler": dsSiparisler,
    };
    parametreler.add(jsonEncode(sbp));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apicikisirsaliyesi/StokBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtStokKodu.text = gelen["stokkodu"];
      txtStokAdi.text = gelen["stokadi"];
      birimler =
          (gelen["birimler"] as List).map((i) => Birim.fromJson(i)).toList();
      selectedBirim = birimler
          .where((element) => element.birimNo == gelen["birimno"])
          .first;

      clcIsk1.text = gelen["isk1y"].toString();
      clcIsk2.text = gelen["isk2y"].toString();
      clcIsk3.text = gelen["isk3y"].toString();
      birincifiyat = gelen["birimfiyat"];
      clcBirimFiyat.text = intl.NumberFormat("#,###0.000")
          .format(birincifiyat * selectedBirim.katsayi);
      vergiorani = gelen["vergiorani"];
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
      'cari': txtCariKod.text,
      'stok': txtStokKodu.text,
      'partikodu': '',
      'lotno': 0,
      'partibarkodu': '',
      'birimno': selectedBirim.birimNo,
      'miktar': BasariUtilities().getdeci(clcMiktar.text),
      'birimfiyat': BasariUtilities().getdeci(clcBirimFiyat.text),
      'isk1y': BasariUtilities().getdeci(clcIsk1.text),
      'isk2y': BasariUtilities().getdeci(clcIsk2.text),
      'isk3y': BasariUtilities().getdeci(clcIsk3.text),
      'eklenenler': dsevrak,
      'ozettempguid': ozettempguid,
      'evrakseri': txtEvrakSeri.text,
      'evraksira': BasariUtilities().tamsayi(clcEvrakSira.text),
      'evraktarihi': evrakTarihi.toIso8601String(),
      'belgeno': txtBelgeNo.text,
      'belgetarihi': belgeTarihi.toIso8601String(),
      'odemeplanno': odemePlani,
      'depono': depoNo,
      'plasiyer': plasiyerKodu,
      'projekodu': projeKodu,
      'srmmrkkodu': srmMrkKodu,
      'aciklama1': txtEvrakAciklama1.text,
      'aciklama2': txtEvrakAciklama2.text,
      'aciklama3': txtEvrakAciklama3.text,
      'aciklama4': txtEvrakAciklama4.text,
      'aciklama5': txtEvrakAciklama5.text,
      'aciklama6': txtEvrakAciklama6.text,
      'aciklama7': txtEvrakAciklama7.text,
      'aciklama8': txtEvrakAciklama8.text,
      'aciklama9': txtEvrakAciklama9.text,
      'aciklama10': txtEvrakAciklama10.text,
      'siparisler': dsSiparisler,
    };

    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(jsonEncode(ekleparams));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/Ekle", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      dsevrak = (gelen["eklenenler"] as List)
          .map((e) => EvrakSatir.fromJson(e))
          .toList();
      dsSiparisler = gelen["siparisler"];
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
    clcBirimFiyat.text = "";
    clcIsk1.text = "";
    clcIsk2.text = "";
    clcIsk3.text = "";
    clcTutarKdvDahil.text = "";
    clcTutarKdvHaric.text = "";
    focusstokkodu.requestFocus();
    dipToplamHesapla();
    setState(() {});
  }

  void dipToplamHesapla() {
    num ttutar = 0;
    num tiskonto = 0;
    num tmatrah = 0;
    num tvergi = 0;
    num tyekun = 0;
    for (int i = 0; i < dsevrak.length; i++) {
      num tutar = dsevrak[i].birimfiyat * dsevrak[i].miktar;
      num matrah = tutar *
          (1 - dsevrak[i].isk1y / 100) *
          (1 - dsevrak[i].isk3y / 100) *
          (1 - dsevrak[i].isk3y / 100);
      num iskonto = tutar - matrah;
      num vergi = matrah * dsevrak[i].vergiorani / 100;
      num yekun = matrah + vergi;

      ttutar += tutar;
      tiskonto += iskonto;
      tmatrah += matrah;
      tvergi += vergi;
      tyekun += yekun;
    }
    txtToplamTutar.text = intl.NumberFormat("#,##0.00").format(ttutar);
    txtToplamIskonto.text = intl.NumberFormat("#,##0.00").format(tiskonto);
    txtToplamMatrah.text = intl.NumberFormat("#,##0.00").format(tmatrah);
    txtToplamVergi.text = intl.NumberFormat("#,##0.00").format(tvergi);
    txtToplamYekun.text = intl.NumberFormat("#,##0.00").format(tyekun);
  }

  void yeniEvrak() {
    txtEvrakSeri.text = "";
    clcEvrakSira.text = "";
    evrakTarihi =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    dtEvrakTarihi.text = intl.DateFormat("dd.MM.yyyy").format(evrakTarihi);
    belgeTarihi =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    dtBelgeTarihi.text = intl.DateFormat("dd.MM.yyyy").format(belgeTarihi);
    txtCariKod.text = "";
    txtCariUnvan.text = "";
    odemePlani = 0;
    txtOdemePlani.text = "";
    depoNo = 0;
    txtDepo.text = "";
    plasiyerKodu = "";
    txtPlasiyer.text = "";
    projeKodu = "";
    txtProje.text = "";
    srmMrkKodu = "";
    txtSrmMrk.text = "";
    dsevrak.clear();
    dsSiparisler.clear();
    stokTemizle();

    txtEvrakAciklama1.text = "";
    txtEvrakAciklama2.text = "";
    txtEvrakAciklama3.text = "";
    txtEvrakAciklama4.text = "";
    txtEvrakAciklama5.text = "";
    txtEvrakAciklama6.text = "";
    txtEvrakAciklama7.text = "";
    txtEvrakAciklama8.text = "";
    txtEvrakAciklama9.text = "";
    txtEvrakAciklama10.text = "";
    selectedTab = 0;
    onLoad();
  }

  void kaydet() async {
    Map<String, dynamic> kaydetparams = {
      'ozettempguid': ozettempguid,
      'evrakseri': txtEvrakSeri.text,
      'evraksira': BasariUtilities().tamsayi(clcEvrakSira.text),
      'evraktarihi': evrakTarihi.toIso8601String(),
      'belgeno': txtBelgeNo.text,
      'belgetarihi': belgeTarihi.toIso8601String(),
      'carikod': txtCariKod.text,
      'odemeplanno': odemePlani,
      'depono': depoNo,
      'plasiyer': plasiyerKodu,
      'projekodu': projeKodu,
      'srmmrkkodu': srmMrkKodu,
      'eklenenler': dsevrak,
      'aciklama1': txtEvrakAciklama1.text,
      'aciklama2': txtEvrakAciklama2.text,
      'aciklama3': txtEvrakAciklama3.text,
      'aciklama4': txtEvrakAciklama4.text,
      'aciklama5': txtEvrakAciklama5.text,
      'aciklama6': txtEvrakAciklama6.text,
      'aciklama7': txtEvrakAciklama7.text,
      'aciklama8': txtEvrakAciklama8.text,
      'aciklama9': txtEvrakAciklama9.text,
      'aciklama10': txtEvrakAciklama10.text,
    };

    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(jsonEncode(kaydetparams));

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apicikisirsaliyesi/Kaydet", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      Mesajlar().tamam(
          context,
          Text("Evrak kaydedildi " +
              gelen["seri"] +
              "-" +
              gelen["sira"].toString()),
          Text("Bilgi"));
      yeniEvrak();
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("HATA"));
    }
    setState(() {});
  }

  void tutarlariYenile() {
    num miktar = bu.getdeci(clcMiktar.text);
    num birimfiyat = bu.getdeci(clcBirimFiyat.text);
    num isk1 = bu.getdeci(clcIsk1.text);
    num isk2 = bu.getdeci(clcIsk2.text);
    num isk3 = bu.getdeci(clcIsk3.text);
    clcTutarKdvHaric.text =
        intl.NumberFormat("#,##0.00").format(miktar * birimfiyat);
    clcTutarKdvDahil.text = intl.NumberFormat("#,##0.00").format(miktar *
        birimfiyat *
        (1 - isk1 / 100) *
        (1 - isk2 / 100) *
        (1 - isk3 / 100) *
        (1 + vergiorani / 100));
  }

  @override
  void initState() {
    onLoad();
    super.initState();
  }

  ///////////////////////////////TASARIM/////////////////////////////
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
          initialIndex: selectedTab,
          length: 6,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Çıkış İrsaliyesi"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Cari"),
                  Tab(text: "Stok"),
                  Tab(text: "Evrak"),
                  Tab(text: "Siparişler"),
                  Tab(text: "Açıklamalar"),
                  Tab(text: "Kayıt"),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                //////////////////// Cari Sayfası//////////////
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        FormEvrakSeriSira(
                          labelicerik: "Evrak No",
                          txtseri: txtEvrakSeri,
                          clcsira: clcEvrakSira,
                          readonlyseri: readonlyseri,
                          readonlysira: readonlysira,
                        ),
                        FormTarih(
                          labelicerik: "Evrak Tarihi",
                          dttarih: dtEvrakTarihi,
                          tarih: evrakTarihi,
                          setTarih: (DateTime foo) {
                            evrakTarihi = foo;
                          },
                          readonlytarih: readonlyevraktarihi,
                          //ctx: context,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Belge No",
                          txtkod: txtBelgeNo,
                        ),
                        FormTarih(
                          dttarih: dtBelgeTarihi,
                          labelicerik: "Belge Tarihi",
                          tarih: belgeTarihi,
                          setTarih: (DateTime foo) {
                            belgeTarihi = foo;
                          },
                        ),
                        FormTextAramali(
                          txtkod: txtCariKod,
                          labelicerik: "Cari Kod",
                          onPressedAra: cariKodAra,
                          onKeyDown: cariGetir,
                        ),
                        FormTextAramali(
                          txtkod: txtCariUnvan,
                          labelicerik: "Cari Unvan",
                          onPressedAra: cariUnvanAra,
                        ),
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Ödeme Planı",
                          txtkod: txtOdemePlani,
                          onPressedAra: odemePlaniAra,
                          buttonVisible: !readonlyOdemePlani,
                        ),
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Depo",
                          onPressedAra: depoAra,
                          txtkod: txtDepo,
                          buttonVisible: !readonlyDepo,
                        ),
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Plasiyer",
                          onPressedAra: plasiyerAra,
                          txtkod: txtPlasiyer,
                          buttonVisible: !readonlyPlasiyer,
                        ),
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Proje",
                          onPressedAra: projeAra,
                          txtkod: txtProje,
                          buttonVisible: !readonlyProje,
                        ),
                        FormTextAramali(
                          readOnly: true,
                          labelicerik: "Srm Mrk",
                          onPressedAra: srmMrkAra,
                          txtkod: txtSrmMrk,
                          buttonVisible: !readonlySrmMer,
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
                          clcBirimFiyat.text = intl.NumberFormat("#,##0.00")
                              .format(birincifiyat * selectedBirim.katsayi);
                        },
                        onChanged: (String str) {
                          tutarlariYenile();
                        },
                        focusnode: focusmiktar,
                      ),
                      FormBirimFiyatveDoviz(
                        labelicerik: "Birim Fiyat",
                        dovizler: dovizler,
                        clcmiktar: clcBirimFiyat,
                        selectedValue: selectedDoviz,
                        setDoviz: (Doviz foo) {
                          selectedDoviz = foo;
                        },
                        readonlyfiyat: readonlyBirimFiyat,
                        setfiyat: (String str) {
                          num yenifiyat = bu.getdeci(str);
                          if (selectedBirim.katsayi != 0)
                            birincifiyat = yenifiyat / selectedBirim.katsayi;
                          else
                            birincifiyat = yenifiyat;
                          tutarlariYenile();
                        },
                      ),
                      Form3Sayisal(
                        clcdeger1: clcIsk1,
                        clcdeger2: clcIsk2,
                        clcdeger3: clcIsk3,
                        readonly1: readOnlyIsk1,
                        readonly2: readOnlyIsk2,
                        readonly3: readOnlyIsk3,
                        labelicerik: "İskonto",
                        setIsk1: (String str) {
                          if (bu.getdeci(str) > 100) clcIsk1.text = "100.0";
                          tutarlariYenile();
                        },
                        setIsk2: (String str) {
                          if (bu.getdeci(str) > 100) clcIsk2.text = "100.0";
                          tutarlariYenile();
                        },
                        setIsk3: (String str) {
                          if (bu.getdeci(str) > 100) clcIsk3.text = "100.0";
                          tutarlariYenile();
                        },
                      ),
                      Form2Sayisal(
                        labelicerik: "Tutar H/D",
                        clcdeger1: clcTutarKdvHaric,
                        clcdeger2: clcTutarKdvDahil,
                        readonly1: readOnlyTutarKdvHaric,
                        readonly2: readOnlyTutarKdvDahil,
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
                          DataColumn(label: Text("Miktar")),
                          DataColumn(label: Text("Birim Fiyat"), numeric: true),
                          DataColumn(label: Text("Tutar"), numeric: true),
                          DataColumn(label: Text("Sil")),
                        ],
                        rows: dsevrak
                            .map((e) => DataRow(cells: [
                                  DataCell(
                                    Container(
                                      width: 150,
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: <Widget>[
                                              Text(e.stokkodu),
                                              Text(e.stokadi),
                                            ],
                                          )),
                                    ),
                                  ),
                                  DataCell(Text("${e.miktar} ${e.birimadi}")),
                                  DataCell(Text("${e.birimfiyat} TL")),
                                  DataCell(Text("${e.nettutar} TL")),
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
                                            if (e.siprecno > 0 ||
                                                e.sipguid !=
                                                    "00000000-0000-0000-0000-000000000000") {
                                              var ss = dsSiparisler
                                                  .where((element) =>
                                                      element["siprecno"] ==
                                                          e.siprecno ||
                                                      element["sipguid"] ==
                                                          e.sipguid)
                                                  .first;
                                              ss["okunan"] =
                                                  ss["okunan"] - e.miktar;
                                              ss["kalan"] =
                                                  ss["kalan"] + e.miktar;
                                            }
                                            dsevrak.remove(e);
                                            setState(() {});
                                          }
                                        });
                                      }))
                                ]))
                            .toList()),
                  ),
                ),
                /////////////////////////////Siparişler//////////////////////////
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
                          DataColumn(label: Text("Okunan"), numeric: true),
                          DataColumn(label: Text("Kalan"), numeric: true),
                        ],
                        rows: dsSiparisler
                            .map((e) => DataRow(cells: [
                                  DataCell(
                                    Container(
                                      width: 150,
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            children: <Widget>[
                                              Text(e["stokkodu"]),
                                              Text(e["stokadi"]),
                                            ],
                                          )),
                                    ),
                                  ),
                                  DataCell(
                                      Text("${e["miktar"]} ${e["birim"]}")),
                                  DataCell(Text("${e["okunan"]}")),
                                  DataCell(Text("${e["kalan"]}")),
                                ]))
                            .toList()),
                  ),
                ),
                /////////////////////////////AÇIKLAMALAR/////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormTextAramasiz(
                        labelicerik: "Açıklama 1",
                        txtkod: txtEvrakAciklama1,
                        readonly: readOnlyEvrakAciklama1,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 2",
                        txtkod: txtEvrakAciklama2,
                        readonly: readOnlyEvrakAciklama2,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 3",
                        txtkod: txtEvrakAciklama3,
                        readonly: readOnlyEvrakAciklama3,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 4",
                        txtkod: txtEvrakAciklama4,
                        readonly: readOnlyEvrakAciklama4,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 5",
                        txtkod: txtEvrakAciklama5,
                        readonly: readOnlyEvrakAciklama5,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 6",
                        txtkod: txtEvrakAciklama6,
                        readonly: readOnlyEvrakAciklama6,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 7",
                        txtkod: txtEvrakAciklama7,
                        readonly: readOnlyEvrakAciklama7,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 8",
                        txtkod: txtEvrakAciklama8,
                        readonly: readOnlyEvrakAciklama8,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 9",
                        txtkod: txtEvrakAciklama9,
                        readonly: readOnlyEvrakAciklama9,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Açıklama 10",
                        txtkod: txtEvrakAciklama10,
                        readonly: readOnlyEvrakAciklama10,
                      ),
                    ],
                  ),
                ),
                /////////////////////////////KAYIT/////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormTextAramasiz(
                        labelicerik: "Tutar",
                        txtkod: txtToplamTutar,
                      ),
                      FormTextAramasiz(
                        labelicerik: "İskonto",
                        txtkod: txtToplamIskonto,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Matrah",
                        txtkod: txtToplamMatrah,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Vergi",
                        txtkod: txtToplamVergi,
                      ),
                      FormTextAramasiz(
                        labelicerik: "Yekün",
                        txtkod: txtToplamYekun,
                      ),
                      FormTekButton(
                        icerik: "Kaydet",
                        islem: kaydet,
                        renk: Colors.green[600],
                      ),
                    ],
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
  String stokkodu;
  String stokadi;
  String partikodu;
  int lotno;
  String partilotbarkod;
  double miktar;
  String birimadi;
  double birimfiyat;
  double isk1y;
  double isk2y;
  double isk3y;
  double nettutar;
  double vergiorani;
  int siprecno;
  String sipguid;
  String guid;

  EvrakSatir(
      {this.stokkodu,
      this.stokadi,
      this.partikodu,
      this.lotno,
      this.partilotbarkod,
      this.miktar,
      this.birimadi,
      this.birimfiyat,
      this.isk1y,
      this.isk2y,
      this.isk3y,
      this.nettutar,
      this.vergiorani,
      this.siprecno,
      this.sipguid,
      this.guid});

  factory EvrakSatir.fromJson(Map<String, dynamic> json) {
    return EvrakSatir(
      stokkodu: json["stokkodu"],
      stokadi: json["stokadi"],
      partikodu: json["partikodu"],
      lotno: json["lotno"],
      partilotbarkod: json["partilotbarkod"],
      miktar: json["miktar"],
      birimadi: json["birimadi"],
      birimfiyat: json["birimfiyat"],
      isk1y: json["isk1y"],
      isk2y: json["isk2y"],
      isk3y: json["isk3y"],
      nettutar: json["nettutar"],
      vergiorani: json["vergiorani"],
      siprecno: json["siprecno"],
      sipguid: json["sipguid"],
      guid: json["guid"],
    );
  }

  Map<String, dynamic> toJson() => {
        'stokkodu': stokkodu,
        'stokadi': stokadi,
        'partikodu': partikodu,
        'lotno': lotno,
        'partilotbarkod': partilotbarkod,
        'miktar': miktar,
        'birimadi': birimadi,
        'birimfiyat': birimfiyat,
        'isk1y': isk1y,
        'isk2y': isk2y,
        'isk3y': isk3y,
        'nettutar': nettutar,
        'vergiorani': vergiorani,
        'siprecno': siprecno,
        'sipguid':sipguid,
        'guid': guid,
      };
}
