import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hangman/utils.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final player = AudioPlayer();
  String word = worlist[Random().nextInt(worlist.length)];
  List gussedalphabet = [];
  int points = 0;
  int status = 0;
  bool soundOn = true;
  List images = [
    'assets/images/0.png',
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png'
  ];
  playsound(String sound) async {
    if (soundOn) {
      await player.play(AssetSource('sounds/$sound'));
    }
  }

  opendialog(String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 180,
              decoration: BoxDecoration(color: Colors.purpleAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: retroStyle(25, Colors.white, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your points: $points',
                    style: retroStyle(20, Colors.white, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          status = 0;
                          gussedalphabet.clear();
                          points = 0;
                          word = worlist[Random().nextInt(worlist.length)];
                        });
                        playsound('restart.wav');
                      },
                      child: Center(
                          child: Text(
                        'Play again',
                        style: retroStyle(20, Colors.black, FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  String handelText() {
    String displayword = '';
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (gussedalphabet.contains(char)) {
        displayword += '$char ';
      } else {
        displayword += '? ';
      }
    }
    return displayword;
  }

  checkletter(String alpha) {
    if (word.contains(alpha)) {
      setState(() {
        gussedalphabet.add(alpha);
        points += 5;
      });
      playsound('correct.wav');
    } else if (status != 6) {
      setState(() {
        status += 1;
        points -= 5;
      });
      playsound('wrong.wav');
    } else {
      opendialog('You lost !');
      playsound('lost.wav');
    }
    bool isWon = true;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!gussedalphabet.contains(char)) {
        setState(() {
          isWon = false;
        });
        break;
      }
    }
    if (isWon) {
      opendialog('You Won !');
      playsound('won.wav');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(
          'Hangman',
          style: retroStyle(30, Colors.white, FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 7, top: 3),
            child: IconButton(
              onPressed: () {
                setState(() {
                  soundOn = !soundOn;
                });
              },
              icon: Icon(
                  soundOn ? Icons.volume_up_sharp : Icons.volume_off_sharp),
              color: Colors.purpleAccent,
              iconSize: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.lightBlueAccent),
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                height: 30,
                child: Center(
                  child: Text(
                    '$points Points',
                    style: retroStyle(15, Colors.black, FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image(
                width: 155,
                height: 155,
                color: Colors.white,
                fit: BoxFit.cover,
                image: AssetImage(images[status]),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${7 - status} lives left',
                style: retroStyle(18, Colors.grey, FontWeight.w700),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                handelText(),
                style: retroStyle(35, Colors.white, FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 10),
                  childAspectRatio: 1.3,
                  children: letters.map((alpha) {
                    return InkWell(
                      onTap: () => checkletter(alpha),
                      child: Center(
                        child: Text(
                          alpha,
                          style: retroStyle(20, Colors.white, FontWeight.w700),
                        ),
                      ),
                    );
                  }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
