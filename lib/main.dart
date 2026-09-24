import 'package:flutter/material.dart';
import 'screens/home.dart';
void main(){
  runApp (const SmartSaha());
}
class SmartSaha extends StatelessWidget{
  const SmartSaha({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      title: "Smart saha training",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: const Home()
    );
  }
}