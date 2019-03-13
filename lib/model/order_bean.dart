import 'dart:convert';

class OrderBean{
    String CUSTOMER_NAME;
    String PICK_STATUS;
    String PICK_FINISH_DATE;
    String CUSTOMER_CODE;
    String CUSTOMER_LINKMAN;
    String CUSTOMER_ADDRESS;
    String CUSTOMER_PHONE1;
    int SUM_PIECE;
    double TOTAL_WEIGHTT;
    double TOTAL_VOLUME;
    String GUID;
    OrderBean(this.CUSTOMER_NAME, this.PICK_STATUS, this.PICK_FINISH_DATE);

    OrderBean.fromJson(Map userMap) {
      CUSTOMER_NAME = userMap['CUSTOMER_NAME'];
      PICK_STATUS = userMap['PICK_STATUS'];
      PICK_FINISH_DATE = userMap['PICK_FINISH_DATE'];
      CUSTOMER_CODE = userMap['CUSTOMER_CODE'];
      CUSTOMER_LINKMAN = userMap['CUSTOMER_LINKMAN'];
      CUSTOMER_ADDRESS = userMap['CUSTOMER_ADDRESS'];
      CUSTOMER_PHONE1 = userMap['CUSTOMER_PHONE1'];
      SUM_PIECE = userMap['SUM_PIECE'];
      TOTAL_WEIGHTT = userMap['TOTAL_WEIGHTT'];
      TOTAL_VOLUME = userMap['TOTAL_VOLUME'];
      GUID = userMap['GUID'];
    }


    String toJson() {
      Map<String, dynamic> userMap = new Map();
      userMap['GUID'] = GUID;
      userMap['CUSTOMER_NAME'] = CUSTOMER_NAME;
      userMap['PICK_STATUS'] = PICK_STATUS;
      userMap['PICK_FINISH_DATE'] = PICK_FINISH_DATE;
      userMap['CUSTOMER_CODE'] = CUSTOMER_CODE;
      userMap['CUSTOMER_LINKMAN'] = CUSTOMER_LINKMAN;
      userMap['CUSTOMER_ADDRESS'] = CUSTOMER_ADDRESS;
      userMap['CUSTOMER_PHONE1'] = CUSTOMER_PHONE1;
      userMap['SUM_PIECE'] = SUM_PIECE;
      userMap['TOTAL_WEIGHTT'] = TOTAL_WEIGHTT;
      userMap['TOTAL_VOLUME'] = TOTAL_VOLUME;
      return json.encode(userMap);
    }
}