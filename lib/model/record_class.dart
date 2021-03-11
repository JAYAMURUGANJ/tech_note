class MessageData {
  String limit;
  String offset;
  List<Records> records;

  MessageData.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    offset = json['offset'];
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
      });
    }
  }
}

class Records {
  int slNo;
  String district;
  String teshilTaluk;
  String area;
  String centerType;
  String centerName;
  String centerAddress;
  int contactNo;
  int pincode;
  String postOffice;
  String latitude;
  String longitude;
  String altitude;

  Records.fromJson(Map<String, dynamic> json) {
    slNo = json['sl_no'];
    district = json['district'];
    teshilTaluk = json['teshil_taluk'];
    area = json['area'];
    centerType = json['center_type'];
    centerName = json['center_name'];
    centerAddress = json['center_address'];
    contactNo = json['contact_no'];
    pincode = json['pincode'];
    postOffice = json['post_office'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    altitude = json['altitude'];
  }
}
