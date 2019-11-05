import 'package:shared_preferences/shared_preferences.dart';

class DataController {

  static String pushStatus = "true";
  static Future save() async {
    print("userinfo.save() 실행");
    final prefs = await SharedPreferences.getInstance();
    //userinfo.userCoupon = (prefs.getInt('counter') ?? 0) + 1;

    // 여기 저장하는 부분
    prefs.setString('pushStatus', pushStatus);
  }

  static Future read() async {
    final prefs = await SharedPreferences.getInstance();

    pushStatus = prefs.getString("pushStatus");
  }
}