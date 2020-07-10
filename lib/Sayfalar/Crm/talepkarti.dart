import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formcombobox.dart';
import 'package:prosis_mobile/Genel/formtextaramali.dart';
import 'package:prosis_mobile/Genel/formtextaramasiz.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:html_editor/html_editor.dart';

import '../../main.dart';

class TalepKarti extends StatefulWidget {
  final int talepNo;

  TalepKarti({
    @required this.talepNo,
  });

  @override
  State<StatefulWidget> createState() {
    return TalepKartiState();
  }
}

class TalepKartiState extends State<TalepKarti> {
  TextEditingController txttalepno = TextEditingController();
  TextEditingController txtAcilisZamani = TextEditingController();
  List<GenelEnum> durumlar = [];
  GenelEnum durumu;
  List<GenelEnum> oncelikler = [];
  GenelEnum oncelik;
  List<GenelEnum> destekSekilleri = [];
  GenelEnum destekSekli;
  List<GenelEnum> destekCinsleri = [];
  GenelEnum destekCinsi;
  List<GenelEnum> departmanlar = [];
  GenelEnum departman;
  TextEditingController txtSahibi = TextEditingController();
  TextEditingController txtIlgili = TextEditingController();
  int ilgiliKodu;
  TextEditingController txtMusteriKodu = TextEditingController();
  TextEditingController txtMusteriAdi = TextEditingController();
  TextEditingController txtYetkili = TextEditingController();
  TextEditingController txtEPosta = TextEditingController();
  TextEditingController txtCepTel = TextEditingController();
  TextEditingController txtSabitTel = TextEditingController();
  TextEditingController txtKonu = TextEditingController();
  String mesaj = "";

