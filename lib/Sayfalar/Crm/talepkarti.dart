import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formcombobox.dart';
import 'package:prosis_mobile/Genel/formtextaramali.dart';
import 'package:prosis_mobile/Genel/formtextaramasiz.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:prosis_mobile/Sayfalar/Crm/talepcevap.dart';

import '../../main.dart';

class PageTalepKarti extends StatefulWidget {
  final int talepNo;

  PageTalepKarti({
    @required this.talepNo,
  });

  @override
  State<StatefulWidget> createState() {
    return PageTalepKartiState();
  }
}

class PageTalepKartiState extends State<PageTalepKarti> {
  ProgressDialog pr;
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
  String atayadaiptalismi = "Bana Ata";
  List<String> islemler = [];

  void talepDoldur() async {
    if (BasariUtilities().tamsayi(txttalepno.text) == 0) return;

    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> talepbilgileri = {
      "talepno": BasariUtilities().tamsayi(txttalepno.text)
    };
    parametreler.add(jsonEncode(talepbilgileri));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/TalepBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtAcilisZamani.text = intl.DateFormat("dd.MM.yyyy HH:mm")
          .format(DateTime.parse(gelen["AcilisZamani"]));
      durumu = durumlar
          .where(
              (element) => element.no == int.parse(gelen["Durumu"].toString()))
          .first;
      oncelik =
          oncelikler.where((element) => element.no == gelen["Oncelik"]).first;
      destekSekli = destekSekilleri
          .where((element) => element.no == gelen["DestekSekli"])
          .first;
      destekCinsi = destekCinsleri
          .where((element) => element.no == gelen["DestekCinsi"])
          .first;
      departman = departmanlar
          .where((element) => element.no == gelen["Departmani"])
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
      islemler.clear();
      islemler.add("Yeni");
      islemler.add("Kaydet");
      if (txtSahibi.text == MyApp.oturum.kullanicikodu) {
        atayadaiptalismi = "Atama İptal";
      } else {
        atayadaiptalismi = "Bana Ata";
      }
      islemler.add(atayadaiptalismi);
      islemler.add("Cevap Ekle");
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  void ilgiliAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtIlgili.text);

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/IlgiliAra", context);
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
    Map<String, dynamic> prm = {
      "musterikodu": txtMusteriKodu.text,
      "musteriunvani": txtMusteriAdi.text
    };
    parametreler.add(jsonEncode(prm));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apitumtalepler/MusteriKodBilgileri", context);
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

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/YetkiliAra", context);
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

