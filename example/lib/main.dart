import 'package:connectivity_web/connectivity_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {

    /// Use it as [Stream]
    ConnectivityWeb().isOnline.observe((ChangeNotification<bool> isOnline) {
      print('IS ONLINE: ${isOnline.newValue}');  
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        /// Use it in Observer Widget [flutter_mobx] 
        child: Observer(builder: (_){
          
          var isOnline = ConnectivityWeb().isOnline.value;
          var qRtt = ConnectivityWebUtil.getInternetQualityInfo(ConnectivityWeb().rtt.value)
          .toString().split('.')[1];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  isOnline ? Icon(Icons.signal_wifi_4_bar, color: Colors.green) : Icon(Icons.signal_wifi_off, color: Colors.red),
                  SizedBox(width:16),
                  Text('IS ONLINE: $isOnline'),
                ],
              ),
              Text('QUALITY: $qRtt'),
            ],
          );
        })
      ),     
    );
  }
}
