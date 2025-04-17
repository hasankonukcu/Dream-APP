import 'package:http/http.dart' as http;

class NotificationSendSevice {
  Future<bool> sendNotification(String key) async {
    String endUrl = "https://fcm.googleapis.com/fcm/send";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$key"
    };
    String json =
        '{ "to" : "/topics/admins", "notification" : { "title": "Yeni bir rüya var!" } }';
    
  
    http.Response response =
        await http.post(Uri.parse(endUrl), headers: headers, body: json);
    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      return false;
    }
  }
}
