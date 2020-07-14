import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:prosis_mobile/Sayfalar/Crm/talepkarti.dart';

import '../../main.dart';

class PageCrmBaskasindaBekleyenler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageCrmBaskasindaBekleyenlerState();
  }
}

class PageCrmBaskasindaBekleyenlerState extends State<PageCrmBaskasindaBekleyenler> {
ProgressDialog pr;
  List<dynamic> dataList = [];

  void yenile() async {
    pr.show();
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/TumBekRaporAl", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      dataList = gelen;
    }
    pr.hide();
    setState(() {});
  }

  void talebegit(int talepno) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageTalepKarti(
              talepNo: talepno,
            )));
    yenile();
  }

  @override
  void initState() {
    yenile();
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
              title: Text("Başkasında Bekleyenler"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      talebegit(0);
                    }),
                IconButton(icon: Icon(Icons.refresh), onPressed: yenile)
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: 10,
                  columns: <DataColumn>[
                    DataColumn(label: Text("Talep No")),
                    DataColumn(label: Text("Açılış Zamanı")),
                    DataColumn(label: Text("İlgili")),
                    DataColumn(label: Text("Müşteri")),
                    DataColumn(label: Text("Yetkili")),
                    DataColumn(label: Text("Konu")),
                    DataColumn(label: Text("Departman")),
                    DataColumn(label: Text("Durumu")),
                    DataColumn(label: Text("Destek Cinsi")),
                    DataColumn(label: Text("Destek Şekli")),
                  ],
                  rows: dataList
                      .map((e) => DataRow(
                              onSelectChanged: (b) {
                                if (b) {
                                  talebegit(e["TalepNo"]);
                                }
                              },
                              cells: <DataCell>[
                                DataCell(Text("${e["TalepNo"]}")),
                                DataCell(Text("${e["Açılış Zamanı"]}")),
                                DataCell(Text("${e["_Ilgili"]}")),
                                DataCell(Text("${e["MusteriUnvani"]}")),
                                DataCell(Text("${e["YetkiliAdiSoyadi"]}")),
                                DataCell(Text("${e["Konu"]}")),
                                DataCell(Text("${e["_Departman"]}")),
                                DataCell(Text("${e["_Durumu"]}")),
                                DataCell(Text("${e["_Destek Cinsi"]}")),
                                DataCell(Text("${e["_Destek Şekli"]}"))
                              ]))
                      .toList(),
                ),
              ),
            )),
        onWillPop: () => Mesajlar().backPressed(context));
  }
}