  void talepDoldur() async {
    if (BasariUtilities().tamsayi(txttalepno.text) == 0)
      txttalepno.text = "38370";

    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> talepbilgileri = {
      "talepno": BasariUtilities().tamsayi(txttalepno.text)
    };
    parametreler.add(jsonEncode(talepbilgileri));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/TalepBilgileri");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtAcilisZamani.text =
          intl.DateFormat("dd.MM.yyyy HH:mm").format(gelen["AcilisZamani"]);
      durumu = durumlar.where((element) => element.no = gelen["Durumu"]).first;
      oncelik =
          oncelikler.where((element) => element.no = gelen["Oncelik"]).first;
      destekSekli = destekSekilleri
          .where((element) => element.no = gelen["DestekSekli"])
          .first;
      destekCinsi = destekCinsleri
          .where((element) => element.no = gelen["DestekCinsi"])
          .first;
      departman = departmanlar
          .where((element) => element.no = gelen["Departmani"])
          .first;
      txtSahibi.text = gelen["Sahibi"];
      txtIlgili.text = gelen["Ilgili"];
      txtMusteriKodu.text = gelen["MusKod"];
      txtMusteriAdi.text = gelen["MusUnvan"];
      txtYetkili.text = gelen["Yetkili"];
      txtEPosta.text = gelen["Eposta"];
      txtCepTel.text = gelen["CepTel"];
      txtSabitTel.text = gelen["SabitTel"];
      txtKonu.text = gelen["Konu"];
      mesaj = gelen["Mesaj"];
    }
    setState(() {});
  }

  void ilgiliAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtIlgili.text);

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apitumtalepler/IlgiliAra");
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
        "İlgili Listesi",
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Kod")),
            DataColumn(label: Text("Adı")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtIlgili.text = e["ilgili"];
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      cells: [
                        DataCell(
                          Text(e["ilgili"]),
                        ),
                        DataCell(
                          Text(e["adi"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void musteriKoduAra() {
    musteriAra(true);
  }

  void musteriAdiAra() {
    musteriAra(false);
  }

  void musteriAra(bool kod) async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));

    String url = "";
    if (kod) {
      url = MyApp.apiUrl + "apitumtalepler/MusteriKodAra";
      parametreler.add(txtMusteriKodu.text);
    } else {
      url = MyApp.apiUrl + "apitumtalepler/MusteriUnvanAra";
      parametreler.add(txtMusteriAdi.text);
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
        "Müşteri Listesi",
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Kod")),
            DataColumn(label: Text("Unvan")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtMusteriKodu.text = e["musterikodu"];
                        setState(() {});
                        Navigator.of(context).pop();
                        musteriGetir();
                      },
                      cells: [
                        DataCell(
                          Text(e["musterikodu"]),
                        ),
                        DataCell(
                          Text(e["musteriunvani"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void musteriGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtMusteriKodu.text);
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/MusteriKodBilgileri");
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtMusteriKodu.text = gelen["musterikodu"];
      txtMusteriAdi.text = gelen["musteriunvani"];
      txtSabitTel.text = gelen["Yetkili"];
    }
    setState(() {});
  }

  void yetkiliAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtMusteriKodu.text);

    DefaultReturn sn = await BasariUtilities()
        .getApiSonuc(parametreler, MyApp.apiUrl + "apitumtalepler/YetkiliAra");
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
        "Yetkili Listesi",
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Adı")),
            DataColumn(label: Text("Unvan")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtYetkili.text = e["yetkili"];
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      cells: [
                        DataCell(
                          Text(e["yetkili"]),
                        ),
                        DataCell(
                          Text(e["yetunvan"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  onLoad() {
    durumlar.add(GenelEnum(no: 0, adi: "Yeni"));
    durumlar.add(GenelEnum(no: 1, adi: "Başlandı"));
    durumlar.add(GenelEnum(no: 2, adi: "Ara Verildi"));
    durumlar.add(GenelEnum(no: 3, adi: "Bekliyor"));
    durumlar.add(GenelEnum(no: 4, adi: "Cevaplandı"));
    durumlar.add(GenelEnum(no: 5, adi: "Çözüldü"));
    durumlar.add(GenelEnum(no: 6, adi: "İptal Edildi"));
    durumlar.add(GenelEnum(no: 7, adi: "Mükerrer"));
    durumlar.add(GenelEnum(no: 8, adi: "Ulaşılamadı"));

    oncelikler.add(GenelEnum(no: 0, adi: "Düşük"));
    oncelikler.add(GenelEnum(no: 1, adi: "Orta"));
    oncelikler.add(GenelEnum(no: 2, adi: "Yüksek"));

    destekSekilleri.add(GenelEnum(no: 0, adi: "Telefon Destek"));
    destekSekilleri.add(GenelEnum(no: 1, adi: "Yerinde Destek"));

    destekCinsleri.add(GenelEnum(no: 0, adi: "Bakım Anlaşmalı"));
    destekCinsleri.add(GenelEnum(no: 1, adi: "Ücretli"));
    destekCinsleri.add(GenelEnum(no: 2, adi: "Yeni"));
    destekCinsleri.add(GenelEnum(no: 3, adi: "Aday"));
    destekCinsleri.add(GenelEnum(no: 4, adi: "Onaya Tabi"));
    destekCinsleri.add(GenelEnum(no: 5, adi: "Yazarkasa"));
    destekCinsleri.add(GenelEnum(no: 6, adi: "Tedarikçi"));
    destekCinsleri.add(GenelEnum(no: 7, adi: "Özel"));

    departmanlar.add(GenelEnum(no: 0, adi: "Tanımsız"));
    departmanlar.add(GenelEnum(no: 1, adi: "Mikro"));
    departmanlar.add(GenelEnum(no: 2, adi: "Yazılım"));
    departmanlar.add(GenelEnum(no: 3, adi: "Donanım"));
    departmanlar.add(GenelEnum(no: 4, adi: "Muhasebe"));
    departmanlar.add(GenelEnum(no: 5, adi: "Yazarkasa"));
    departmanlar.add(GenelEnum(no: 6, adi: "Satış"));
    departmanlar.add(GenelEnum(no: 7, adi: "Teklif"));
    departmanlar.add(GenelEnum(no: 8, adi: "Planlama"));
  }

  @override
  void initState() {
    onLoad();
    if (widget.talepNo != null) txttalepno.text = widget.talepNo.toString();
    talepDoldur();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Talep Kartı"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              FormTextAramasiz(
                txtkod: txttalepno,
                labelicerik: "Talep No",
                onKeyDown: talepDoldur,
                readonly: true,
                isPassword: false,
              ),
              FormTextAramasiz(
                isPassword: false,
                labelicerik: "Açılış Zamanı",
                readonly: true,
                txtkod: txtAcilisZamani,
              ),
              FormCombobox(
                datasource: durumlar,
                labelicerik: "Durumu",
                readonly: false,
                selectedValue: durumu,
                setGenelEnum: (GenelEnum ge) {
                  setState(() {
                    durumu = ge;
                  });
                },
              ),
              FormCombobox(
                datasource: oncelikler,
                labelicerik: "Öncelik",
                readonly: false,
                selectedValue: oncelik,
                setGenelEnum: (GenelEnum ge) {
                  setState(() {
                    oncelik = ge;
                  });
                },
              ),
              FormCombobox(
                datasource: destekSekilleri,
                labelicerik: "Destek Şekli",
                readonly: false,
                selectedValue: destekSekli,
                setGenelEnum: (GenelEnum ge) {
                  setState(() {
                    destekSekli = ge;
                  });
                },
              ),
              FormCombobox(
                datasource: destekCinsleri,
                labelicerik: "Destek Cinsi",
                readonly: false,
                selectedValue: destekCinsi,
                setGenelEnum: (GenelEnum ge) {
                  setState(() {
                    destekCinsi = ge;
                  });
                },
              ),
              FormCombobox(
                datasource: departmanlar,
                labelicerik: "Departman",
                readonly: false,
                selectedValue: departman,
                setGenelEnum: (GenelEnum ge) {
                  setState(() {
                    departman = ge;
                  });
                },
              ),
              FormTextAramasiz(
                isPassword: false,
                labelicerik: "Sahibi",
                readonly: true,
                txtkod: txtSahibi,
              ),
              FormTextAramali(
                buttonVisible: true,
                labelicerik: "İlgili Kişi",
                onPressedAra: ilgiliAra,
                readOnly: true,
                txtkod: txtIlgili,
              ),
              FormTextAramali(
                buttonVisible: true,
                labelicerik: "Müşteri Kodu",
                onKeyDown: musteriGetir,
                onPressedAra: musteriKoduAra,
                readOnly: false,
                txtkod: txtMusteriKodu,
              ),
              FormTextAramali(
                buttonVisible: true,
                labelicerik: "Müşteri Adı",
                onPressedAra: musteriAdiAra,
                readOnly: false,
                txtkod: txtMusteriAdi,
              ),
              FormTextAramali(
                buttonVisible: true,
                labelicerik: "Yetkili",
                onPressedAra: yetkiliAra,
                readOnly: true,
                txtkod: txtYetkili,
              ),
              FormTextAramasiz(
                isPassword: false,
                labelicerik: "E Posta Adr",
                readonly: false,
                txtkod: txtEPosta,
              ),
              FormTextAramasiz(
                isPassword: false,
                labelicerik: "Cep Tel",
                readonly: false,
                txtkod: txtCepTel,
              ),
              HtmlEditor(value: mesaj),
            ],
          ),
        ),
      ),
      onWillPop: () => Mesajlar().backPressed(context),
    );
  }
}
