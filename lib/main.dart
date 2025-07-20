import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  
  double bmi = 0.0;
  String category = '';
  String result = '';

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      // Convert height from cm to meters
      height = height / 100;
      
      setState(() {
        bmi = weight / (height * height);
        
        if (bmi < 18.5) {
          category = 'Underweight';
        } else if (bmi >= 18.5 && bmi < 25) {
          category = 'Normal weight';
        } else if (bmi >= 25 && bmi < 30) {
          category = 'Overweight';
        } else {
          category = 'Obese';
        }
        
        result = 'Your BMI is ${bmi.toStringAsFixed(1)}\nCategory: $category';
      });
    } else {
      setState(() {
        result = 'Please enter valid height and weight';
      });
    }
  }

  void clearFields() {
    heightController.clear();
    weightController.clear();
    setState(() {
      bmi = 0.0;
      category = '';
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            
            // Height Input
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Weight Input
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Calculate Button
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Calculate BMI',
                style: TextStyle(fontSize: 18),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Clear Button
            OutlinedButton(
              onPressed: clearFields,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Clear',
                style: TextStyle(fontSize: 16),
              ),
            ),
            
            SizedBox(height: 32),
            
            // Result Display
            if (result.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            SizedBox(height: 24),
            
            // BMI Categories Reference
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BMI Categories:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('• Underweight: Below 18.5'),
                  Text('• Normal weight: 18.5 - 24.9'),
                  Text('• Overweight: 25.0 - 29.9'),
                  Text('• Obese: 30.0 and above'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