  void cevapEkle() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageTalepCevap(
              talepNo: BasariUtilities().tamsayi(txttalepno.text),
              mesaj: "",
              sadeceMesaj: false,
            )));
    mesaj = result;
    if (mesaj == "Cevap Eklendi") talepDoldur();
    if (mesaj == "Çözüldü") {
      Navigator.pop(context);
    }
  }

  void yeni() async {
    Future<bool> cevap = Mesajlar().yesno(
            context,
            Text("Yeni evrak açmak istediğinizden emin misiniz?"),
            Text("Uyarı"),
            "Evet",
            "Hayır") ??
        false;
    cevap.then((value) {
      if (value) {
        txttalepno.text = "";
        txtAcilisZamani.text =
            intl.DateFormat("dd.MM.yyyy HH:mm").format(DateTime.now());
        durumu = durumlar.first;
        oncelik = oncelikler.first;
        destekCinsi = destekCinsleri.first;
        departman = departmanlar.first;
        txtSahibi.text = "";
        txtIlgili.text = "";
        txtMusteriKodu.text = "";
        txtMusteriAdi.text = "";
        txtYetkili.text = "";
        txtEPosta.text = "";
        txtCepTel.text = "";
        txtSabitTel.text = "";
        txtKonu.text = "";
        mesaj = "";
        islemler.clear();
        islemler.add("Yeni");
        islemler.add("Kaydet");
        islemler.add("Mesaj Ekle");
        setState(() {});
      }
    });
  }

  void kaydet() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> talepbilgileri = {
      "TalepNo": BasariUtilities().tamsayi(txttalepno.text),
      "AcilisZamani": DateTime.now().toIso8601String(),
      "Durumu": durumu.no,
      "Oncelik": oncelik.no,
      "DestekSekli": destekSekli.no,
      "DestekCinsi": destekCinsi.no,
      "Departmani": departman.no,
      "Sahibi": txtSahibi.text,
      "Ilgili": txtIlgili.text,
      "MusKod": txtMusteriKodu.text,
      "MusUnvan": txtMusteriAdi.text,
      "Yetkili": txtYetkili.text,
      "Eposta": txtEPosta.text,
      "CepTel": txtCepTel.text,
      "SabitTel": txtSabitTel.text,
      "Konu": txtKonu.text,
      "Mesaj": mesaj
    };
    parametreler.add(jsonEncode(talepbilgileri));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/TalepKaydet", context);
    pr.hide();
    if (sn.basarili) {
      Mesajlar().toastMesaj("Talep kaydedildi");
      txttalepno.text = sn.sonuc;
      talepDoldur();
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  void atayadaIptal() async {
    if (BasariUtilities().tamsayi(txttalepno.text) == 0) {
      Mesajlar()
          .tamam(context, Text("Önce talebi kaydetmelisiniz"), Text("Uyarı"));
      return;
    }
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> talepbilgileri = {
      "TalepNo": BasariUtilities().tamsayi(txttalepno.text),
      // "AcilisZamani": DateTime.now().toIso8601String(),
      // "Durumu": durumu.no,
      // "Oncelik": oncelik.no,
      // "DestekSekli": destekSekli.no,
      // "DestekCinsi": destekCinsi.no,
      // "Departmani": departman.no,
      // "Sahibi": txtSahibi.text,
      // "Ilgili": txtIlgili.text,
      // "MusKod": txtMusteriKodu.text,
      // "MusUnvan": txtMusteriAdi.text,
      // "Yetkili": txtYetkili.text,
      // "Eposta": txtEPosta.text,
      // "CepTel": txtCepTel.text,
      // "SabitTel": txtSabitTel.text,
      // "Konu": txtKonu.text,
      // "Mesaj": mesaj
    };
    parametreler.add(jsonEncode(talepbilgileri));
    String url = "";
    if (atayadaiptalismi == "Bana Ata") {
      url = MyApp.apiUrl + "apitumtalepler/BanaAta";
    } else {
      url = MyApp.apiUrl + "apitumtalepler/AtamaIptal";
    }
    DefaultReturn sn =
        await BasariUtilities().getApiSonuc(parametreler, url, context);
    if (sn.basarili) {
      talepDoldur();
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
  }

  void mesajGoster() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageTalepCevap(
              talepNo: BasariUtilities().tamsayi(txttalepno.text),
              mesaj: mesaj,
              sadeceMesaj: true,
            )));
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

    durumu = durumlar.first;
    oncelik = oncelikler.first;
    islemler.clear();
    islemler.add("Yeni");
    islemler.add("Kaydet");
    islemler.add("Mesaj Ekle");
  }

  void islemYap(String islem) {
    if (islem == "Yeni") {
      yeni();
    } else if (islem == "Kaydet") {
      kaydet();
    } else if (islem == "Atama İptal" || islem == "Bana Ata") {
      atayadaIptal();
    } else if (islem == "Cevap Ekle") {
      cevapEkle();
    } else if (islem == "Mesaj Ekle") {
      cevapEkle();
    }
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
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
      customBody: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        backgroundColor: Colors.white,
      ),
    );
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Talep Kartı"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: mesajGoster,
                  child: Icon(
                    Icons.message,
                    size: 26.0,
                  ),
                )),
            PopupMenuButton<String>(
                onSelected: islemYap,
                itemBuilder: (BuildContext context) {
                  return islemler.map((String e) {
                    return PopupMenuItem<String>(
                      child: Text(e),
                      value: e,
                    );
                  }).toList();
                }),
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
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
                    ],
                  ),
                ),
              ],
            )),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: cevapEkle,
        //   child: Text("Cevapla"),
        //   backgroundColor: Colors.orangeAccent,
        // ),

        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.amber,
        //   child: new Row(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       FlatButton(
        //         child: Text("Yeni"),
        //         onPressed: yeni,
        //       ),
        //       FlatButton(onPressed: kaydet, child: Text("Kaydet")),
        //       FlatButton(
        //           onPressed: atayadaIptal, child: Text(atayadaiptalismi)),
        //       FlatButton(onPressed: cevapEkle, child: Text("Cevapla"))
        //     ],
        //   ),
        // ),
      ),
      onWillPop: () => Mesajlar().backPressed(context),
    );
  }
}

class TalepIslemleri {
  static const String yeni = "Yeni";
  static const String kaydet = "Kaydet";
  static const String atama = "Bana Ata";
  static const String cevapla = "Cevapla";

  static const List<String> islemler = <String>[
    yeni,
    kaydet,
    atama,
    cevapla,
  ];
}
