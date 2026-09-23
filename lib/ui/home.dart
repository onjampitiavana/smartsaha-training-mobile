import 'package:flutter/material.dart';
class Home extends StatelessWidget{
    const Home ({super.key});
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar:AppBar(
            title: const Text ("SmartSaha Training"),
        ), body: Center(
            child: Column(
                mainAxisAlignment : MainAxisAlignment.center,
                children: const[
            Text ("SmartSaha Training") ,
            Text ("Santatra"),
            Text("23 septembre 2026"),
                ],
            ),
            
        ),);
    }
}