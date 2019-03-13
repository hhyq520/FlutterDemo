import 'dart:convert';

class UploadSignBean{
  int id;
  String billCode ; //运单号
  String signDate;
  String dispachName;
  String recordName;
  String recordNameCode;
  String recordSite;
  String recordSiteNo;
  String signName;
  String dispachNameCode;

  String toJson() {
    Map<String, dynamic> userMap = new Map();
    userMap['id'] = id;
    userMap['billCode'] = billCode;
    userMap['signDate'] = signDate;
    userMap['dispachName'] = dispachName;
    userMap['recordName'] = recordName;
    userMap['recordNameCode'] = recordNameCode;
    userMap['recordSite'] = recordSite;
    userMap['recordSiteNo'] = recordSiteNo;
    userMap['signName'] = signName;
    userMap['dispachNameCode'] = dispachNameCode;
    return json.encode(userMap);
  }
}