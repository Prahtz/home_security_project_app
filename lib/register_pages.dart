import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:home_security_project_app/main.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class RegisterFirstPage extends StatefulWidget {
  final Socket socket;
  static const String id = 'register_first';

  RegisterFirstPage({this.socket}) : super();

  @override
  _RegisterFirstPageState createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double imagesHeight = 94;
  double transmitterWidth = 50;
  double magnetWidth = 22;
  double imagesSpacing = 10;
  double totalWidth;
  AnimationController _controller;
  Animation _appearAnimation;
  Animation _disappearAnimation;
  Animation _openAnimation;
  bool go = false;

  void _registerNewSensor() async {
    widget.socket.add(utf8.encode(Message.registerDoorSensor + Message.eom));
    print('sent');
  }

  @override
  void initState() {
    super.initState();
    _registerNewSensor();
    totalWidth = transmitterWidth + magnetWidth + imagesSpacing;
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _appearAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.333,
          curve: Curves.linear,
        ),
      ),
    )..addStatusListener((status) {});
    _appearAnimation.addListener(() {
      setState(() {
        go = false;
        _opacity = _appearAnimation.value;
      });
    });

    _openAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.333,
          0.666,
          curve: Curves.decelerate,
        ),
      ),
    )..addStatusListener((status) {});
    _openAnimation.addListener(() {
      setState(() {
        if (_openAnimation.value <= 25) go = true;
      });
    });

    _disappearAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.666,
          1,
          curve: Curves.linear,
        ),
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          go = false;
          _controller.forward();
        }
      });
    _disappearAnimation.addListener(() {
      setState(() {
        if (go) _opacity = _disappearAnimation.value;
      });
    });

    _controller.forward();
    print("o");
  }

  Future<bool> _onBackPressed() async {
    try {
      print("ABORT FIRST");
      widget.socket.add(utf8.encode(Message.abort + Message.eom));
    } catch (err) {
      print("Socket chiuso");
    }
    Navigator.pop(context);
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Registrazione sensore porta"),
            ),
            backgroundColor: Colors.grey[200],
            body: Stack(
              children: <Widget>[
                Builder(builder: (context) {
                  return Container(
                      height: MediaQuery.of(context).size.height -
                          Scaffold.of(context).appBarMaxHeight,
                      width: MediaQuery.of(context).size.width);
                }),
                Builder(builder: (context) {
                  return Positioned(
                    width: transmitterWidth,
                    left: (MediaQuery.of(context).size.width) / 2 -
                        totalWidth / 2,
                    top: (MediaQuery.of(context).size.height -
                                Scaffold.of(context).appBarMaxHeight) /
                            4 -
                        imagesHeight / 2,
                    child: Opacity(
                        opacity: _opacity,
                        child: Image.asset(
                            "assets/images/door_sensor_transmitter.png")),
                  );
                }),
                Builder(builder: (context) {
                  return Positioned(
                    width: magnetWidth,
                    right: (MediaQuery.of(context).size.width) / 2 -
                        totalWidth / 2 -
                        _openAnimation.value,
                    top: (MediaQuery.of(context).size.height -
                                Scaffold.of(context).appBarMaxHeight) /
                            4 -
                        imagesHeight / 2,
                    child: Opacity(
                        opacity: _opacity,
                        child: Image.asset(
                            "assets/images/door_sensor_magnet.png")),
                  );
                }),
                Builder(builder: (context) {
                  return Center(
                      child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                      "Avvicina il magnete al sensore come in figura.\n\nSe il sensore è già stato installato, assicurati che il magnete e il sensore siano " +
                          "inizialmente separati.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87),
                    ),
                  ));
                }),
              ],
            )));
  }
}

class RegisterSecondPage extends StatefulWidget {
  static const String id = 'register_second';
  final Socket socket;
  RegisterSecondPage({this.socket}) : super();

  @override
  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double imagesHeight = 94;
  double transmitterWidth = 50;
  double magnetWidth = 22;
  double imagesSpacing = 10;
  double totalWidth;
  AnimationController _controller;
  Animation _appearAnimation;
  Animation _disappearAnimation;
  Animation _openAnimation;
  bool go = false;

  @override
  void initState() {
    super.initState();
    totalWidth = transmitterWidth + magnetWidth + imagesSpacing;
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);

