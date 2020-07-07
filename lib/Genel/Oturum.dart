

import 'dart:convert';

class OturumBilgileri {
  String sirketkodu;
  String versiyonkodu;
  String kullanicikodu;
  int userid;
  int grupid;
  bool usesqlseq;
  int erpuserno;
  int alternatifdovizcinsi;
  List<Menuler> menuler;

  OturumBilgileri(
      {this.sirketkodu,
      this.versiyonkodu,
      this.kullanicikodu,
      this.userid,
      this.grupid,
      this.usesqlseq,
      this.erpuserno,
      this.alternatifdovizcinsi,
      this.menuler});

      Map<String, dynamic> toJson() => {
        'sirketkodu': sirketkodu,
        'versiyonkodu': versiyonkodu,
        'kullanicikodu': kullanicikodu,
        'userid': userid,
        'grupid': grupid,
        'usesqlseq': usesqlseq,
        'erpuserno': erpuserno,
        'alternatifdovizcinsi': alternatifdovizcinsi,
        'menuler': menuler,
      };

  factory OturumBilgileri.fromJson(Map<String, dynamic> jsonData) {
    var oturumbilgileri = OturumBilgileri(
      alternatifdovizcinsi: jsonData["alternatifdovizcinsi"],
      erpuserno: jsonData["erpuserno"],
      grupid: jsonData["grupid"],
      kullanicikodu: jsonData["kullanicikodu"],
      sirketkodu: jsonData["sirketkodu"],
      userid: jsonData["userid"],
      usesqlseq: jsonData["usesqlseq"],
      versiyonkodu: jsonData["versiyonkodu"],
      menuler: (jsonData['menuler'] as List).map((i) => Menuler.fromJson(i)).toList(),
    );
    
    return oturumbilgileri;
  }
}

class Menuler {
  int menuno;
  String menuadi;

  Menuler({this.menuno, this.menuadi});

  Map<String, dynamic> toJson() => {
        'menuno': menuno,
        'menuadi': menuadi,
      };

  factory Menuler.fromJson(Map<String, dynamic> jsonData) {
    return Menuler(
      menuno: jsonData["menuno"],
      menuadi: jsonData["menuadi"],
    );
  }
}