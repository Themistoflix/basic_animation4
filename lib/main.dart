import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      builder: (context) => AppState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Basic Animations'
          ),
        ),
        body: Center(
            child:Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300.0,
                  child: Center(
                    child: AnimatedColorBox(),
                  ),
                ),
                AnimationStateDisplay()
              ],
            )
        ),
      )
    );

  }
}

class AnimationStateDisplay extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final animationStatus = appState.getAnimationStatus();
    return Text(
      '$animationStatus',
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
      ),
    );
  }
}


class AnimatedColorBox extends StatefulWidget{
  @override
  AnimatedColorBoxState createState() => AnimatedColorBoxState();
}

class AnimatedColorBoxState extends State<AnimatedColorBox> with SingleTickerProviderStateMixin{

  Animation<double> _widthAnimation;
  Animation<double> _heightAnimation;
  Animation<Color> _colorAnimation;
  AnimationController _controller;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _widthAnimation = Tween<double>(begin: 100, end: 300).animate(_controller);
    _heightAnimation = Tween<double>(begin: 100, end: 300).animate(_controller);
    _colorAnimation = ColorTween(begin: Colors.deepPurple, end: Colors.blueAccent).animate(_controller)
    ..addStatusListener((AnimationStatus status) {
      final appState = Provider.of<AppState>(context);
      appState.setAnimationStatus(status);
    });
    _controller.forward();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (BuildContext context, Widget child){
        return GestureDetector(
          child: Container(
              color: _colorAnimation.value,
              width: _widthAnimation.value,
              height: _heightAnimation.value
          ),
          onTap: (){
            setNewAnimationEndState();
          },
        );
      },

    );
  }

  void setNewAnimationEndState(){
    Random rand = Random();
    _widthAnimation = Tween<double>(begin: _widthAnimation.value, end: rand.nextDouble()*200 + 50.0).animate(_controller);
    _heightAnimation = Tween<double>(begin: _heightAnimation.value, end: rand.nextDouble()*200 + 50.0).animate(_controller);
    _controller.forward(from: 0.0);

  }
}

class AppState with ChangeNotifier{
  AnimationStatus _status = AnimationStatus.forward;

  void setAnimationStatus(AnimationStatus newStatus){
    _status = newStatus;
    notifyListeners();
  }

  AnimationStatus getAnimationStatus(){
    return _status;
  }
}
