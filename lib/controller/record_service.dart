import 'dart:convert';
import 'package:firstdesktop/model/record_class.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

var url = Uri.https('vocab.nic.in', '/pec.json');

class MyHomePageProvider extends ChangeNotifier {
  MessageData? data;
  late MessageData district;
  late MessageData taluk;

// ignore: missing_return
  Future<List<MessageData>> fetchforweb(context) async {
    final response = await http.get(url);
    print(response.body);

    // response code 200 means that the request was successful
    if (response.statusCode == 200) {
      var listofdata = response.body;
      var mJson = json.decode(listofdata);
      this.data = MessageData.fromJson(mJson);
      this.district = MessageData.fromJson(mJson);
      this.taluk = MessageData.fromJson(mJson);

      //removing the repeated district from the list
      var dis = this.district.records.map((rs) => rs.district).toSet();
      this.district.records.retainWhere((x) => dis.remove(x.district));

      //removing the repeated taluk from the list
      final tal = this.taluk.records.map((e) => e.teshilTaluk).toSet();
      this.taluk.records.retainWhere((x) => tal.remove(x.teshilTaluk));

      this.notifyListeners();
    }
    throw Exception();
  }
}
