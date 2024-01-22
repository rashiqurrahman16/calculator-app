import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';


class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String number1=""; // . 0-9
  String operand=""; // . +-*/
  String number2=""; // . 0-9


  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          //output
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty?"0"
                    :"$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),



            //buttons
            Wrap(
              children: Btn.buttonValues.map(
                    (value) => SizedBox(          //Using if else statement for 0 button
                        width:value==Btn.n0
                            ?screenSize.width/2
                            :screenSize.width/4,
                        height: screenSize.width/5,
                        child: buildButton(value)
                    ),
              ).toList(),
            ),
          ],

        ),
      ),
    );
  }

  //#####
  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge, //splash screen effect wont go gout side the border of buuton
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
              child: Text(value,
                style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              )
          ),
        ),
      ),
    );
  }

  // ########
  //function
  void onBtnTap(String value){
    if(value == Btn.del) {
      delete();
      return;
    }
    if(value == Btn.clr) {
      clearAll();
      return;
    }
    if(value == Btn.per) {
      convertToPercentage();
      return;
    }
    if(value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  // ######
  // delete one from the end
  void delete(){
    if(number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    }
    else if (operand.isNotEmpty){
      operand = "";
    }
    else if(number1.isNotEmpty){
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  // ######
  // clear all output
  void clearAll(){
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // ######
  // clear all output
  void convertToPercentage(){
    // ex: 434+324
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
      // calculate before conversion
      //TODO
      // final res = number1 operand number2;
      // number1 = res;
    }
    if(operand.isNotEmpty){
      //cannot be converted
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void calculate(){
    // ex: 434+324
    if(number1.isEmpty) return;
    if(operand.isEmpty) return;
    if(number2.isEmpty) return;

    double num1=double.parse(number1);
    double num2=double.parse(number2);

    var result = 0.0;
    switch (operand){
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.substract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = "$result";
    });
  }



  // ########
  // Apends Value to the end
  void appendValue(String value){
    //if is operand and not"."
    if(value!=Btn.dot&&int.tryParse(value)==null){
      //operand pressed
      if(operand.isNotEmpty&&number2.isNotEmpty){
        //TODO calculate the equation

      }
      operand = value;
    }
    //assign value to number1 variable
    else if(number1.isEmpty || operand.isEmpty){
      // check if value is "." ex: number1 = "1.2"
      if(value==Btn.dot && number1.contains(Btn.dot))return;
      if(value==Btn.dot && (number1.isEmpty || number1==Btn.n0)) {
        //ex: number1 ="" | "0"
        value = "0.";
      }
      number1 += value;
    }
    //assign value to number2 variable
    else if(number2.isEmpty || operand.isNotEmpty){
      // check if value is "." ex: number1 = "1.2"
      if(value==Btn.dot && number2.contains(Btn.dot))return;
      if(value==Btn.dot && (number2.isEmpty || number2==Btn.n0)) {
        //ex: number2 ="" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }
}

  // ########
  // Function For Color
  Color getBtnColor(value){
    //Using If else statement for button colors
    return [
      Btn.del,
      Btn.clr,
      Btn.per,
    ].contains(value) ? const Color.fromRGBO(90, 89, 107, 100)
        :[
          Btn.multiply,
          Btn.add,
          Btn.substract,
          Btn.divide,
          Btn.calculate
    ].contains(value) ? const Color.fromRGBO(18, 6, 157, 100)
    :const Color.fromRGBO(46, 48, 56, 100);
  }