    _appearAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.333,
          curve: Curves.linear,
        ),
      ),
    )..addStatusListener((status) {});
    _appearAnimation.addListener(() {
      setState(() {
        go = false;
        _opacity = _appearAnimation.value;
      });
    });

    _openAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.333,
          0.666,
          curve: Curves.decelerate,
        ),
      ),
    )..addStatusListener((status) {});
    _openAnimation.addListener(() {
      setState(() {
        if (_openAnimation.value >= 25) go = true;
      });
    });

    _disappearAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.666,
          1,
          curve: Curves.linear,
        ),
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          go = false;
          _controller.forward();
        }
      });
    _disappearAnimation.addListener(() {
      setState(() {
        if (go) _opacity = _disappearAnimation.value;
      });
    });

    _controller.forward();
  }

  Future<bool> _onBackPressed() async {
    try {
      print("ABORT SECOND");
      widget.socket.add(utf8.encode(Message.abort + Message.eom));
    } catch (err) {
      print("Socket chiuso");
    }
    Navigator.popUntil(context, (route) {
      print(route.settings.name);
      return route.settings.name == MyHomePage.id;
    });
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Registrazione sensore porta"),
            ),
            backgroundColor: Colors.grey[200],
            body: Stack(
              children: <Widget>[
                Builder(builder: (context) {
                  return Container(
                      height: MediaQuery.of(context).size.height -
                          Scaffold.of(context).appBarMaxHeight,
                      width: MediaQuery.of(context).size.width);
                }),
                Builder(builder: (context) {
                  return Positioned(
                    width: transmitterWidth,
                    left: (MediaQuery.of(context).size.width) / 2 -
                        totalWidth / 2,
                    top: (MediaQuery.of(context).size.height -
                                Scaffold.of(context).appBarMaxHeight) /
                            4 -
                        imagesHeight / 2,
                    child: Opacity(
                        opacity: _opacity,
                        child: Image.asset(
                            "assets/images/door_sensor_transmitter.png")),
                  );
                }),
                Builder(builder: (context) {
                  return Positioned(
                    width: magnetWidth,
                    right: (MediaQuery.of(context).size.width) / 2 -
                        totalWidth / 2 -
                        _openAnimation.value,
                    top: (MediaQuery.of(context).size.height -
                                Scaffold.of(context).appBarMaxHeight) /
                            4 -
                        imagesHeight / 2,
                    child: Opacity(
                        opacity: _opacity,
                        child: Image.asset(
                            "assets/images/door_sensor_magnet.png")),
                  );
                }),
                Builder(builder: (context) {
                  return Center(
                      child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                      "Allontana il magnete dal sensore come in figura.\n\nSe il sensore è già stato installato, assicurati che il magnete e il sensore siano " +
                          "inizialmente uniti.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87),
                    ),
                  ));
                }),
              ],
            )));
  }
}

class RegisterThirdPage extends StatefulWidget {
  static const String id = 'register_third';
  final Socket socket;
  final Stream<Uint8List> socketStream;
  RegisterThirdPage({this.socket, this.socketStream}) : super();

  @override
  _RegisterThirdPageState createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage>
    with SingleTickerProviderStateMixin {
  final myController = TextEditingController();
  FocusNode _focus = new FocusNode();
  double imagesHeight = 94;
  double transmitterWidth = 50;
  double magnetWidth = 22;
  double imagesSpacing = 10;
  double totalWidth;
  double _opacity = 1;
  bool go = false;
  String labelText = "Nome sensore";
  Color labelTextColor = Colors.black;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    KeyboardVisibilityNotification().addNewListener(
      onHide: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  void _onFocusChange() {
    setState(() {
      _opacity = 1 - _opacity;
    });
  }

  Future<bool> _onBackPressed() async {
    try {
      print("ABORT THIRD");
      widget.socket.add(utf8.encode(Message.abort + Message.eom));
    } catch (err) {
      print("Socket chiuso");
    }
    Navigator.popUntil(context, (route) {
      print(route.settings.name);
      return route.settings.name == MyHomePage.id;
    });
    return false;
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Registrazione sensore porta"),
                ),
                backgroundColor: Colors.grey[200],
                body: Stack(
                  children: <Widget>[
                    Builder(builder: (context) {
                      return Container(
                          height: MediaQuery.of(context).size.height -
                              Scaffold.of(context).appBarMaxHeight,
                          width: MediaQuery.of(context).size.width);
                    }),
                    Builder(builder: (context) {
                      return Positioned(
                          top: (MediaQuery.of(context).size.height -
                                  Scaffold.of(context).appBarMaxHeight) /
                              4,
                          left: (MediaQuery.of(context).size.width -
                                  (MediaQuery.of(context).size.width / 1.2)) /
                              2,
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Opacity(
                                  opacity: _opacity,
                                  child: Text(
                                      "Inserisci un nome da attribuire al sensore.\n\n Esempio: \"Porta salotto piano terra\"",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black87)))));
                    }),
                    Builder(builder: (context) {
                      return Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                            Container(
                                width:
                                    (MediaQuery.of(context).size.width / 1.2) -
                                        60,
                                //color: Colors.white,
                                child: TextField(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 17.0, horizontal: 10.0),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                      ),
                                      labelText: labelText,
                                      labelStyle:
                                          TextStyle(color: labelTextColor)),
                                  controller: myController,
                                  onSubmitted: (text) => sendSensorName(text),
                                  focusNode: _focus,
                                )),
                            Container(
                                height: 34.0 + 17.0 + 2.0,
                                child: FlatButton(
                                  onPressed: () {
                                    if (!_isButtonDisabled)
                                      sendSensorName(myController.text);
                                  },
                                  color: Color(0xff3786ff),
                                  child: Icon(Icons.send, color: Colors.white),
                                ))
                          ]));
                    }),
                  ],
                ))));
  }

  void sendSensorName(String sensorName) {
    if (sensorName.contains(Message.eom[0]) ||
        sensorName.contains(";") ||
        sensorName.isEmpty ||
        sensorName.length >= 512 - Message.eom.length) {
      setState(() {
        labelText = "Nome inserito non valido!";
        labelTextColor = Colors.red;
        myController.clear();
      });
      return;
    }

    setState(() {
      _isButtonDisabled = true;
    });
    StreamSubscription<Uint8List> subscription;
    subscription = widget.socketStream.listen((data) {
      print(utf8.decode(data));
      String message = utf8.decode(data);
      if (message.contains(Message.eom)) {
        message = message.substring(0, message.length - Message.eom.length);
        if (message == Message.ack) {
          widget.socket.add(utf8.encode(sensorName + Message.eom));
        }
      }
      subscription.cancel();
    });
    widget.socket.add(utf8.encode(MessageType.string + Message.eom));
  }
}

Future<void> showAlertDialog(
    BuildContext context, String title, String description, Function onClose) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(description),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  ).then(onClose);
}
