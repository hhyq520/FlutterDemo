import 'dart:convert';

class VersionBean{
  String version;
  String url;
  int fromSource;
  String word;

  VersionBean.fromJson(Map userMap) {
    version = userMap['version'];
    url = userMap['url'];
    fromSource = userMap['fromSource'];
    word = userMap['word'];
  }


  String toJson() {
    Map<String, dynamic> userMap = new Map();
    userMap['version'] = version;
    userMap['url'] = url;
    userMap['fromSource'] = fromSource;
    userMap['word'] = word;
    return json.encode(userMap);
  }
}