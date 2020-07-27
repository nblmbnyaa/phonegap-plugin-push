import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:intl/intl.dart' as intl;

class BasariUtilities {
  ProgressDialog pr;

  f10(BuildContext context, String baslik, Widget listView) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(baslik),
            content: Container(
                width: double.maxFinite,
                //height: 300.0,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, child: listView))),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ÇIKIŞ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<DefaultReturn> getApiSonuc(
      List<String> parametreler, String url, BuildContext ctx) async {
    // pr = ProgressDialog(
    //   ctx,
    //   type: ProgressDialogType.Normal,
    //   textDirection: TextDirection.ltr,
    //   isDismissible: false,
    //   customBody: LinearProgressIndicator(
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    //     backgroundColor: Colors.white,
    //   ),
    // );

    DefaultReturn defaultReturn = DefaultReturn();
    defaultReturn.basarili = false;
    defaultReturn.sonuc = "";

    try {
      // await pr.show();
      String params = JsonEncoder().convert(parametreler);
      final cevap = await http.post(url, headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
      }, body: {
        "": params,
      }).timeout(Duration(seconds: 10), onTimeout: () {
        return null;
      }).catchError((onError) {
        print(onError);
      });

      if (cevap != null) {
        if (cevap.statusCode == 200) {
          var sn = DefaultReturn.fromJson(json.decode(cevap.body));
          if (sn.sonuc == "[]") {
            defaultReturn.basarili = false;
            defaultReturn.sonuc = "Veri yok";
          } else {
            defaultReturn.basarili = sn.basarili;
            defaultReturn.sonuc = sn.sonuc;
          }
        } else {
          defaultReturn.sonuc = "Veriler Alınamadı ${cevap.statusCode}";
        }
      } else {
        defaultReturn.sonuc = "Zaman aşımı";
      }
    } catch (ex) {
      defaultReturn.sonuc = "Veriler Alınamadı ${ex.toString()}";
    }
    // Future.delayed(Duration(seconds: 1)).then((value) {
    //      pr.hide().whenComplete(() {
    //      // print(pr.isShowing());
    //     });
    //    });
    //print(hide);
    return defaultReturn;
  }

  double getdeci(var nesne) {
    try {
      return double.parse(nesne);
    } catch (e) {
      return 0.0;
    }
  }

  DateTime getdate(var nesne) {
    try {
      return DateTime.parse(nesne);
    } catch (e) {
      return DateTime(1899, 12, 30);
    }
  }

  String getStringDate(Object nesne) {
    String sonuc = "";
    try {
      sonuc = intl.DateFormat("dd.MM.yyyy").format(nesne);
    } catch (e) {}
    if (sonuc == "30.12.1899") sonuc = "";
    return sonuc;
  }

  int tamsayi(var nesne) {
    try {
      return int.parse(nesne);
    } catch (e) {
      return 0;
    }
  }
}

class DefaultReturn {
  bool basarili;
  String sonuc;

  DefaultReturn({this.basarili, this.sonuc});

  factory DefaultReturn.fromJson(Map<String, dynamic> json) {
    return DefaultReturn(
      basarili: json["Basarili"],
      sonuc: json["Sonuc"].toString(),
    );
  }
}

class UstMenu {
  String baslik;
  String paneladi;
  String resim;

  UstMenu({this.baslik, this.paneladi, this.resim});

  factory UstMenu.fromJson(Map<String, dynamic> json) {
    return UstMenu(
      baslik: json["baslik"],
      paneladi: json["paneladi"],
      resim: json["resim"],
    );
  }
}

class Menu {
  int menuno;
  String viewname;
  String baslik;
  String paneladi;
  bool ozelmenu;

  Menu({this.menuno, this.viewname, this.baslik, this.paneladi, this.ozelmenu});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menuno: json["menuno"],
      viewname: json["viewname"],
      baslik: json["baslik"],
      paneladi: json["paneladi"],
      ozelmenu: json["ozelmenu"],
    );
  }
}

class Birim {
  int birimNo;
  String birimAdi;
  double katsayi;

  Birim({this.birimNo, this.birimAdi, this.katsayi});

  factory Birim.fromJson(Map<String, dynamic> json) {
    return Birim(
      birimNo: json["birimno"],
      birimAdi: json["birimadi"],
      katsayi: json['katsayi'],
    );
  }

  @override
  String toString() {
    return birimAdi;
  }
}

class Doviz {
  int dovizNo;
  String dovizSembol;

  Doviz({this.dovizNo, this.dovizSembol});

  factory Doviz.fromJson(Map<String, dynamic> json) {
    return Doviz(
      dovizNo: json["dovizno"],
      dovizSembol: json["dovizsembol"],
    );
  }

  @override
  String toString() {
    return dovizSembol;
  }
}

class Parametre {
  int menuno;
  int parametreno;
  String ipucu;
  int edittype;
  int parametretipi;

  String stringvalue;
  int intvalue;
  DateTime datetimevalue;
  double decimalvalue;
  bool boolvalue;

  Object sonuc;

  Parametre(
      {this.menuno,
      this.parametreno,
      this.ipucu,
      this.edittype,
      this.parametretipi,
      this.stringvalue,
      this.intvalue,
      this.datetimevalue,
      this.decimalvalue,
      this.boolvalue,
      this.sonuc});

  factory Parametre.fromJson(Map<String, dynamic> json) {
    return Parametre(
        menuno: json["menuno"],
        parametreno: json["parametreno"],
        ipucu: json["ipucu"],
        edittype: json["edittype"],
        parametretipi: json["parametretipi"],
        // stringvalue: json["stringvalue"],
        // intvalue: json["intvalue"],
        // datetimevalue: json["datetimevalue"],
        // decimalvalue: json["decimalvalue"],
        // boolvalue: json["boolvalue"],
        sonuc: json["sonuc"]);
  }
}

class GenelEnum {
  int no;
  String adi;

  GenelEnum({this.no, this.adi});

  factory GenelEnum.fromJson(Map<String, dynamic> json) {
    return GenelEnum(no: json["no"], adi: json["adi"]);
  }

  @override
  String toString() {
    return adi;
  }
}
