import 'package:flutter/material.dart';

import 'package:calculator/views/button.dart';
import 'package:calculator/data/EntryModel.dart';
import 'package:calculator/data/database.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage() {}

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double num1;
  double num2;
  String output = "0";
  String _output = "0";
  String operation = "";
  bool isOpen = false;
  bool operatorAdded =
      false; // essential for continuos calculations and for changing operator multiple times
  bool continueAppendingDigits =
      true; //to reset digits for consequent & non-related calculations
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          height: isOpen ? MediaQuery.of(context).size.height : 0,
          color: Color(0xFF2C313C),
          child: buildEntryHistoryScreen(),
        ),
        Container(
          height: isOpen ? 0 : MediaQuery.of(context).size.height,
          color: Color(0xFF2C313C),
          child: buildCalculator(),
        ),
      ],
    ));
  }

  Stack buildEntryHistoryScreen() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: FutureBuilder<List<Entry>>(
                  future: DBProvider.db.getAllPastEntries(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Entry>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Entry item = snapshot.data[index];
                          return ListTile(
                              trailing: Text(
                                  "${item.num1} ${item.operation} ${item.num2} = ${item.result}",
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white)));
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              IconButton(
                icon: isOpen
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment(-0.9, -0.85),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            color: Colors.white,
            child: Text("Clear"),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {
              deleteDatabaseEntries();
            },
          ),
        ),
      ],
    );
  }

  Column buildCalculator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: new ListView(
            shrinkWrap: true,
            controller: _scrollController,
            children: <Widget>[
              Container(
                  alignment: Alignment.bottomRight,
                  padding: new EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 12.0),
                  child: new Text(
                      "${getFormatedDigits(num1.toString())} $operation",
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white))),
              GestureDetector(
                onHorizontalDragStart: (dragStartDetails) {
                  buttonPressed('DEL');
                },
                child: Container(
                    alignment: Alignment.centerRight,
                    padding: new EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 12.0),
                    child: new Text(output,
                        style: new TextStyle(
                          fontSize: 44.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
              ),
            ],
          ),
        ),
        IconButton(
          icon: isOpen
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
          color: Colors.white,
          onPressed: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
        ),
        Row(
          children: <Widget>[
            RectangularButton.color(
              buttonText: 'AC',
              onPressed: buttonPressed,
              color: Color(0xFF75BEFF),
              highlightColor: Color(0xFFAA0D2FF),
            ),
            RectangularButton.color(
              buttonText: 'C',
              onPressed: buttonPressed,
              color: Color(0xFF75BEFF),
              highlightColor: Color(0xFFAA0D2FF),
            ),
            RectangularButton.color(
              buttonText: 'DEL',
              onPressed: buttonPressed,
              color: Color(0xFF75BEFF),
              highlightColor: Color(0xFFAA0D2FF),
            ),
            RectangularButton.color(
              buttonText: '/',
              onPressed: buttonPressed,
              color: Color(0xFF007ACC),
              highlightColor: Color(0xFF0059DFF),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            RectangularButton(buttonText: '7', onPressed: buttonPressed),
            RectangularButton(buttonText: '8', onPressed: buttonPressed),
            RectangularButton(buttonText: '9', onPressed: buttonPressed),
            RectangularButton.color(
              buttonText: '*',
              onPressed: buttonPressed,
              color: Color(0xFF007ACC),
              highlightColor: Color(0xFF0059DFF),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            RectangularButton(buttonText: '4', onPressed: buttonPressed),
            RectangularButton(buttonText: '5', onPressed: buttonPressed),
            RectangularButton(buttonText: '6', onPressed: buttonPressed),
            RectangularButton.color(
              buttonText: '-',
              onPressed: buttonPressed,
              color: Color(0xFF007ACC),
              highlightColor: Color(0xFF0059DFF),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            RectangularButton(buttonText: '1', onPressed: buttonPressed),
            RectangularButton(buttonText: '2', onPressed: buttonPressed),
            RectangularButton(buttonText: '3', onPressed: buttonPressed),
            RectangularButton.color(
              buttonText: '+',
              onPressed: buttonPressed,
              color: Color(0xFF007ACC),
              highlightColor: Color(0xFF0059DFF),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            RectangularButton.multispan(
              buttonText: '0',
              onPressed: buttonPressed,
              span: 2,
            ),
            RectangularButton(buttonText: '.', onPressed: buttonPressed),
            RectangularButton.color(
              buttonText: '=',
              onPressed: buttonPressed,
              color: Color(0xFF235997),
              highlightColor: Color(0xFF12447B),
            ),
          ],
        ),
      ],
    );
  }

  void buttonPressed(String pressedButton) {
    //print("pressed button $pressedButton");
    _output = output;
    if (pressedButton == "AC") {
      num1 = 0;
      num2 = 0;
      operation = "";
      _output = "0";
    } else if (pressedButton == "C") {
      if (operation == "")
        num1 = 0;
      else
        num2 = 0;
      _output = "0";
    } else if (pressedButton == "+" ||
        pressedButton == "-" ||
        pressedButton == "/" ||
        pressedButton == "*") {
      if (operatorAdded && _output == "0") {
        //allows changing of operator
        operation = pressedButton;
        setState(() {});
        return;
      }
      if (num1 != null && operatorAdded) {
        performCalc();
      }

      num1 = double.parse(_output); // handles contiguous calculation
      _output = "0";
      operation = pressedButton;
      operatorAdded = true;
      continueAppendingDigits = true;
    } else if (pressedButton == ".") {
      if (!_output.contains(".")) {
        //should not add this to the else if %imp%
        // eliminated multiple fractional parts
        print("No . found so adding .");
        _output = _output + pressedButton;
      }
    } else if (pressedButton == "=") {
      performCalc();
    } else if (pressedButton == "DEL") {
      int length = _output.length;
      _output = length > 1 ? _output.substring(0, _output.length - 1) : "0";
    } else {
      if (continueAppendingDigits) {
        _output = removeLeadingZeroes(_output + pressedButton);
      } else {
        _output = pressedButton;
        continueAppendingDigits = true;
      }
    }
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    setState(() {
      output = _output;
    });
  }

  void performCalc() {
    num2 = double.parse(_output);
    print("performing $num1 $operation $num2");
    switch (operation) {
      case '+':
        {
          _output = (num1 + num2).toString();
          break;
        }
      case '-':
        {
          _output = (num1 - num2).toString();
          break;
        }
      case '/':
        {
          _output =
              num2 != 0 ? (num1 / num2).toString() : 0; // handles division by 0
          break;
        }
      case '*':
        {
          _output = (num1 * num2).toString();
          break;
        }
    }
    _output = getFormatedDigits(_output);

    addEntryToDatabase(num1, num2, operation, _output);

    num1 = null;
    num2 = null;
    operation = "";
    continueAppendingDigits = false;
    operatorAdded = false;
  }

  String getFormatedDigits(String number) {
    //removes fractional part when not necessary
    String formattedDigits = number;
    try {
      if (number.contains(".") && number.indexOf('.') != number.length - 1) {
        double temp = double.parse(number);
        formattedDigits =
            (temp.floor() == temp) ? temp.floor().toString() : temp.toString();
      } else {
        print("inside else");
        formattedDigits = int.parse(number).toString();
      }
    } catch (e) {
      print("nothing imp to catch");
    }
    return formattedDigits == "null" ? "0" : formattedDigits;
  }

  String removeLeadingZeroes(String number) {
    if (number.contains('.')) {
      int startIndex = 0;
      while (number[startIndex] == '0') {
        startIndex++;
      }
      startIndex = number[startIndex] == '.' ? startIndex - 1 : startIndex;
      return number.substring(startIndex);
    } else {
      return int.parse(number).toString();
    }
  }

  Future addEntryToDatabase(
      double num1, double num2, String operation, String _output) async {
    if (operation != "") {
      //eliminates 0 0=0 upon pressing = many times
      Entry newEntry = new Entry(
          num1: getFormatedDigits(num1.toString()),
          num2: getFormatedDigits(num2.toString()),
          operation: operation,
          result: _output);
      await DBProvider.db.newEntry(newEntry);
      setState(() {});
    }
  }

  Future deleteDatabaseEntries() async {
    print("deleting all entries");
    await DBProvider.db.deleteAllEntries();
    setState(() {});
  }
}

//TODO
//1.Comma separator
//2.Support for complex calculations

