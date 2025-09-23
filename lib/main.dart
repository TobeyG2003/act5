import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color happyColor = Colors.yellow;
  String currentLevel = "Neutral";
  int timecounter = 0;
  int wincounter = 0;
  double energy = 1.0; // Energy level from 0.0 to 1.0
  bool win = false;
  bool gameover = false;
  bool timerstarted = false;
  Timer? _timer;
  Timer? wintimer;

  void changeName(String name) {
    setState(() {
      petName = name;
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      energy -= 0.1;
      if (energy < 0) energy = 0;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      energy += 0.1;
      if (energy > 1) energy = 1;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel += 20; //swapped these values since lower hunger should increase happiness
    } else {
      happinessLevel -= 10;
    }
    _checkHappinessLevel();
  }

  void _checkHappinessLevel() {
    if (happinessLevel > 70) {
      happyColor = Colors.green;
      currentLevel = "Happy";
    } else if (happinessLevel >= 30) {
      happyColor = Colors.yellow;
      currentLevel = "Neutral";
    } else {
      happyColor = Colors.red;
      currentLevel = "Sad";
    }
    if (happinessLevel > 80) {
      if (!timerstarted) {
        timerstarted = true;
          wintimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          wintimerupdate();
        });
      }
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  void updatetimer() {
    setState(() {
      timecounter += 1;
      if (timecounter % 30 == 0) {
        _updateHunger();
        energy += 0.1;
        if (energy > 1) energy = 1;
      }
      if (hungerLevel >= 100 && happinessLevel <= 10) {
        gameover = true;
      }
      _updateHappiness();
      _checkHappinessLevel();
    });
  }

  void wintimerupdate() {
    setState(() {
      if (happinessLevel > 80) {
        wincounter += 1;
        if (wincounter >= 100) {
          win = true;
          gameover = true;
          wintimer?.cancel();
        }
      } else {
        wincounter = 0;
        wintimer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updatetimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timer is created in initState so we don't start a new one on every build.
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter your pet\'s name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) {
                changeName(text);
              },
            ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(happyColor, BlendMode.modulate),
              child:
            Image.asset('asset/dog-png-30.png'
                , height: 200, width: 200),),
            SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Happiness Level: $happinessLevel ($currentLevel) ',
                style: TextStyle(fontSize: 20.0),
              ),
              if (happinessLevel > 70) 
                Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 30)
              else if (happinessLevel >= 30)
                Icon(Icons.sentiment_satisfied, color: Colors.yellow, size: 30)
              else
                Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 30),
            ],
          ),
            SizedBox(height: 10.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
              Text(
                'Energy Level: ',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(width: 300, height: 25,
              child: LinearProgressIndicator(
      value: energy, 
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
   ),
              ),
            SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            SizedBox(height: 10.0),
            Text('Win Progress: $wincounter / 100'),
            Text(
              'Time Elapsed: $timecounter seconds',
              style: TextStyle(fontSize: 10.0),
            ),
              if (gameover && !win) 
                Text('Game Over')
              else if (win)
                Text('You Win!'),
          ],
        ),
      ),
    );
  }
}

