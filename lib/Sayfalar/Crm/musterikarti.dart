import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/formCiftButton.dart';
import 'package:prosis_mobile/Genel/formcombobox.dart';
import 'package:prosis_mobile/Genel/formtarih.dart';
import 'package:prosis_mobile/Genel/formteksayisal.dart';
import 'package:prosis_mobile/Genel/formtextaramali.dart';
import 'package:prosis_mobile/Genel/formtextaramasiz.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:intl/intl.dart' as intl;

import '../../main.dart';

class PageCrmMusteriKarti extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageCrmMusteriKartiState();
  }
}

class PageCrmMusteriKartiState extends State<PageCrmMusteriKarti> {
  ProgressDialog pr;
  int selectedTab = 0;
  TextEditingController txtMusteriKodu = TextEditingController();
  TextEditingController txtMusteriAdi = TextEditingController();
  TextEditingController txtVergiDairesi = TextEditingController();
  TextEditingController txtVergiNo = TextEditingController();
  List<GenelEnum> musteriTipleri = [];
  GenelEnum musteriTipi;
  TextEditingController dtAnlasmaBitisTarihi = TextEditingController();
  DateTime anlasmaBitisTarihi;
  List<GenelEnum> evetHayir = [];
  GenelEnum eFatura;
  TextEditingController dtEFaturaTarihi = TextEditingController();
  DateTime eFaturaTarihi;
  GenelEnum eArsiv;
  TextEditingController dtEArsivTarihi = TextEditingController();
  DateTime eArsivTarihi;
  GenelEnum eIrsaliye;
  TextEditingController dtEIrsaliyeTarihi = TextEditingController();
  DateTime eIrsaliyeTarihi;
  GenelEnum eDefter;
  TextEditingController dtEDefterTarihi = TextEditingController();
  DateTime eDefterTarihi;
  TextEditingController dtMikroArsivTarihi = TextEditingController();
  DateTime mikroArsivTarihi;
  TextEditingController dtAsistanBitisTarihi = TextEditingController();
  DateTime asistanBitisTarihi;
  TextEditingController txtBilgisayarSayisi = TextEditingController();
  List<GenelEnum> mikroVersiyonlar = [];
  GenelEnum mikroVersiyon;
  List<GenelEnum> mikroProgramlar = [];
  GenelEnum mikroProgram;
  GenelEnum mikroMusterisi;
  GenelEnum yazarkasaMusterisi;
  GenelEnum ozelYazilimMusterisi;
  TextEditingController txtAdresi = TextEditingController();
  TextEditingController txtIl = TextEditingController();
  TextEditingController txtIlce = TextEditingController();
  TextEditingController txtCepTelefonu = TextEditingController();
  TextEditingController txtSabitTel = TextEditingController();
  TextEditingController txtOzelNot = TextEditingController();

  TextEditingController txtYetkiliAdiSoyadi = TextEditingController();
  TextEditingController txtYetkiliUnvani = TextEditingController();
  TextEditingController txtYetkiliTelefonu = TextEditingController();
  TextEditingController txtYetkiliMailAdresi = TextEditingController();
  TextEditingController txtYetkiliSubesi = TextEditingController();

  TextEditingController txtSubeAdi = TextEditingController();
  TextEditingController txtSubeAdresi = TextEditingController();
  TextEditingController txtSubeTelefonu = TextEditingController();
  TextEditingController txtSubeIpAdresi = TextEditingController();
  TextEditingController txtSubeKullaniciAdi = TextEditingController();
  TextEditingController txtSubeSifre = TextEditingController();
  TextEditingController txtSubeWifiSifresi = TextEditingController();
  TextEditingController txtSubeModemSifresi = TextEditingController();

  List<GenelEnum> programTipleri = [];
  GenelEnum programTipi;
  TextEditingController txtProgramIpAdresi = TextEditingController();
  TextEditingController txtProgramKullaniciAdi = TextEditingController();
  TextEditingController txtProgramSifre = TextEditingController();

  TextEditingController txtLisansProgramAdi = TextEditingController();
  TextEditingController txtLisansProgramSifre = TextEditingController();
  TextEditingController txtLisansKullaniciSayisi = TextEditingController();
  TextEditingController dtLisansBaslangicTarihi = TextEditingController();
  DateTime lisansBaslangicTarihi;
  TextEditingController dtLisansBitisTarihi = TextEditingController();
  DateTime lisansBitisTarihi;

  TextEditingController txtDigerSrvSifresi = TextEditingController();
  TextEditingController txtDigerSaSifresi = TextEditingController();
  TextEditingController txtDigerSqlKullaniciAdi = TextEditingController();
  TextEditingController txtDigerSqlSifresi = TextEditingController();
  TextEditingController txtDigerEFaturaPortalMaili = TextEditingController();
  TextEditingController txtDigerEFaturaPortalSifresi = TextEditingController();
  GenelEnum digerYedeklemeHizmeti;
  TextEditingController txtDigerYedeklemeImajSifresi = TextEditingController();
  TextEditingController txtDigerCobianBackupSifresi = TextEditingController();
  TextEditingController txtDigerNasIpAdresi = TextEditingController();
  List<GenelEnum> nasDiskBoyutlari = [];
  GenelEnum digerNasDiskBoyutu;
  TextEditingController txtDigerNasKullaniciAdi = TextEditingController();
  TextEditingController txtDigerNasSifresi = TextEditingController();

