import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppebleTimer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
              alignment: Alignment(0, -0.8),
              child: Text('Test your \nreaction speed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 38,
                      color: Colors.white,
                      fontWeight: FontWeight.w900))),
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 230,
                height: 180,
                child: ColoredBox(
                  color: const Color(0xFF6D6D6D),
                  child: Center(
                    child: Text(millisecondsText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              )),
          Align(
              alignment: const Alignment(0, 0.8),
              child: GestureDetector(
                onTap: () => setState(() {
                  switch (gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      millisecondsText = "";
                      _startWaitingTimer();
                      break;
                    case GameState.waiting:
                      waitingTimer?.cancel();
                      millisecondsText = "repeat";
                      gameState = GameState.readyToStart;
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      stoppebleTimer?.cancel();
                      break;
                  }
                }),
                child: SizedBox(
                  width: 200,
                  height: 140,
                  child: ColoredBox(
                    color: _gerButtonColor(),
                    child: Center(
                      child: Text(_getButtonText(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 38,
                              color: Colors.white,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "Start";
      case GameState.waiting:
        return "Wait";
      case GameState.canBeStopped:
        return "Stop";
    }
  }

  Color _gerButtonColor() {
    switch (gameState) {
      case GameState.readyToStart:
        return const Color(0xFF40CA88);
      case GameState.waiting:
        return const Color(0xFFE0982D);
      case GameState.canBeStopped:
        return const Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int randomMillisecSeconds = Random().nextInt(4000) + 1000;
    waitingTimer = Timer(Duration(milliseconds: randomMillisecSeconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startSpoppableTimer();
    });
  }

  void _startSpoppableTimer() {
    stoppebleTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppebleTimer?.cancel();
    super.dispose();
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
