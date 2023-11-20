import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String? weightErrorText;
  String? heightErrorText;

  String _infoText = "Informe seus dados";

  void _resetField() {
    setState(() {
      weightController.clear();
      heightController.clear();
      _infoText = "Informe seus dados";
      weightErrorText = null;
      heightErrorText = null;
    });
  }

  void _calculate() {
    String weightValue = weightController.text;
    String heightvalue = heightController.text;
    weightErrorText = null;
    heightErrorText = null;

    if (weightValue.isEmpty || heightvalue.isEmpty) {
      if (weightValue.isEmpty) {
        weightErrorText = "Informe um peso em KG";
      }

      if (heightvalue.isEmpty) {
        heightErrorText = "Informe uma altura em CM";
      }
      setState(() {});

      return;
    }

    num weight = num.parse(weightController.text);
    num height = num.parse(heightController.text) / 100;

    num imc = weight / (height * height);
    
    setState(() {
      if (imc < 18.6) {
        _infoText = "Abaixo do peso (${imc.toStringAsFixed(2)})";
      } else if (imc < 24.9) {
        _infoText = "Peso ideal (${imc.toStringAsFixed(2)})";
      } else if (imc < 29.9) {
        _infoText = "Levemente acima do peso (${imc.toStringAsFixed(2)})";
      } else if (imc < 34.9) {
        _infoText = "Obesidade grau I (${imc.toStringAsFixed(2)})";
      } else if (imc < 39.9) {
        _infoText = "Obesidade grau II (${imc.toStringAsFixed(2)})";
      } else {
        _infoText = "Obesidade grau III (${imc.toStringAsFixed(2)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: _resetField,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.person_outlined,
              size: 120,
              color: Colors.green,
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 25.0,
              ),
              decoration: InputDecoration(
                errorText: weightErrorText,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
                label: const Text(
                  'Peso em (kg)',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 25.0,
              ),
              decoration: InputDecoration(
                errorText: heightErrorText,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                  ),
                ),
                label: const Text(
                  'Altura (cm)',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text(
                'Calcular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              _infoText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.green, fontSize: 25.0),
            )
          ],
        ),
      ),
    );
  }
}
