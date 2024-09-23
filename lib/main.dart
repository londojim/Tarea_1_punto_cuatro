import 'package:flutter/material.dart';

void main() {
  runApp(ResistorCalculatorApp());
}

class ResistorCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resistor Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResistorCalculatorScreen(),
    );
  }
}

class ResistorCalculatorScreen extends StatefulWidget {
  @override
  _ResistorCalculatorScreenState createState() =>
      _ResistorCalculatorScreenState();
}

class _ResistorCalculatorScreenState extends State<ResistorCalculatorScreen> {
  int _numBands = 4;
  List<Color> _selectedColors = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.brown
  ];
  String _result = '';

  final Map<Color, int> _colorValues = {
    Colors.black: 0,
    Colors.brown: 1,
    Colors.red: 2,
    Colors.orange: 3,
    Colors.yellow: 4,
    Colors.green: 5,
    Colors.blue: 6,
    Colors.purple: 7,
    Colors.grey: 8,
    Colors.white: 9,
  };

  final Map<Color, double> _multipliers = {
    Colors.black: 1,
    Colors.brown: 10,
    Colors.red: 100,
    Colors.orange: 1000,
    Colors.yellow: 10000,
    Colors.green: 100000,
    Colors.blue: 1000000,
    Colors.purple: 10000000,
    Colors.amber: 0.1,
    Colors.white70: 0.01,
  };

  final Map<Color, String> _tolerances = {
    Colors.brown: '±1%',
    Colors.red: '±2%',
    Colors.green: '±0.5%',
    Colors.blue: '±0.25%',
    Colors.purple: '±0.1%',
    Colors.grey: '±0.05%',
    Colors.amber: '±5%',
    Colors.white70: '±10%',
  };

  void _calculateResistance() {
    double resistance = 0;
    if (_numBands == 4) {
      resistance = (_colorValues[_selectedColors[0]]! * 10 +
              _colorValues[_selectedColors[1]]!) *
          _multipliers[_selectedColors[2]]!;
    } else if (_numBands == 5) {
      resistance = (_colorValues[_selectedColors[0]]! * 100 +
              _colorValues[_selectedColors[1]]! * 10 +
              _colorValues[_selectedColors[2]]!) *
          _multipliers[_selectedColors[3]]!;
    } else if (_numBands == 6) {
      resistance = (_colorValues[_selectedColors[0]]! * 100 +
              _colorValues[_selectedColors[1]]! * 10 +
              _colorValues[_selectedColors[2]]!) *
          _multipliers[_selectedColors[3]]!;
    }

    String tolerance = _tolerances[_selectedColors[_numBands - 1]] ?? '';

    setState(() {
      _result = '${resistance.toStringAsFixed(2)} Ohms $tolerance';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text('Resistor Calculator', textAlign: TextAlign.center)),
          leading: IconButton(
            icon: new Icon(Icons.ac_unit),
            onPressed: () {},
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: _numBands,
              items: [4, 5, 6].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value Bands'),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  _numBands = newValue!;
                  _selectedColors = List.filled(_numBands, Colors.black);
                  _result = '';
                });
              },
            ),
            SizedBox(height: 20),
            ...List.generate(_numBands, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Band ${index + 1}:'),
                    SizedBox(width: 10),
                    DropdownButton<Color>(
                      value: _selectedColors[index],
                      items: _colorValues.keys.map((Color color) {
                        return DropdownMenuItem<Color>(
                          value: color,
                          child: Container(
                            color: color,
                            width: 20,
                            height: 20,
                          ),
                        );
                      }).toList(),
                      onChanged: (Color? newValue) {
                        setState(() {
                          _selectedColors[index] = newValue!;
                          _result = '';
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateResistance,
              child: const Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