  void musteriGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> prm = {
      "musterikodu": txtMusteriKodu.text,
      "musteriunvani": txtMusteriAdi.text
    };
    parametreler.add(jsonEncode(prm));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apimusterikarti/MusteriKodBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtMusteriKodu.text = gelen["MusteriKodu"];
      txtMusteriAdi.text = gelen["MusteriUnvani"];
      txtVergiDairesi.text = gelen["VergiDairesi"];
      txtVergiNo.text = gelen["VergiNumarasi"];
      if (musteriTipleri
              .where((element) => element.no == gelen["MusteriTipi"])
              .length >
          0)
        musteriTipi = musteriTipleri
            .where((element) => element.no == gelen["MusteriTipi"])
            .first;
      else
        musteriTipi = null;
      anlasmaBitisTarihi = DateTime.parse(gelen["AnlasmaBitisTarihi"]);
      if (anlasmaBitisTarihi == DateTime(1899, 12, 30))
        anlasmaBitisTarihi = null;
      if (anlasmaBitisTarihi != null)
        dtAnlasmaBitisTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(anlasmaBitisTarihi);
      else
        dtAnlasmaBitisTarihi.text = "";
      if (evetHayir
              .where((element) => element.no == gelen["EIrsaliyeMi"])
              .length >
          0)
        eIrsaliye = evetHayir
            .where((element) => element.no == gelen["EIrsaliyeMi"])
            .first;
      else
        eIrsaliye = null;
      eIrsaliyeTarihi = DateTime.parse(gelen["EIrsGecisTarihi"]);
      if (eIrsaliyeTarihi == DateTime(1899, 12, 30)) eIrsaliyeTarihi = null;
      if (eIrsaliyeTarihi != null)
        dtEIrsaliyeTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(eIrsaliyeTarihi);
      else
        dtEIrsaliyeTarihi.text = "";
      if (evetHayir.where((element) => element.no == gelen["EArsivMi"]).length >
          0)
        eArsiv =
            evetHayir.firstWhere((element) => element.no == gelen["EArsivMi"]);
      else
        eArsiv = null;
      eArsivTarihi = DateTime.parse(gelen["EArsGecisTarihi"]);
      if (eArsivTarihi == DateTime(1899, 12, 30)) eArsivTarihi = null;
      if (eArsivTarihi != null)
        dtEArsivTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(eArsivTarihi);
      else
        dtEArsivTarihi.text = "";
      if (evetHayir
              .where((element) => element.no == gelen["EFaturaMi"])
              .length >
          0)
        eFatura =
            evetHayir.firstWhere((element) => element.no == gelen["EFaturaMi"]);
      else
        eFatura = null;
      eFaturaTarihi = DateTime.parse(gelen["EFatGecisTarihi"]);
      if (eFaturaTarihi == DateTime(1899, 12, 30)) eFaturaTarihi = null;
      if (eFaturaTarihi != null)
        dtEFaturaTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(eFaturaTarihi);
      else
        dtEFaturaTarihi.text = "";
      if (evetHayir
              .where((element) => element.no == gelen["EDefterMi"])
              .length >
          0)
        eDefter =
            evetHayir.firstWhere((element) => element.no == gelen["EDefterMi"]);
      else
        eDefter = null;
      eDefterTarihi = DateTime.parse(gelen["EDefGecisTarihi"]);
      if (eDefterTarihi == DateTime(1899, 12, 30)) eDefterTarihi = null;
      if (eDefterTarihi != null)
        dtEDefterTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(eDefterTarihi);
      dtEDefterTarihi.text = "";
      txtAdresi.text = gelen["Adresi"];
      txtIlce.text = gelen["Ilce"];
      txtIl.text = gelen["Il"];
      txtCepTelefonu.text = gelen["CepTelefonu"];
      txtSabitTel.text = gelen["SabitTelefon"];
      mikroArsivTarihi = DateTime.parse(gelen["ArsivTarihi"]);
      if (mikroArsivTarihi == DateTime(1899, 12, 30)) mikroArsivTarihi = null;
      if (mikroArsivTarihi != null)
        dtMikroArsivTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(mikroArsivTarihi);
      else
        dtMikroArsivTarihi.text = "";
      asistanBitisTarihi = DateTime.parse(gelen["AsistanBitisTarihi"]);
      if (asistanBitisTarihi == DateTime(1899, 12, 30))
        asistanBitisTarihi = null;
      if (asistanBitisTarihi != null)
        dtAsistanBitisTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(asistanBitisTarihi);
      else
        dtAsistanBitisTarihi.text = "";
      if (mikroVersiyonlar
              .where(
                  (element) => element.no.toString() == gelen["MikroVersiyon"])
              .length >
          0)
        mikroVersiyon = mikroVersiyonlar.firstWhere(
            (element) => element.no.toString() == gelen["MikroVersiyon"]);
      else
        mikroVersiyon = null;
      if (mikroProgramlar
              .where((element) => element.adi == gelen["MikroProgram"])
              .length >
          0)
        mikroProgram = mikroProgramlar
            .firstWhere((element) => element.adi == gelen["MikroProgram"]);
      else
        mikroProgram = null;
      if (evetHayir.where((element) => element.no == gelen["MikroMus"]).length >
          0)
        mikroMusterisi =
            evetHayir.firstWhere((element) => element.no == gelen["MikroMus"]);
      else
        mikroMusterisi = null;
      if (evetHayir
              .where((element) => element.no == gelen["YazarkasaMus"])
              .length >
          0)
        yazarkasaMusterisi = evetHayir
            .firstWhere((element) => element.no == gelen["YazarkasaMus"]);
      else
        yazarkasaMusterisi = null;
      if (evetHayir
              .where((element) => element.no == gelen["OzelYazilimMus"])
              .length >
          0)
        ozelYazilimMusterisi = evetHayir
            .firstWhere((element) => element.no == gelen["OzelYazilimMus"]);
      else
        ozelYazilimMusterisi = null;
      txtBilgisayarSayisi.text = gelen["PcKullaniciSayisi"].toString();
      txtOzelNot.text = gelen["OzelNot"];

