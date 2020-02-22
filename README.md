# Flutter Web Package (connectivity_web)
A Flutter web package, that allows you to check internet status anytime or listen to event changes. There is a pre-built widget [OnOffWidget] to make things simple.

![](preview/preview.gif?raw=true)


### Check internet status anytime
```dart
bool isOnline = ConnectivityWeb().isOnline.value;
```


### Use the pre-built widget to display internet status in the screen
```dart
OnOffWidget(
  online: Icon(Icons.signal_wifi_4_bar, color: Colors.green),
  offline: Icon(Icons.signal_wifi_off, color: Colors.red)
);
```

### Listen events
```dart
ConnectivityWeb().isOnline.observe((isOnline) {
  if (isOnline.newValue != isOnline.oldValue) print(isOnline.newValue);
});
```

## You can find the full example [here](https://github.com/emanuel-braz/connectivity_web/tree/master/example) with Observer, Reaction, StreamController and OnOffWidget.



## Browser Internet Status Compatibility
![](preview/onlineCompatibility.png?raw=true)


## RTT Compatibility (Round-Trip Time) [experimental technology](https://developer.mozilla.org/en-US/docs/MDN/Contribute/Guidelines/Conventions_definitions#Experimental)
![](preview/rttCompatibility.png?raw=true)
