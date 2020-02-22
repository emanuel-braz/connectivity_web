import 'package:connectivity_web/connectivity_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class OnOffWidget extends StatelessWidget {

  final Widget online;
  final Widget offline;

  const OnOffWidget({Key key, @required this.online, @required this.offline}):
    assert(online != null),
    assert(offline != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) { 
        return ConnectivityWeb().isOnline.value ? online : offline;
       },
    );
  }
}