import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:intl/intl.dart' as intl;

import '../../main.dart';

class PageCrmPlanlama extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageCrmPlanlamaState();
  }
}

class PageCrmPlanlamaState extends State<PageCrmPlanlama> {
  ProgressDialog pr;
  int hafta = 1;
  List<dynamic> dataList = [];
  DateTime ilkTarih;
  DateTime sonTarih;
  String bulunanhafta = "";
  void raporAl() async {
    bulunanhafta = "$hafta. hafta " +
        intl.DateFormat("dd.MM.yyyy").format(ilkTarih) +
        " - " +
        intl.DateFormat("dd.MM.yyyy").format(sonTarih);
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(jsonEncode(ilkTarih.year));
    parametreler.add(jsonEncode(hafta));
    pr.show();
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/Planlama", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      //List<dynamic> gelen2 = gelen[0];

      dataList = json.decode(gelen[0]);
    }
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          print(pr.isShowing());
        });
      });
    });
  }

  void onLoad() async {
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    parametreler.add(jsonEncode(hafta));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(
        parametreler, MyApp.apiUrl + "apitumtalepler/PlanlamaonLoad", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      setState(() {
        hafta = gelen["no"];
        ilkTarih = DateTime.parse(gelen["ilktarih"]);
        sonTarih = DateTime.parse(gelen["sontarih"]);
      });
      raporAl();
    }
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planlama"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              hafta = hafta - 1;
              ilkTarih = ilkTarih.add(new Duration(days: -7));
              sonTarih = sonTarih.add(new Duration(days: -7));
              raporAl();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              hafta = hafta + 1;
              ilkTarih = ilkTarih.add(new Duration(days: 7));
              sonTarih = sonTarih.add(new Duration(days: 7));
              raporAl();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: <Widget>[
                  Text(bulunanhafta),
                  DataTable(
                    columnSpacing: 10,
                    dataRowHeight: 70,
                      columns: <DataColumn>[
                        DataColumn(label: Text("Personel")),
                        DataColumn(label: Text("Pazartesi")),
                        DataColumn(label: Text("Salı")),
                        DataColumn(label: Text("Çarşamba")),
                        DataColumn(label: Text("Perşembe")),
                        DataColumn(label: Text("Cuma")),
                        DataColumn(label: Text("Cumartesi")),
                      ],
                      rows: dataList
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e["Personel"])),
                                DataCell(GestureDetector(
                                  onLongPress: () {
                                    print(e);
                                    print("1");
                                  },
                                  child: Text(e["Pazartesi"]),
                                )),
                                DataCell(Text(e["Sali"])),
                                DataCell(Text(e["Carsamba"])),
                                DataCell(Text(e["Persembe"])),
                                DataCell(Text(e["Cuma"])),
                                DataCell(Text(e["Cumartesi"])),
                              ]))
                          .toList())
                ],
              ))),
    );
  }
}
