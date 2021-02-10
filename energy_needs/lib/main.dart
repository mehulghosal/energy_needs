import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:gradient_widgets/gradient_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy needs',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'why are there so many titles'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  bool lightTheme = false;
  // Color currentColor = Colors.limeAccent;
  final _formKey = GlobalKey<FormState>();


  int age = 1;
  double height = 1.0;
  double weight = 1.0;
  double activityLevel = .3;

  double basal=0.0;
  double exerciseExpenditure = 0.0;
  double thermalFood = 0.0;

  double calNeeds = 0.0;

  double calMin=0.0;
  double calMaintain=0.0;
  double calMax=0.0;

  double protein=0.0;

  bool val = false;

  bool slowMetabolism = false;

  bool metric = false;
  var heightHint = 'Enter your height in inches';
  var weightHint = 'Enter your weight in pounds';

  //false for female
  bool gender = false;

  // void changeColor(Color color) => setState(() => currentColor = color);

  void _calculate() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.


      if(metric){
        weight = weight * 2.20462;
        height = height * 39.37 / 100;
      }

      if(!gender){
        basal = (247 - (2.67*age) + (401.5*(height)) + (8.6*(weight))); //female formula
      }
      else{
        basal = (293 - (3.8*age) + (456.4*(height)) + (10.12*(weight))); //male formula
      }
      exerciseExpenditure = basal* activityLevel;
      thermalFood = (basal+exerciseExpenditure)*.1;
      calNeeds = basal + exerciseExpenditure + thermalFood;

      // protein = 1.6*weight;
      if(slowMetabolism){
        calNeeds*=0.9;
      }

    });
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme ? ThemeData.light() : ThemeData.dark(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: GestureDetector(
              child: Text('Energy needs'),
              onDoubleTap: () => setState(() => lightTheme = !lightTheme),
            ),
            bottom: TabBar(
              tabs: <Widget>[
                const Tab(text: 'Calculator'),
                const Tab(text: 'Resources'),
                // const Tab(text: 'Block'),
              ],
            ),
          ),
          body: TabBarView( //adding more widgets to the child array of tabbar makes it think theyre more tabs
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Wrap(
                          runSpacing:-25,
                          children: <Widget>[
                            RadioListTile(
                              title: const Text("Male"),
                              value: true,
                              groupValue: gender,
                              activeColor: Colors.blueGrey,
                              onChanged: (bool value){
                                setState(() {
                                  gender=value;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text("Female"),
                              value: false,
                              groupValue: gender,
                              activeColor: Colors.blueGrey,
                              onChanged: (bool value){
                                setState(() {
                                  gender=value;
                                });
                              },
                            ),
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: slowMetabolism,
                              activeColor: Colors.blueGrey,
                              onChanged: (bool value){
                                setState(() {
                                  slowMetabolism=value;
                                });
                              },
                            ),
                            Text(
                              "Check for slow metabolism."
                            )
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: metric,
                              activeColor: Colors.blueGrey,
                              onChanged: (bool value){
                                setState(() {
                                  metric=value;
                                  if(metric){
                                    heightHint = 'Enter your height in centimeters';
                                    weightHint = 'Enter your weight in kilograms';
                                  }
                                  else{
                                    heightHint = 'Enter your height in inches';
                                    weightHint = 'Enter your weight in pounds';
                                  }
                                });
                              },
                            ),
                            Text(
                                "Check if using metric units."
                            )
                          ],
                        ),

                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your age',
                          ),
                          validator: (a) {
                            if (!isNumeric(a)) {
                              return 'Please enter a valid age';
                            }
                            age = int.parse(a);
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: heightHint,
                          ),
                          validator: (h) {
                            if (!isNumeric(h)) {
                              return 'Please enter a valid height';
                            }

                            height = int.parse(h)/39.37;
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: weightHint,
                          ),
                          validator: (w) {
                            if (!isNumeric(w)) {
                              return 'Please enter a valid weight';
                            }
                            weight = int.parse(w)/2.20462;
                            return null;
                          },
                        ),

                        Wrap(
                          runSpacing: -20,
                          children: <Widget>[
                            //activity level form
                            RadioListTile(
                              title: const Text("Sedentary Activity"),
                              value: .3,
                              groupValue: activityLevel,
                              activeColor: Colors.blueGrey,
                              onChanged: (double value){
                                setState(() {
                                  activityLevel=value;
                                });
                              },
                            ),
                            // SizedBox(height:1),
                            RadioListTile(
                              title: const Text("Lightly Active"),
                              value: .5,
                              groupValue: activityLevel,
                              activeColor: Colors.blueGrey,
                              onChanged: (double value){
                                setState(() {
                                  activityLevel=value;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text("Moderate Activity"),
                              value: .6,
                              groupValue: activityLevel,
                              activeColor: Colors.blueGrey,
                              onChanged: (double value){
                                setState(() {
                                  activityLevel=value;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text("Very Active"),
                              value: .9,
                              groupValue: activityLevel,
                              activeColor: Colors.blueGrey,
                              onChanged: (double value){
                                setState(() {
                                  activityLevel=value;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text("Extremely Active"),
                              value: 1.2,
                              groupValue: activityLevel,
                              activeColor: Colors.blueGrey,
                              onChanged: (double value){
                                setState(() {
                                  activityLevel=value;
                                });
                              },
                            ),
                          ],
                        ),



                      ],
                    ),
                  ),

                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: const Text('calculate'),
                    color: Colors.blueGrey,
                    textColor: Colors.black54,
                  ),

                  Text(
                    "Calorie Requirements: " +  calNeeds.round().toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "Recommended protein (in grams): " + (1.2*weight).round().toString() + "-" + (1.6*weight).round().toString(),
                    style: TextStyle(fontSize: 18),
                  ),

                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("example resource")
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
