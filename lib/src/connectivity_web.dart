import 'dart:html';
import 'dart:async';
import 'package:connectivity_web/src/utils/disposable.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

class ConnectivityWeb implements Disposable {

  ConnectivityWeb._privateConstructor(){

    changeStatusConnection = Action(_changeStatusConnection);
    changeRttConnection = Action(_changeRttConnection);
    
    _onInternetConnection = window?.navigator?.connection?.onChange;
    if (_onInternetConnection != null) {
      _internetConnectionSubscription = _onInternetConnection
      .listen((event) {
        changeRttConnection();
      });
    }
    _registerEventListenerOnLineOffLine();
  }
  static final ConnectivityWeb _instance = ConnectivityWeb._privateConstructor();
  factory ConnectivityWeb() => kIsWeb ? _instance : null;
  
  Stream<Event> _onInternetConnection;
  StreamSubscription<Event> _internetConnectionSubscription;
  Observable<bool> isOnline = Observable(true);
  Observable<int> rtt = Observable(0);

  Action changeStatusConnection;
  void _changeStatusConnection () {
    isOnline.value = window?.navigator?.onLine ?? true;
  }

  Action changeRttConnection;
  void _changeRttConnection () {    
    rtt.value = window?.navigator?.connection?.rtt;
  }

  // Ensures most compatibility among browsers
  void _registerEventListenerOnLineOffLine(){
    window.onOnline.listen((event) => changeStatusConnection());
    window.onOffline.listen((event) => changeStatusConnection());
  }

  @override
  dispose() {
    _internetConnectionSubscription.cancel();
  }
}