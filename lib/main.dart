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

  void changeName(String name) {
    setState(() {
      petName = name;
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel += 20; //swapped these values since lower hunger should increase happiness
    } else {
      happinessLevel -= 10;
    }
    if (happinessLevel > 70) {
      happyColor = Colors.green;
    } else if (happinessLevel >= 30) {
      happyColor = Colors.yellow;
    } else {
      happyColor = Colors.red;
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

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 16.0),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(happyColor, BlendMode.modulate),
              child:
            Image.asset('asset/dog-png-30.png'
                , height: 200, width: 200),),
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}

