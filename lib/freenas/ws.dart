import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/status.dart' as status;
import 'package:nas/freenas/provider.dart';
import 'package:uuid/uuid.dart';

typedef void onLoginFunc(bool, {String token});

class WebSocket {
  WebSocket(this._address, this._decodeFunc);

  String _address;
  String _username;
  String _password;
  String _token;
  Timer _timer;
  IOWebSocketChannel _chan;
  decodeFunc _decodeFunc;
  onLoginFunc _onLogin;
  bool _done;
  Map<String, messageHandler> _handles = new Map<String, messageHandler>();
  Uuid uuid = new Uuid();

  void init({String username, String password}) async {
    this._username = username;
    this._password = password;
    this._chan = await IOWebSocketChannel.connect(this._address);
    this._timer = new Timer(const Duration(milliseconds: 3000), () {
      try {
        this._send(new freeNasData(msg: "connect"));
      } catch (e) {

      }
    });
    this._connect();
    this._chan.stream.listen((data) {
      print(data);
      freeNasData msg = this._decodeFunc(data);
      this._handles[msg.id](msg);
    },onError: () {
      print("something error");
    }, onDone: () {
      this._timer.cancel();
      if (this._done) {
        this.init();
      }
    }, cancelOnError: true);
  }

  WebSocket onLogin(Function fn) {
    this._onLogin = fn;
    return this;
  }

  void close() {
    this._done = true;
    this._chan.sink.close();
  }

  void _send(freeNasData msg, {messageHandler handler}) {
    msg.id = this.uuid.v4();
    if (handler != null) {
      this._handles[msg.id] = handler;
    }
    this._chan.sink.add(jsonEncode(msg.toJson()));
  }

  void _connect() {
    this._send(new freeNasData(msg: "connect"), handler: (freeNasData msg) {
      this.authLogin(this._username, this._password);
    });
  }
  void authLogin(String username, String password) {
    this._send(new freeNasData(params: [username, password]), handler: (freeNasData msg) {
      if (msg.result as bool) {

      } else {
        this._onLogin(false);
      }
    });
  }
  void authGenerateToken() {
    this._send(new freeNasData(params: [300]), handler: (freeNasData msg) {
      this._token = msg.result as String;
      this._onLogin(true, token: this._token);
    });
  }
}