      txtDigerSrvSifresi.text = gelen["SrvSifresi"];
      txtDigerSaSifresi.text = gelen["SqlSaSifresi"];
      txtDigerSqlKullaniciAdi.text = gelen["SqlKullaniciAdi"];
      txtDigerSqlSifresi.text = gelen["SqlSifre"];
      txtDigerEFaturaPortalMaili.text = gelen["EFatPortalMail"];
      if (evetHayir
              .where((element) => element.no == gelen["YedeklemeHizmeti"])
              .length >
          0)
        digerYedeklemeHizmeti = evetHayir
            .firstWhere((element) => element.no == gelen["YedeklemeHizmeti"]);
      else
        digerYedeklemeHizmeti = null;
      txtDigerYedeklemeImajSifresi.text = gelen["YedekImajSifre"];
      txtDigerCobianBackupSifresi.text = gelen["CobianSifre"];
      txtDigerNasIpAdresi.text = gelen["NasIpAdresi"];
      if (nasDiskBoyutlari
              .where((element) => element.no == gelen["NasDiskBoyutu"])
              .length >
          0)
        digerNasDiskBoyutu = nasDiskBoyutlari
            .firstWhere((element) => element.no == gelen["NasDiskBoyutu"]);
      else
        digerNasDiskBoyutu = null;
      txtDigerNasKullaniciAdi.text = gelen["NasKadi"];
      txtDigerNasSifresi.text = gelen["NasSifre"];
    }
    setState(() {});
  }

  void musteriKoduAraAra() {
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
      url = MyApp.apiUrl + "apimusterikarti/MusteriKodAra";
      parametreler.add(txtMusteriKodu.text);
    } else {
      url = MyApp.apiUrl + "apimusterikarti/MusteriUnvanAra";
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

  void yetkiliAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtMusteriKodu.text);

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/YetkiliAra", context);
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
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtYetkiliAdiSoyadi.text = e["yetkiliadisoyadi"];
                        setState(() {});
                        Navigator.of(context).pop();
                        yetkiliGetir();
                      },
                      cells: [
                        DataCell(
                          Text(e["yetkiliadisoyadi"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void yetkiliGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> prm = {
      "musterikodu": txtMusteriKodu.text,
      "yetkiliadisoyadi": txtYetkiliAdiSoyadi.text
    };
    parametreler.add(jsonEncode(prm));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apimusterikarti/YetkiliBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtYetkiliAdiSoyadi.text = gelen["YetAdiSoyadi"];
      txtYetkiliUnvani.text = gelen["YetUnvan"];
      txtYetkiliTelefonu.text = gelen["YetTel"];
      txtYetkiliMailAdresi.text = gelen["YetMail"];
      txtYetkiliSubesi.text = gelen["YetSube"];
    }
    setState(() {});
  }

  void yeniYetkili() {
    txtYetkiliAdiSoyadi.text = "";
    txtYetkiliUnvani.text = "";
    txtYetkiliTelefonu.text = "";
    txtYetkiliMailAdresi.text = "";
    txtYetkiliSubesi.text = "";
    setState(() {});
  }

  void yetkiliKaydet() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> musteribilgileri = {
      "txtMusteriKodu": txtMusteriKodu.text,
      "txtYetAdiSoyadi": txtYetkiliAdiSoyadi.text,
      "txtYetUnvan": txtYetkiliUnvani.text,
      "txtYetTel": txtYetkiliTelefonu.text,
      "txtYetMail": txtYetkiliMailAdresi.text,
      "txtYetSube": txtYetkiliSubesi.text,
    };

    parametreler.add(jsonEncode(musteribilgileri));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/YetKaydet", context);
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
    if (sn.basarili) {
      Mesajlar().toastMesaj("Yetkili Kaydedildi");
      yeniYetkili();
      setState(() {});
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  void subeAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtMusteriKodu.text);

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/SubeAra", context);
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
        "Şube Listesi",
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Adı")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtSubeAdi.text = e["subeadi"];
                        setState(() {});
                        Navigator.of(context).pop();
                        subeGetir();
                      },
                      cells: [
                        DataCell(
                          Text(e["subeadi"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void subeGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> prm = {
      "musterikodu": txtMusteriKodu.text,
      "subeadi": txtSubeAdi.text
    };
    parametreler.add(jsonEncode(prm));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/SubeBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtSubeAdi.text = gelen["SubAdi"];
      txtSubeAdresi.text = gelen["SubAdresi"];
      txtSubeTelefonu.text = gelen["SubTelefon"];
      txtSubeIpAdresi.text = gelen["SubIpAdresi"];
      txtSubeKullaniciAdi.text = gelen["SubKulAdi"];
      txtSubeSifre.text = gelen["SubSifre"];
      txtSubeModemSifresi.text = gelen["SubModemSifre"];
      txtSubeWifiSifresi.text = gelen["SubWifiSifre"];
    }
    setState(() {});
  }

  void yeniSube() {
    txtSubeAdi.text = "";
    txtSubeAdresi.text = "";
    txtSubeTelefonu.text = "";
    txtSubeIpAdresi.text = "";
    txtSubeKullaniciAdi.text = "";
    txtSubeSifre.text = "";
    txtSubeModemSifresi.text = "";
    txtSubeWifiSifresi.text = "";
    setState(() {});
  }

  void subeKaydet() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> musteribilgileri = {
      "txtMusteriKodu": txtMusteriKodu.text,
      "txtSubAdi": txtSubeAdi.text,
      "txtSubAdresi": txtSubeAdresi.text,
      "txtSubTelefon": txtSubeTelefonu.text,
      "txtSubIpAdresi": txtSubeIpAdresi.text,
      "txtSubKulAdi": txtSubeKullaniciAdi.text,
      "txtSubSifre": txtSubeSifre.text,
      "txtSubWifiSifre": txtSubeWifiSifresi.text,
      "txtSubModemSifre": txtSubeModemSifresi.text,
    };

    parametreler.add(jsonEncode(musteribilgileri));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/SubKaydet", context);
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
    if (sn.basarili) {
      Mesajlar().toastMesaj("Şube Kaydedildi");
      yeniSube();
      setState(() {});
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  void programAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtMusteriKodu.text);

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/AgprogramAra", context);
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
        "Program Listesi",
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Adı")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtProgramIpAdresi.text = e["agprogramip"];
                        setState(() {});
                        Navigator.of(context).pop();
                        programGetir();
                      },
                      cells: [
                        DataCell(
                          Text(e["agprogramip"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void programGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> prm = {
      "musterikodu": txtMusteriKodu.text,
      "agprogramip": txtProgramIpAdresi.text
    };
    parametreler.add(jsonEncode(prm));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apimusterikarti/AgprogramBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      if (programTipleri
              .where((element) => element.no == gelen["ProgTipi"])
              .length >
          0)
        programTipi = programTipleri
            .firstWhere((element) => element.no == gelen["ProgTipi"]);
      else
        programTipi = null;
      txtProgramIpAdresi.text = gelen["ProgIpAdresi"];
      txtProgramKullaniciAdi.text = gelen["ProgKulAdi"];
      txtProgramSifre.text = gelen["ProgSifre"];
    }
    setState(() {});
  }

  void yeniProgram() {
    programTipi = null;
    txtProgramIpAdresi.text = "";
    txtProgramKullaniciAdi.text = "";
    txtProgramSifre.text = "";
    setState(() {});
  }

  void programKaydet() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> musteribilgileri = {
      "txtMusteriKodu": txtMusteriKodu.text,
      "cbxProgTipi": programTipi == null ? -1 : programTipi,
      "txtProgIpAdresi": txtProgramIpAdresi.text,
      "txtProgKulAdi": txtProgramKullaniciAdi.text,
      "txtProgSifre": txtProgramSifre.text,
    };

    parametreler.add(jsonEncode(musteribilgileri));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apimusterikarti/AgprogramKaydet", context);
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
    if (sn.basarili) {
      Mesajlar().toastMesaj("Program Kaydedildi");
      yeniProgram();
      setState(() {});
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  void lisansProgramAra() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(txtMusteriKodu.text);

    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/LisansAra", context);
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
        "Lisans Listesi",
        DataTable(
          showCheckboxColumn: false,
          dataRowHeight: 35.0,
          columnSpacing: 10,
          columns: [
            DataColumn(label: Text("Adı")),
          ],
          rows: f10data
              .map((e) => DataRow(
                      onSelectChanged: (b) {
                        txtLisansProgramAdi.text = e["lisansadi"];
                        setState(() {});
                        Navigator.of(context).pop();
                        lisansProgramGetir();
                      },
                      cells: [
                        DataCell(
                          Text(e["lisansadi"]),
                        ),
                      ]))
              .toList(),
        ));
  }

  void lisansProgramGetir() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> prm = {
      "musterikodu": txtMusteriKodu.text,
      "lisansadi": txtLisansProgramAdi.text
    };
    parametreler.add(jsonEncode(prm));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apimusterikarti/LisansBilgileri", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      txtLisansProgramAdi.text = gelen["LisProgAdi"];
      txtLisansProgramSifre.text = gelen["LisSifre"];
      txtLisansKullaniciSayisi.text = gelen["LisKulSayisi"];
      lisansBaslangicTarihi = DateTime.parse(gelen["LisAlimTarih"]);
      if (lisansBaslangicTarihi == DateTime(1899, 12, 30))
        lisansBaslangicTarihi = null;
      if (lisansBaslangicTarihi != null)
        dtLisansBaslangicTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(lisansBitisTarihi);
      else
        dtLisansBaslangicTarihi.text = "";
      lisansBitisTarihi = DateTime.parse(gelen["LisBitTarih"]);
      if (lisansBitisTarihi == DateTime(1899, 12, 30)) lisansBitisTarihi = null;
      if (lisansBitisTarihi != null)
        dtLisansBitisTarihi.text =
            intl.DateFormat("dd.MM.yyyy").format(lisansBitisTarihi);
      else
        dtLisansBitisTarihi.text = "";
    }
    setState(() {});
  }

  void yeniLisansProgram() {
    txtLisansProgramAdi.text = "";
    txtLisansProgramSifre.text = "";
    txtLisansKullaniciSayisi.text = "";
    lisansBaslangicTarihi = null;
    dtLisansBaslangicTarihi.text = "";
    dtLisansBitisTarihi.text = "";
    lisansBitisTarihi = null;

    setState(() {});
  }

  void lisansProgramKaydet() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> musteribilgileri = {
      "txtMusteriKodu": txtMusteriKodu.text,
      "txtLisProgAdi": txtLisansProgramAdi.text,
      "txtLisSifre": txtLisansProgramSifre.text,
      "txtLisKulSayisi":
          BasariUtilities().tamsayi(txtLisansKullaniciSayisi.text),
      "dteLisAlimTarih": BasariUtilities().getdate(lisansBaslangicTarihi),
      "dteLisBitTarih": BasariUtilities().getdate(lisansBitisTarihi),
    };

    parametreler.add(jsonEncode(musteribilgileri));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/LisKaydet", context);
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
    if (sn.basarili) {
      Mesajlar().toastMesaj("Lisans Kaydedildi");
      yeniLisansProgram();
      setState(() {});
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  void yeni() {
    txtMusteriKodu.text = "";
    txtMusteriAdi.text = "";
    txtVergiDairesi.text = "";
    txtVergiNo.text = "";
    musteriTipi = null;
    anlasmaBitisTarihi = null;
    dtAnlasmaBitisTarihi.text = "";
    eIrsaliye = null;
    eIrsaliyeTarihi = null;
    dtEIrsaliyeTarihi.text = "";
    eArsiv = null;
    eArsivTarihi = null;
    dtEArsivTarihi.text = "";
    eFatura = null;
    eFaturaTarihi = null;
    dtEFaturaTarihi.text = "";
    eDefter = null;
    eDefterTarihi = null;
    dtEDefterTarihi.text = "";

    txtAdresi.text = "";
    txtIlce.text = "";
    txtIl.text = "";
    txtCepTelefonu.text = "";
    txtSabitTel.text = "";
    mikroArsivTarihi = null;
    dtMikroArsivTarihi.text = "";
    asistanBitisTarihi = null;
    dtMikroArsivTarihi.text = "";
    mikroVersiyon = null;
    mikroProgram = null;
    mikroMusterisi = null;
    yazarkasaMusterisi = null;
    ozelYazilimMusterisi = null;
    txtBilgisayarSayisi.text = "";
    txtOzelNot.text = "";

    txtDigerSrvSifresi.text = "";
    txtDigerSaSifresi.text = "";
    txtDigerSqlKullaniciAdi.text = "";
    txtDigerSqlSifresi.text = "";
    txtDigerEFaturaPortalMaili.text = "";
    digerYedeklemeHizmeti = null;
    txtDigerYedeklemeImajSifresi.text = "";
    txtDigerCobianBackupSifresi.text = "";
    txtDigerNasIpAdresi.text = "";
    digerNasDiskBoyutu = null;
    txtDigerNasKullaniciAdi.text = "";
    txtDigerNasSifresi.text = "";
    setState(() {});
  }

  void kaydet() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    Map<String, dynamic> musteribilgileri = {
      "txtMusteriKodu": txtMusteriKodu.text,
      "txtMusteriUnvan": txtMusteriAdi.text,
      "txtVDaire": txtVergiDairesi.text,
      "txtVNo": txtVergiNo.text,
      "cbxMusteriTipi": musteriTipi == null ? -1 : musteriTipi.no,
      "dteAnlasmaTarih":
          BasariUtilities().getdate(anlasmaBitisTarihi).toIso8601String(),
      "cbxEIrsaliyeMi": eIrsaliye == null ? -1 : eIrsaliye.no,
      "dteEIrsaliyeTarih":
          BasariUtilities().getdate(eIrsaliyeTarihi).toIso8601String(),
      "cbxEArsivMi": eArsiv == null ? -1 : eArsiv.no,
      "dteEArsivTarih":
          BasariUtilities().getdate(eArsivTarihi).toIso8601String(),
      "cbxEFaturaMi": eFatura == null ? -1 : eFatura.no,
      "dteEFaturaTarih":
          BasariUtilities().getdate(eFaturaTarihi).toIso8601String(),
      "cbxEDefterMi": eDefter == null ? -1 : eDefter.no,
      "dteEDefterTarih":
          BasariUtilities().getdate(eDefterTarihi).toIso8601String(),
      "txtAdres": txtAdresi.text,
      "txtIlce": txtIlce.text,
      "txtIl": txtIl.text,
      "txtCepTel": txtCepTelefonu.text,
      "txtSabitTel": txtSabitTel.text,
      "dteArsivTarih":
          BasariUtilities().getdate(eArsivTarihi).toIso8601String(),
      "dteAsistanBitisTarih":
          BasariUtilities().getdate(asistanBitisTarihi).toIso8601String(),
      "cbxMikroVersiyon": mikroVersiyon == null ? -1 : mikroVersiyon.no,
      "cbxMikroProgram": mikroProgram == null ? -1 : mikroProgram.adi,
      "cbxMikroMus": mikroMusterisi == null ? -1 : mikroMusterisi.no,
      "cbxYazarkasaMus":
          yazarkasaMusterisi == null ? -1 : yazarkasaMusterisi.no,
      "cbxOzelYazilimMus":
          ozelYazilimMusterisi == null ? -1 : ozelYazilimMusterisi.no,
      "txtBilgisayarSayisi":
          BasariUtilities().tamsayi(txtBilgisayarSayisi.text),
      "txtOzelNot": txtOzelNot.text,
      "txtSrvSifresi": txtDigerSrvSifresi.text,
      "txtSaSifresi": txtDigerSaSifresi.text,
      "txtSqlKadi": txtDigerSqlKullaniciAdi.text,
      "txtSqlSifre": txtDigerSqlSifresi.text,
      "txtPortalMail": txtDigerEFaturaPortalMaili.text,
      "txtPortalSifre": txtDigerEFaturaPortalSifresi.text,
      "cbxYedeklemeHizmeti":
          digerYedeklemeHizmeti == null ? -1 : digerYedeklemeHizmeti.no,
      "txtImajSifre": txtDigerYedeklemeImajSifresi.text,
      "txtCobianSifre": txtDigerCobianBackupSifresi.text,
      "txtNasIpAdresi": txtDigerNasIpAdresi.text,
      "cbxNasDiskBoyutu":
          digerNasDiskBoyutu == null ? -1 : digerNasDiskBoyutu.no,
      "txtNasKadi": txtDigerNasKullaniciAdi.text,
      "txtNasSifre": txtDigerNasSifresi.text,
    };

    parametreler.add(jsonEncode(musteribilgileri));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apimusterikarti/Kaydet", context);
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
    if (sn.basarili) {
      Mesajlar().toastMesaj("Kaydedildi");
      yeni();
      setState(() {});
    } else {
      Mesajlar().tamam(context, Text(sn.sonuc), Text("Uyarı"));
    }
    setState(() {});
  }

  onLoad() {
    evetHayir.add(GenelEnum(no: 0, adi: "Hayır"));
    evetHayir.add(GenelEnum(no: 1, adi: "Evet"));

    programTipleri.add(GenelEnum(no: 0, adi: "Modem"));
    programTipleri.add(GenelEnum(no: 1, adi: "Access Point"));
    programTipleri.add(GenelEnum(no: 2, adi: "Switch"));
    programTipleri.add(GenelEnum(no: 3, adi: "Firewall"));
    programTipleri.add(GenelEnum(no: 4, adi: "Eset"));
    programTipleri.add(GenelEnum(no: 5, adi: "Shadow"));
    programTipleri.add(GenelEnum(no: 6, adi: "Image Manager"));

    nasDiskBoyutlari.add(GenelEnum(no: 0, adi: "Yok"));
    nasDiskBoyutlari.add(GenelEnum(no: 1, adi: "Raid 0"));
    nasDiskBoyutlari.add(GenelEnum(no: 2, adi: "Raid 1"));
    nasDiskBoyutlari.add(GenelEnum(no: 3, adi: "Raid 5"));

    musteriTipleri.add(GenelEnum(no: 0, adi: "Bakım Anlaşmalı"));
    musteriTipleri.add(GenelEnum(no: 1, adi: "Ücretli"));
    musteriTipleri.add(GenelEnum(no: 2, adi: "Yeni"));
    musteriTipleri.add(GenelEnum(no: 3, adi: "Aday"));

    mikroVersiyonlar.add(GenelEnum(no: 12, adi: "V12"));
    mikroVersiyonlar.add(GenelEnum(no: 14, adi: "V14"));
    mikroVersiyonlar.add(GenelEnum(no: 15, adi: "V15"));
    mikroVersiyonlar.add(GenelEnum(no: 16, adi: "V16"));

    mikroProgramlar.add(GenelEnum(no: 0, adi: "Ofis"));
    mikroProgramlar.add(GenelEnum(no: 1, adi: "Ekonomik"));
    mikroProgramlar.add(GenelEnum(no: 2, adi: "Standart"));
    mikroProgramlar.add(GenelEnum(no: 3, adi: "Enerji"));
    mikroProgramlar.add(GenelEnum(no: 4, adi: "Seri9000"));
    mikroProgramlar.add(GenelEnum(no: 5, adi: "Rtl9000"));
    mikroProgramlar.add(GenelEnum(no: 6, adi: "Jump"));
    mikroProgramlar.add(GenelEnum(no: 7, adi: "Fly"));
  }

  @override
  void initState() {
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
    onLoad();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
          initialIndex: selectedTab,
          length: 6,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Müşteri Kartı"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Müşteri Bilgileri"),
                  Tab(text: "Diğer Şifreler"),
                  Tab(text: "Yetkililer"),
                  Tab(text: "Şubeler"),
                  Tab(text: "Ağ ve Programlar"),
                  Tab(text: "Lisanslar"),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              height: 56,
              margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        color: Colors.green,
                        child: GestureDetector(
                          onTap: yeni,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.open_in_new, color: Colors.white),
                              Text("Yeni",
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.green,
                      child: GestureDetector(
                          onTap: kaydet,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.save, color: Colors.white),
                              Text("Kaydet",
                                  style: TextStyle(color: Colors.white))
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                //////////////////// Müşteri Bilgileri//////////////
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        FormTextAramali(
                          buttonVisible: true,
                          labelicerik: "Müşteri Kodu",
                          onKeyDown: musteriGetir,
                          onPressedAra: musteriKoduAraAra,
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
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Vergi Dairesi",
                          readonly: false,
                          txtkod: txtVergiDairesi,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Vergi No",
                          readonly: false,
                          txtkod: txtVergiNo,
                        ),
                        FormCombobox(
                          datasource: musteriTipleri,
                          labelicerik: "Müşteri Tipi",
                          readonly: false,
                          selectedValue: musteriTipi,
                          setGenelEnum: (vl) {
                            setState(() {
                              musteriTipi = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtAnlasmaBitisTarihi,
                          labelicerik: "Anlaşma Bitiş",
                          readonlytarih: false,
                          tarih: anlasmaBitisTarihi,
                          setTarih: (vl) {
                            setState(() {
                              anlasmaBitisTarihi = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "E Fatura",
                          readonly: false,
                          selectedValue: eFatura,
                          setGenelEnum: (vl) {
                            setState(() {
                              eFatura = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtEFaturaTarihi,
                          labelicerik: "E Fatura Tarihi",
                          readonlytarih: false,
                          tarih: eFaturaTarihi,
                          setTarih: (vl) {
                            setState(() {
                              eFaturaTarihi = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "E Arşiv",
                          readonly: false,
                          selectedValue: eArsiv,
                          setGenelEnum: (vl) {
                            setState(() {
                              eArsiv = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtEArsivTarihi,
                          labelicerik: "E Arşiv Tarihi",
                          readonlytarih: false,
                          tarih: eArsivTarihi,
                          setTarih: (vl) {
                            setState(() {
                              eArsivTarihi = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "E İrsaliye",
                          readonly: false,
                          selectedValue: eIrsaliye,
                          setGenelEnum: (vl) {
                            setState(() {
                              eIrsaliye = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtEIrsaliyeTarihi,
                          labelicerik: "E İrsaliye Tarihi",
                          readonlytarih: false,
                          tarih: eIrsaliyeTarihi,
                          setTarih: (vl) {
                            setState(() {
                              eIrsaliyeTarihi = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "E Defter",
                          readonly: false,
                          selectedValue: eDefter,
                          setGenelEnum: (vl) {
                            setState(() {
                              eDefter = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtEDefterTarihi,
                          labelicerik: "E Defter Tarihi",
                          readonlytarih: false,
                          tarih: eDefterTarihi,
                          setTarih: (vl) {
                            setState(() {
                              eDefterTarihi = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtMikroArsivTarihi,
                          labelicerik: "Mikro Arşiv Tarihi",
                          readonlytarih: false,
                          tarih: mikroArsivTarihi,
                          setTarih: (vl) {
                            setState(() {
                              mikroArsivTarihi = vl;
                            });
                          },
                        ),
                        FormTarih(
                          dttarih: dtAsistanBitisTarihi,
                          labelicerik: "Asistan Bitiş Tarihi",
                          readonlytarih: false,
                          tarih: asistanBitisTarihi,
                          setTarih: (vl) {
                            setState(() {
                              asistanBitisTarihi = vl;
                            });
                          },
                        ),
                        FormTekSayisal(
                          clcdeger1: txtBilgisayarSayisi,
                          labelicerik: "Bilgisayar Sayısı",
                          readonly1: false,
                        ),
                        FormCombobox(
                          datasource: mikroVersiyonlar,
                          labelicerik: "Mikro Versiyon",
                          readonly: false,
                          selectedValue: mikroVersiyon,
                          setGenelEnum: (vl) {
                            setState(() {
                              mikroVersiyon = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: mikroProgramlar,
                          labelicerik: "Mikro Program",
                          readonly: false,
                          selectedValue: mikroProgram,
                          setGenelEnum: (vl) {
                            setState(() {
                              mikroProgram = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "Mikro Müşterisi",
                          readonly: false,
                          selectedValue: mikroMusterisi,
                          setGenelEnum: (vl) {
                            setState(() {
                              mikroMusterisi = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "Yazarkasa Müşterisi",
                          readonly: false,
                          selectedValue: yazarkasaMusterisi,
                          setGenelEnum: (vl) {
                            setState(() {
                              yazarkasaMusterisi = vl;
                            });
                          },
                        ),
                        FormCombobox(
                          datasource: evetHayir,
                          labelicerik: "Özel Yazılım Müşterisi",
                          readonly: false,
                          selectedValue: ozelYazilimMusterisi,
                          setGenelEnum: (vl) {
                            setState(() {
                              ozelYazilimMusterisi = vl;
                            });
                          },
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Adresi",
                          readonly: false,
                          txtkod: txtAdresi,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "İl",
                          readonly: false,
                          txtkod: txtIl,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "İlçe",
                          readonly: false,
                          txtkod: txtIlce,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Cep Tel",
                          readonly: false,
                          txtkod: txtCepTelefonu,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Sabit Tel",
                          readonly: false,
                          txtkod: txtSabitTel,
                        ),
                        FormTextAramasiz(
                          isPassword: false,
                          labelicerik: "Özel Not",
                          readonly: false,
                          txtkod: txtOzelNot,
                        ),
                      ],
                    )),
/////////////////////////////Diğer Şifreler //////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "SRV Şifresi",
                        readonly: false,
                        txtkod: txtDigerSrvSifresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "sa Şifresi",
                        readonly: false,
                        txtkod: txtDigerSaSifresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Sql Kullanıcı Adı",
                        readonly: false,
                        txtkod: txtDigerSqlKullaniciAdi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Sql Şifresi",
                        readonly: false,
                        txtkod: txtDigerSqlSifresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "E Fatura Portal Maili",
                        readonly: false,
                        txtkod: txtDigerEFaturaPortalMaili,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "E Fatrua Portal Şifresi",
                        readonly: false,
                        txtkod: txtDigerEFaturaPortalSifresi,
                      ),
                      FormCombobox(
                        datasource: evetHayir,
                        labelicerik: "Yedekleme Hizmeti",
                        readonly: false,
                        selectedValue: digerYedeklemeHizmeti,
                        setGenelEnum: (vl) {
                          setState(() {
                            digerYedeklemeHizmeti = vl;
                          });
                        },
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Yedekleme Imaj Şifresi",
                        readonly: false,
                        txtkod: txtDigerYedeklemeImajSifresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Cobian Backup Şifresi",
                        readonly: false,
                        txtkod: txtDigerCobianBackupSifresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "NAS IP Adresi",
                        readonly: false,
                        txtkod: txtDigerNasIpAdresi,
                      ),
                      FormCombobox(
                        datasource: nasDiskBoyutlari,
                        labelicerik: "NAS Disk Boyutu",
                        readonly: false,
                        selectedValue: digerNasDiskBoyutu,
                        setGenelEnum: (vl) {
                          setState(() {
                            digerNasDiskBoyutu = vl;
                          });
                        },
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "NAS Kullanıcı Adı",
                        readonly: false,
                        txtkod: txtDigerNasKullaniciAdi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "NAS Şifresi",
                        readonly: false,
                        txtkod: txtDigerNasSifresi,
                      ),
                    ],
                  ),
                ),
/////////////////////////////////// Yetkililer /////////////////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormCiftButton(
                        button1flex: 1,
                        button1icerik: "Yeni",
                        button1islem: yeniYetkili,
                        button1renk: Colors.blue[300],
                        button2flex: 1,
                        button2icerik: "Kaydet",
                        button2islem: yetkiliKaydet,
                        button2renk: Colors.green[300],
                      ),
                      FormTextAramali(
                        labelicerik: "Adı Soyadı",
                        txtkod: txtYetkiliAdiSoyadi,
                        onPressedAra: yetkiliAra,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Unvanı",
                        readonly: false,
                        txtkod: txtYetkiliUnvani,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Telefonu",
                        readonly: false,
                        txtkod: txtYetkiliTelefonu,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Mail Adresi",
                        readonly: false,
                        txtkod: txtYetkiliMailAdresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Şubesi",
                        readonly: false,
                        txtkod: txtYetkiliSubesi,
                      ),
                    ],
                  ),
                ),
                /////////////////////////////Şube //////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormCiftButton(
                        button1flex: 1,
                        button1icerik: "Yeni",
                        button1islem: yeniSube,
                        button1renk: Colors.blue[300],
                        button2flex: 1,
                        button2icerik: "Kaydet",
                        button2islem: subeKaydet,
                        button2renk: Colors.green[300],
                      ),
                      FormTextAramali(
                        labelicerik: "Adı",
                        txtkod: txtSubeAdi,
                        onPressedAra: subeAra,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Adresi",
                        readonly: false,
                        txtkod: txtSubeAdresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Telefonu",
                        readonly: false,
                        txtkod: txtSubeTelefonu,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "IP Adresi",
                        readonly: false,
                        txtkod: txtSubeIpAdresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Kullanıcı Adı",
                        readonly: false,
                        txtkod: txtSubeKullaniciAdi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Şifre",
                        readonly: false,
                        txtkod: txtSubeSifre,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Wifi Şifresi",
                        readonly: false,
                        txtkod: txtSubeWifiSifresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Modem Şifresi",
                        readonly: false,
                        txtkod: txtSubeModemSifresi,
                      ),
                    ],
                  ),
                ),
                /////////////////////////////Ağ ve program //////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormCiftButton(
                        button1flex: 1,
                        button1icerik: "Yeni",
                        button1islem: yeniProgram,
                        button1renk: Colors.blue[300],
                        button2flex: 1,
                        button2icerik: "Kaydet",
                        button2islem: programKaydet,
                        button2renk: Colors.green[300],
                      ),
                      FormCombobox(
                        datasource: programTipleri,
                        labelicerik: "Program Tipi",
                        readonly: false,
                        selectedValue: programTipi,
                        setGenelEnum: (vl) {
                          setState(() {
                            programTipi = vl;
                          });
                        },
                      ),
                      FormTextAramali(
                        buttonVisible: true,
                        labelicerik: "IP Adresi",
                        onPressedAra: programAra,
                        readOnly: false,
                        txtkod: txtProgramIpAdresi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Kullanıcı Adı",
                        readonly: false,
                        txtkod: txtProgramKullaniciAdi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Şifre",
                        readonly: false,
                        txtkod: txtProgramSifre,
                      ),
                    ],
                  ),
                ),
                /////////////////////////////Lisans //////////////////////////
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      FormCiftButton(
                        button1flex: 1,
                        button1icerik: "Yeni",
                        button1islem: yeniLisansProgram,
                        button1renk: Colors.blue[300],
                        button2flex: 1,
                        button2icerik: "Kaydet",
                        button2islem: lisansProgramKaydet,
                        button2renk: Colors.green[300],
                      ),
                      FormTextAramali(
                        buttonVisible: true,
                        labelicerik: "Program Adı",
                        onPressedAra: lisansProgramAra,
                        readOnly: false,
                        txtkod: txtLisansProgramAdi,
                      ),
                      FormTextAramasiz(
                        isPassword: false,
                        labelicerik: "Şifre",
                        readonly: false,
                        txtkod: txtLisansProgramSifre,
                      ),
                      FormTekSayisal(
                        labelicerik: "Kullanıcı Sayısı",
                        clcdeger1: txtLisansKullaniciSayisi,
                        readonly1: false,
                      ),
                      FormTarih(
                        dttarih: dtLisansBaslangicTarihi,
                        labelicerik: "Lisans Başlangıç",
                        readonlytarih: false,
                        setTarih: (vl) {
                          setState(() {
                            lisansBaslangicTarihi = vl;
                          });
                        },
                        tarih: lisansBaslangicTarihi,
                      ),
                      FormTarih(
                        dttarih: dtLisansBitisTarihi,
                        labelicerik: "Lisans Bitiş",
                        readonlytarih: false,
                        setTarih: (vl) {
                          setState(() {
                            lisansBitisTarihi = vl;
                          });
                        },
                        tarih: lisansBitisTarihi,
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
