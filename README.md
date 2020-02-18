# connectivity_web
## Flutter Web Package


### Add dependency to pubspec.yaml
```yaml
connectivity_web:
  git: https://github.com/emanuel-braz/connectivity_web.git
```


### Lib imports
`import 'package:connectivity_web/connectivity_web.dart';`


### Listen events
```dart
ConnectivityWeb().isOnline.observe((isOnline) {
  if (isOnline.newValue != isOnline.oldValue) print(isOnline.newValue);
});
```

## Full [Example](https://github.com/emanuel-braz/connectivity_web/tree/master/example)
```dart
class _MyHomePageState extends State<MyHomePage> {

  StreamController<bool> _observableController = StreamController<bool>.broadcast();
  ReactionDisposer _reactionDisposer;

  @override
  dispose(){
    _observableController.close();
    _reactionDisposer();
    super.dispose();
  }

  @override
  void initState() {

    /// Using it as [Stream]
    /// Add changes to a [StreamController] (you can use Streambuilder to render widgets)
    /// 
    /// You can achieve that with MobX Reaction (more powerful)
    _reactionDisposer = reaction((_) => ConnectivityWeb().isOnline.value, (value){      
      _observableController.add(value);
    });

    /// or
    /// Listening directly from [Observable] and updates the [StreamController] (more simple and direct)
    ConnectivityWeb().isOnline.observe((isOnline) {
      // _observarbleController.add(isOnline.newValue);
    });

    /// or simply use the Observer MobX Widget [flutter_mobx] (the simplest way)

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
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

              if (!snapshot.hasData || snapshot.hasError) return Container();

              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    snapshot.data ? Icon(Icons.signal_wifi_4_bar, color: Colors.green) : Icon(Icons.signal_wifi_off, color: Colors.red),
                    SizedBox(width:16),
                    Text('(StreamBuilder) IS ONLINE: ${snapshot.data}'),
                  ],
                );
            }
          ),

          Divider(),

          /// Observer example
          Observer(builder: (_){
            
            var isOnline = ConnectivityWeb().isOnline.value;
            var qRtt = ConnectivityWebUtil.getInternetQualityInfo(ConnectivityWeb().rtt.value).toString().split('.')[1];

            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isOnline ? Icon(Icons.signal_wifi_4_bar, color: Colors.green) : Icon(Icons.signal_wifi_off, color: Colors.red),
                    SizedBox(width:16),
                    Text('(MobX Observer) IS ONLINE: $isOnline'),
                  ],
                ),
                Text('QUALITY: $qRtt'),
              ],
            );
          }),
        ],
      ),     
    );
  }
}
```
