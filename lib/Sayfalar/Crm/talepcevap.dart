import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_editor/html_editor.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';

import '../../main.dart';

class PageTalepCevap extends StatefulWidget {
  final int talepNo;
  final String mesaj;
  bool sadeceMesaj;

  PageTalepCevap({this.talepNo, this.mesaj, this.sadeceMesaj});

  @override
  State<StatefulWidget> createState() {
    return PageTalepCevapState();
  }
}

class PageTalepCevapState extends State<PageTalepCevap> {
  String cevap = "";
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  List<String> islemler = [];

  void cevapEkle() async {
    cevap = await keyEditor.currentState.getText();
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> talepbilgileri = {
      "TalepNo": widget.talepNo,
      "Mesaj": cevap
    };
    parametreler.add(jsonEncode(talepbilgileri));
    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apitumtalepler/MesajKaydet",context);
    if (sn.basarili) {
      Mesajlar().toastMesaj("Cevabınız kaydedildi");
      Navigator.pop(context, "Cevap Eklendi");
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
  }

  void cozuldu() async {
    cevap = await keyEditor.currentState.getText();
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> talepbilgileri = {
      "TalepNo": widget.talepNo,
      "Mesaj": cevap
    };
    parametreler.add(jsonEncode(talepbilgileri));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/MesajCozulduKaydet",context);
    if (sn.basarili) {
      Mesajlar().toastMesaj("Çözüldü olarak kaydedildi");
      Navigator.pop(context, "Çözüldü");
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
  }

  Future<bool> backPressed() async {
    if (widget.sadeceMesaj)
      return Future.value(true);
    else {
      cevap = await keyEditor.currentState.getText();
      if (cevap == "")
        return Future.value(true);
      else {
        return Mesajlar().yesno(
                context,
                Text("Çıkmak istediğinizden emin misiniz"),
                Text("Uyarı"),
                "Çık",
                "Vazgeç") ??
            false;
      }
    }
  }

  void kaydet() async {
    cevap = await keyEditor.currentState.getText();
    Navigator.pop(context, cevap);
  }

  void islemYap(String islem) {
    if (islem == "Cevabı Kaydet") {
      cevapEkle();
    } else if (islem == "Çözüldü") {
      cozuldu();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sadeceMesaj == null) widget.sadeceMesaj = false;
    if (widget.sadeceMesaj) {
      cevap = widget.mesaj;
    }
    islemler.clear();
    islemler.add("Cevabı Kaydet");
    islemler.add("Çözüldü");
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.sadeceMesaj ? "Mesajlar" : "Talep Cevaplama"),
            actions: <Widget>[
              Visibility(
                  visible: widget.talepNo == 0,
                  child: IconButton(icon: Icon(Icons.save), onPressed: kaydet)),
              Visibility(
                visible: !widget.sadeceMesaj,
                child: PopupMenuButton<String>(
                    onSelected: islemYap,
                    itemBuilder: (BuildContext context) {
                      return islemler.map((String e) {
                        return PopupMenuItem<String>(
                          child: Text(e),
                          value: e,
                        );
                      }).toList();
                    }),
              )
            ],
          ),
          body: Builder(builder: (context) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  HtmlEditor(
                    value: cevap,
                    hint: cevap,
                    key: keyEditor,
                    height: MediaQuery.of(context).size.height -
                        Scaffold.of(context).appBarMaxHeight,
                  ),
                ],
              ),
            );
          }),
        ),
        onWillPop: backPressed);
  }
}
