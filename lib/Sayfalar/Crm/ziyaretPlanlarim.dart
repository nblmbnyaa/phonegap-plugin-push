import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:prosis_mobile/Genel/basariUtilities.dart';
import 'package:prosis_mobile/Genel/mesajlar.dart';
import 'package:prosis_mobile/Sayfalar/Crm/talepkarti.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:maps_launcher/maps_launcher.dart' as MapsLauncher;

import '../../main.dart';

class PageCrmZiyaretPlanlarim extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageCrmZiyaretPlanlarimState();
  }
}

class PageCrmZiyaretPlanlarimState extends State<PageCrmZiyaretPlanlarim> {
  ProgressDialog pr;
  List<dynamic> dataList = [];

  Future<void> yenile() async {
    pr.show();
    List<String> parametreler = new List<String>();
    parametreler.add(JsonEncoder().convert(MyApp.oturum));
    DefaultReturn sn = await BasariUtilities().getApiSonuc(parametreler,
        MyApp.apiUrl + "apitumtalepler/ZiyaretPlanlarim", context);
    if (sn.basarili) {
      var gelen = json.decode(sn.sonuc);
      dataList = gelen;
    }
    setState(() {
      Future.delayed(Duration(seconds: 1)).then((value) {
        pr.hide().whenComplete(() {
          //print(pr.isShowing());
        });
      });
    });
  }

  void talebegit(int talepno) async {
    if (talepno <= 0) return;
    final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PageTalepKarti(
              talepNo: talepno,
            )));
    yenile();
  }

  @override
  void initState() {
    if (pr == null) {
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
    }
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
            title: Text("Ziyaret Planlarım"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.refresh), onPressed: yenile)
            ],
          ),
          body: RefreshIndicator(
              onRefresh: yenile,
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext ctxt, int ind) {
                    return GestureDetector(
                      child: Container(
                          color: ind % 2 == 0
                              ? Colors.blue[100]
                              : Colors.blue[200],
                          child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        dataList[ind]["ServisTarihi"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        dataList[ind]["MusteriUnvani"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                      visible: dataList[ind]["subeadi"] != "" ||
                                          dataList[ind]["talepedenyetkili"] !=
                                              "",
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 10,
                                            child: Text(dataList[ind]
                                                    ["subeadi"] +
                                                " " +
                                                dataList[ind]
                                                    ["talepedenyetkili"]),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Visibility(
                                                visible: dataList[ind]
                                                        ["CepTel"] !=
                                                    "",
                                                child: IconButton(
                                                    onPressed: () {
                                                      String tel = dataList[ind]
                                                          ["CepTel"];
                                                      if (tel.length == 10)
                                                        tel = "0" + tel;
                                                      launcher
                                                          .launch("tel:" + tel);
                                                    },
                                                    icon: Icon(Icons.call))),
                                          ),
                                        ],
                                      )),
                                  Visibility(
                                      visible: dataList[ind]["Adresi"] != "",
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 10,
                                            child:
                                                Text(dataList[ind]["Adresi"]),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Visibility(
                                                visible: (dataList[ind]
                                                                ["gpsenlem"] >
                                                            0 &&
                                                        dataList[ind]
                                                                ["gpsboylam"] >
                                                            0) ||
                                                    dataList[ind]["Adresi"] !=
                                                        "",
                                                child: IconButton(
                                                    onPressed: () {
                                                      if (dataList[ind]
                                                                  ["gpsenlem"] >
                                                              0 &&
                                                          dataList[ind][
                                                                  "gpsboylam"] >
                                                              0) {
                                                        MapsLauncher
                                                                .MapsLauncher
                                                            .launchCoordinates(
                                                                dataList[ind][
                                                                    "gpsenlem"],
                                                                dataList[ind][
                                                                    "gpsboylam"]);
                                                      } else if (dataList[ind]
                                                                  ["Adresi"]
                                                              .toString()
                                                              .length >
                                                          0) {
                                                        MapsLauncher
                                                                .MapsLauncher
                                                            .launchQuery(
                                                                dataList[ind]
                                                                    ["Adresi"]);
                                                      }
                                                    },
                                                    icon: Icon(
                                                        Icons.location_on))),
                                          ),
                                        ],
                                      ))
                                ],
                              ))),
                      onTap: () {
                        talebegit(dataList[ind]["TalepNo"]);
                      },
                    );
                  })),
        ),
        onWillPop: () => Mesajlar().backPressed(context));
  }
}
