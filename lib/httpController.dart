import 'dart:convert';
import 'dart:io';

class HttpController {

  

  static sendRequest(String url, Map map) async{
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    //String url ='https://cafecostes.com/flutter/saveShopping';
    //Map map = { "userName" : name , "list" : order, "sum_cost" : money, "num" : nums};
    HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(map)));
    print(map);
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    return reply;
  }
}