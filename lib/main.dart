import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator/custom_button.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const SimpleCalculator());
}

class SimpleCalculator extends StatelessWidget {
  const SimpleCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<List<String>> buttonsText = [
    ['C'],['DEL'],['%','%'],['/','\u00f7'],
    ['7'],['8'],['9'],['*','\u00d7'],
    ['4'],['5'],['6'],['-','-'],
    ['1'],['2'],['3'],['+','+'],
    ['00'],['0'],['.'],['=','='],
  ];
  String mathExpr = '';
  String showingMathExpr = ''; 
  String answer = '';
  @override
  Widget build(BuildContext context) {
    var width =MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(showingMathExpr,style: const TextStyle(fontSize: 30,color: Colors.white)),
            )
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(5),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ 
                Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.fromLTRB(0,0,7,0),
                  child: FittedBox(child: Text(answer,style: const TextStyle(fontSize:50,color: Colors.white),)),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: GridView.builder(
                    itemCount: 20,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 90,
                    ),
                    shrinkWrap: true, 
                    itemBuilder: (context, index) {
                      if (index==0){
                        return CustomButton(label:buttonsText[index][0],color: Colors.blue,textColor: Colors.white,fontSize: 20.0,
                          onTapped: (){
                            setState(() {
                              mathExpr='';
                              showingMathExpr='';
                              answer='';
                            });
                          },
                        );
                      }else if(index==1){
                        return CustomButton(label:buttonsText[index][0],color: Colors.red,textColor: Colors.white,fontSize: 20.0,
                          onTapped: (){
                            setState(() {
                              if(mathExpr.length<61){
                                mathExpr=mathExpr.substring(0,mathExpr.length-1);
                                showingMathExpr=showingMathExpr.substring(0,showingMathExpr.length-1);
                              }
                              
                            });
                          },
                        );
                      }else if([4,5,6,8,9,10,12,13,14,16,17,18].contains(index)){
                        return CustomButton(label:buttonsText[index][0],color: Colors.white,textColor: Colors.black ,fontSize: 20.0,
                          onTapped: (){
                            setState(() {
                              if(mathExpr.length<61){
                                mathExpr+=buttonsText[index][0];
                                showingMathExpr+=buttonsText[index][0];
                              }
                            });
                          },
                        );
                      }else if(index==19){
                        return CustomButton(label:buttonsText[index][1],color: Colors.green,textColor: Colors.white,fontSize: 25.0,
                          onTapped: (){
                            setState(() {
                              calculate(mathExpr);
                            });
                          },
                        );
                      }else{
                        return CustomButton(label:buttonsText[index][1],color: Colors.orange,textColor: Colors.white,fontSize: 25.0,
                          onTapped: (){
                            setState(() {
                              if(mathExpr.length<61){
                                if(mathExpr.length!=0 ){
                                  if(['*','+','/','%','-'].contains(mathExpr[mathExpr.length-1])){
                                    mathExpr=mathExpr.substring(0,mathExpr.length-1);
                                    showingMathExpr=showingMathExpr.substring(0,showingMathExpr.length-1);
                                  }
                                  mathExpr+=buttonsText[index][0];
                                  showingMathExpr+=buttonsText[index][1];
                                }else{
                                  if(!['*','+','/','%'].contains(buttonsText[index][0])){
                                    mathExpr+=buttonsText[index][0];
                                    showingMathExpr+=buttonsText[index][1];
                                  }
                                }
                              }
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void calculate(String mathExpr){
    if(mathExpr!="" ){
      if(['*','+','/','-','%'].contains(mathExpr[mathExpr.length-1])){
        mathExpr=mathExpr.substring(0,mathExpr.length-1);
      }
      Parser p = Parser();
      Expression exp = p.parse(mathExpr);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      final formatter = NumberFormat("#,###.#########", "en_US");
      final formattedString = formatter.format(eval);
      answer= formattedString;
    }
  }
}
