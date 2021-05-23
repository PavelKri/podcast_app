import 'dart:convert';
import 'dart:ui';
import 'package:crypto/crypto.dart';

class Utils {
  static String getMinutsFromLength(String length) {
    String res = '';
    int ostatok = 0;
    var bint = (BigInt.parse(length) / BigInt.from(24000)).toInt();
    ostatok = bint;
    if (bint > 3600) {
      ostatok = bint ~/ 3600;
      res = ostatok.toString() + ":";
      ostatok = bint - ostatok * 3600;
    }
    if (bint > 60 && ostatok > 60) {
      int _ostatok = ostatok ~/ 60;
      if (_ostatok == 0) {
        if (res.length > 0) {
          res += "00:";
        } else if (_ostatok < 10) {
          if (res.length > 0) {
            res += "0" + _ostatok.toString() + ":";
          }
        } else {
          res += _ostatok.toString() + ":";
        }
      } else {
        res += (ostatok ~/ 60).toString() + ":";
      }
      ostatok = ostatok % 60;
    } else {
      if (ostatok > 10) {
        res += ":" + ostatok.toString();
      } else {
        res += ":0" + ostatok.toString();
      }
    }
    if (ostatok > 10 && bint > 60) {
      if (ostatok > 10) {
        res += ostatok.toString();
      } else {
        res += "0" + ostatok.toString();
      }
    }
    return res;
  }

  static String getMinutsFromDuration(int duration) {
    String res = '';
    int ostatok = 0;
    var bint = duration;
    ostatok = bint;
    if (bint > 3600) {
      ostatok = bint ~/ 3600;
      res = ostatok.toString() + ":";
      ostatok = bint - ostatok * 3600;
    }
    if (bint > 60 && ostatok > 60) {
      int _ostatok = ostatok ~/ 60;
      if (_ostatok == 0) {
        if (res.length > 0) {
          res += "00:";
        } else if (_ostatok < 10) {
          if (res.length > 0) {
            res += "0" + _ostatok.toString() + ":";
          }
        } else {
          res += _ostatok.toString() + ":";
        }
      } else {
        res += (ostatok ~/ 60).toString() + ":";
      }
      ostatok = ostatok % 60;
    } else {
      if (ostatok > 10) {
        res += ":" + ostatok.toString();
      } else {
        res += ":0" + ostatok.toString();
      }
    }
    if (ostatok > 10 && bint > 60) {
      if (ostatok > 10) {
        res += ostatok.toString();
      } else {
        res += "0" + ostatok.toString();
      }
    }
    return res;
  }
  static String textToUTF(String input) {
    return utf8.decode(input.runes.toList());
  }
  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static String getTimesAgo(int pubdate) {
    var date = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var diff = date - pubdate;
    // if diff < 3600 minuts
    if (diff < 3600) {
      var minutsAgo = diff ~/ 60;
      if (minutsAgo == 0) {
        minutsAgo = 1;
      }
      return minutsAgo.toString() + " " + "min.ago";
    }
    // if diff < 86400 hours
    else if (diff < 86400) {
      var hrsAgo = diff ~/ 3600;
      if (hrsAgo == 0) {
        hrsAgo = 1;
      }
      return hrsAgo.toString() + " " + "hrs.ago";
    }
    // if diff < 259200 days
    else if (diff < 2592000) {
      var daysAgo = diff ~/ 86400;
      if (daysAgo == 0) {
        daysAgo = 1;
      }
      return daysAgo.toString() + " " + "days.ago";
    }
    // if diff > 259200 meses
    else if (diff > 2592000) {
      var mesAgo = diff ~/ 2592000;
      if (mesAgo == 0) {
        mesAgo = 1;
      }
      return mesAgo.toString() + " " + "mes.ago";
    }
  }

  static int getIntColor(String str){
    return fromHex(generateMd5(str).substring(0,6));
  }

  static int fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return int.parse(buffer.toString(), radix: 16);
  }


}
