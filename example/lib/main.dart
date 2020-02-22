import 'dart:async';
import 'package:connectivity_web/connectivity_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity Web Demo',
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
  StreamController<bool> _observableController = StreamController<bool>.broadcast();
  ReactionDisposer _reactionDisposer;

  @override
  dispose() {
    _observableController.close();
    _reactionDisposer();
    super.dispose();
  }

  @override
  void initState() {

    /// Using it as [Stream]
    /// Add changes to a [StreamController] (you can use Streambuilder to render widgets)
    ///
    /// You can achieve that with MobX Reaction
    _reactionDisposer = reaction((_) => ConnectivityWeb().isOnline.value, (value) {
      _observableController.add(value);
    });

    /// or
    /// Listening directly from [Observable] and updates the [StreamController]
    ConnectivityWeb().isOnline.observe((isOnline) {
      print('it\'s online: ${isOnline.newValue}');
      // _observarbleController.add(isOnline.newValue);
    });

    /// also you can use the Observer MobX Widget from [flutter_mobx]
    /// Observer(builder: (_) => MyCustomWidget());
    
    /// and you can use the ConnectivityWeb pre-built widget [OnOffWidget] (the easiest way)
    /// OnOffWidget(
    ///   online: Icon(Icons.signal_wifi_4_bar, color: Colors.green),
    ///   offline: Icon(Icons.signal_wifi_off, color: Colors.red)
    /// ),

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          /// StreamBuilder example
          StreamBuilder(
              initialData: ConnectivityWeb().isOnline.value,
              stream: _observableController.stream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData || snapshot.hasError) return Container();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    snapshot.data
                        ? Icon(Icons.signal_wifi_4_bar, color: Colors.green)
                        : Icon(Icons.signal_wifi_off, color: Colors.red),
                    SizedBox(width: 16),
                    Text('(StreamBuilder) ${snapshot.data ? "ONLINE":"OFFLINE"}'),
                  ],
                );
              }),

          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              /// Pre-Built ConnectivityWeb Widget
              OnOffWidget(
                online: Icon(Icons.signal_wifi_4_bar, color: Colors.green),
                offline: Icon(Icons.signal_wifi_off, color: Colors.red)
              ),

              /// Observer example
              Observer(builder: (_) {
                var qRtt = ConnectivityWebUtil.getInternetQualityInfo(ConnectivityWeb().rtt.value).toString().split('.')[1];
                return Row(
                  children: <Widget>[
                    SizedBox(width: 16),
                    Text('(MobX Observer) ${ConnectivityWeb().isOnline.value ? "ONLINE":"OFFLINE"} - $qRtt'),
                  ],
                );
              })
            ],
          )
        ],
      ),
    );
  }
}
