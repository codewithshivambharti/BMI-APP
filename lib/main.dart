import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '💪 BMI Calculator',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Arial'),
      home: BMICalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage>
    with TickerProviderStateMixin {
  double height = 170.0; // cm
  double weight = 70.0; // kg

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double calculateBMI() {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String getBMIEmoji(double bmi) {
    if (bmi < 18.5) return '😟';
    if (bmi < 25) return '😊';
    if (bmi < 30) return '😐';
    return '😰';
  }

  Color getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  List<Color> getBMIGradient(double bmi) {
    if (bmi < 18.5) return [Colors.blue.shade300, Colors.blue.shade600];
    if (bmi < 25) return [Colors.green.shade300, Colors.green.shade600];
    if (bmi < 30) return [Colors.orange.shade300, Colors.orange.shade600];
    return [Colors.red.shade300, Colors.red.shade600];
  }

  void resetValues() {
    setState(() {
      height = 170.0;
      weight = 70.0;
    });
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  void onSliderChanged() {
    _pulseController.forward().then((_) => _pulseController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    double bmi = calculateBMI();
    String category = getBMICategory(bmi);
    String emoji = getBMIEmoji(bmi);
    List<Color> gradientColors = getBMIGradient(bmi);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        '💪 BMI CALCULATOR',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Track your health with style!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                // BMI Result Card
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: getBMIColor(bmi).withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(emoji, style: TextStyle(fontSize: 50)),
                            SizedBox(height: 10),
                            Text(
                              '${bmi.toStringAsFixed(1)}',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'BMI',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40),

                // Height Slider
                _buildSliderCard(
                  'Height',
                  '📏',
                  height,
                  100,
                  220,
                  '${height.round()} cm',
                  Colors.blue,
                  (value) {
                    setState(() {
                      height = value;
                    });
                    onSliderChanged();
                  },
                ),

                SizedBox(height: 25),

                // Weight Slider
                _buildSliderCard(
                  'Weight',
                  '⚖️',
                  weight,
                  30,
                  150,
                  '${weight.round()} kg',
                  Colors.green,
                  (value) {
                    setState(() {
                      weight = value;
                    });
                    onSliderChanged();
                  },
                ),

                SizedBox(height: 40),

                // Reset Button
                Container(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: resetValues,
                    icon: Icon(Icons.refresh, size: 24),
                    label: Text(
                      'RESET VALUES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.5),
                      ),
                      elevation: 8,
                      shadowColor: Colors.purple.shade200,
                    ),
                  ),
                ),

                Spacer(),

                // BMI Guide
                _buildBMIGuide(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard(
    String title,
    String emoji,
    double value,
    double min,
    double max,
    String displayValue,
    Color color,
    Function(double) onChanged,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(emoji, style: TextStyle(fontSize: 15)),
                  SizedBox(width: 5),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(0.2),
              thumbColor: color,
              overlayColor: color.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIGuide() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 BMI Categories:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBMICategory('😟 Under', '<18.5', Colors.blue),
              _buildBMICategory('😊 Normal', '18.5-25', Colors.green),
              _buildBMICategory('😐 Over', '25-30', Colors.orange),
              _buildBMICategory('😰 Obese', '>30', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBMICategory(String label, String range, Color color) {
    return Column(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          range,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
