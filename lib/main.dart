
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './util/utils.dart' as util;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Klimatic(),
    )
  );
}
class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;

  Future _goToNextScreen(BuildContext context)async{
    Map result= await Navigator.of(context).push(
      new MaterialPageRoute(builder:(BuildContext context){
        return ChangeCity();
      } )
    );
    if (result != null&& result.containsKey('enter')) {
      
        _cityEntered= result['enter'];
    }
  }
  void showStuff() async{
     Map data = await getWeather(util.appId, util.cityName);
     print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Klimatic'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton
        (icon:Icon(Icons.menu),
        onPressed: (){
          _goToNextScreen(context);}
        ),
        ]
      ),

      body: new Stack(
        children: <Widget>[
            new Image.asset('images/umbrella.png',
                   width: 499.0,
                   height: 1200.0,
                   fit: BoxFit.fill,),
            
              new Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0.0,20.0,10.0,0.0 ),
                child: new Text(
            
                  '$_cityEntered',style: new TextStyle(
                     fontSize:32.9,
                     fontStyle:FontStyle.italic,
                     color: Colors.white,
                     ),
                     ),
              ),
            Container(
              alignment: Alignment.center,
              child: new Image.asset('images/rain.png',
                      ),
            ),
            new Container(
              margin: EdgeInsets.fromLTRB(0.0,356.5,55.0, 0.0),
              child: updateTempWidget('India')),
    
        ]
      ),
      );
  }
    Future<Map> getWeather(String appId,cityName)async{
   Uri apiUrl= Uri.parse('http://api.openweathermap.org/data/2.5/weather?'
                               'q=$cityName&&appid=${util.appId}&units=metric');
    http.Response response= await http.get(apiUrl);
    return json.decode(response.body);
  }
  Widget updateTempWidget(String cityName){
    return new FutureBuilder(
      future:getWeather(util.appId,cityName),
      builder:(BuildContext context,AsyncSnapshot<Map> snapshot){
        if (snapshot.hasData) {
           Map content=snapshot.data;
           return new Container(
             child: new Column(
               children: <Widget>[
                 new ListTile(
                 title: new Text(content["main"]["temp"].toString(),
                 style: new TextStyle(
                   fontSize:50.5,
                   fontStyle:FontStyle.normal,
                    color: Colors.white
                 ))
                 )
               ]
             )
           );
        }else{
          return new Container();
        }
      });
  }
}
 var _cityFieldController = new TextEditingController();
class ChangeCity extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
            child: new Image.asset('images/snow.png',
            width:490.0,
            height:500.0,
            )
          ),
          
          new ListView(
            children:<Widget> [
              new ListTile(
                title:new TextField(
                  controller:_cityFieldController,
                  decoration: new InputDecoration(
                    labelText:'Enter City'
                  ),
                ),),
              new ListTile(
                  title: new ElevatedButton(onPressed:(){
                    Navigator.pop(context,{
                      'enter': _cityFieldController.text
                    });
                  } ,
                 child: new Text('Get Weather')),
              )
           
              

              
            ],
          )
        
         ] ),
    );
  }
}