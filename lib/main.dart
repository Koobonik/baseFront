import 'dart:convert';

import 'package:arduino_app/DataController.dart';
import 'package:arduino_app/DataController.dart' as prefix0;
import 'package:arduino_app/firebase.dart';
import 'package:arduino_app/httpController.dart';
import 'package:flutter/material.dart';

void main() async {
  FirebaseController.firebaseconfig();
  
  DataController.pushStatus = await HttpController.sendRequest(HttpController.url+"/getStatus", null);
  String response = await HttpController.sendRequest(HttpController.url+"/getLogs", null);
  DataController.pushLogs = json.decode(response);
  print(DataController.pushLogs[0]["logNum"]);
  DataController.save();
  // DataController.save();
  // DataController.read();
  // HttpController httpController = new HttpController();
  //  String url = "http://cafecostes.com:8081/registerFirebaseToken";
  //  Map map = { "data1" :  FirebaseController.firebasetoken, "data2" : "hihi", "data3" : "hello"};
  //  var hi = HttpController.sendRequest(url, map);
  // // print("리턴값은 : ");
  //  print(hi);
  runApp(MyApp());
  // DataController.pushStatus = HttpController.sendRequest(HttpController.url+"/getStatus", null);
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '기본조 아두이노',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '왓칭띵'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<bool> isSelected;
  void _incrementCounter() {
    setState(() {
      print(FirebaseController.fi);
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
  @override
    void initState() {
        isSelected = [true, false];
        super.initState();
        if(DataController.pushStatus == "true"){
          isSelected[0] = true;
          isSelected[1] = false;
        }
        else {
          isSelected[0] = false;
          isSelected[1] = true;
        }
        
    }

    
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(children: <Widget>[
        Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '알림 스위치',
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            ToggleButtons(
                borderColor: Colors.black,
                fillColor: Colors.blue,
                borderWidth: 2,
                selectedBorderColor: Colors.black,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        '알림을 받습니다.',
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        '알림을 받지 않습니다.',
                        style: TextStyle(fontSize: 16),
                    ),
                    ),
                ],
                onPressed: (int index) {
                    setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                        if (i == index) {
                        isSelected[i] = true;
                        } else {
                        isSelected[i] = false;
                        }
                    }
                    if(index == 0){
                      String url = HttpController.url+"/ChangeStatus";
                      Map map = { "data1" :  "true", "data2" : "hihi", "data3" : "hello"};
                      var response = HttpController.sendRequest(url, map);
                      print(response);
                      DataController.pushStatus = "true";
                    }
                    else{
                      String url = HttpController.url+"/ChangeStatus";
                      Map map = { "data1" :  "false", "data2" : "hihi", "data3" : "hello"};
                      var response = HttpController.sendRequest(url, map);
                      print(response);
                      DataController.pushStatus = "false";
                    }
                    DataController.save();
                    
                    });
                },
                isSelected: isSelected,
                ),
                //Text(DataController.pushLogs.toString()),
                Column(children: List.generate(DataController.pushLogs.length, (index) => Text(
                  DataController.pushLogs[index]["date"] + " " + DataController.pushLogs[index]["access"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
        ),),
                
          ],
        ),
      ),
      ],),
      
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
