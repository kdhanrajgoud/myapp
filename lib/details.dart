import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  SharedPreferences sharedPreferences;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: const Color(0xFF915FB5),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(colors: [const Color(0xFF915FB5),const Color(0xFFCA436B)],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              stops: [0.0,1.0],
              tileMode: TileMode.clamp),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : getListView(),

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}

List<Request> getDetailsList() {
  List<Request> requests = [];
  requests.add(Request('Groceries', '2020-02-01', 'Approved'));
  requests.add(Request('Gym', '2020-02-05', 'Declined'));
  requests.add(Request('Travel', '2020-04-01', 'Declined'));
  requests.add(Request('Hospital', '2020-05-01', 'Approved'));

  return requests;
}

Widget getListView() {
  var items = getDetailsList();

  var listView = ListView.builder(itemCount: items.length,itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].type, style: TextStyle(color: Colors.white, fontSize: 20.0),),
      subtitle: Text( items[index].date),
      dense: true,
      leading:  items[index].status =='Approved' ? Icon(Icons.check_circle, color: Colors.lightGreenAccent,) : Icon(Icons.remove_circle, color: Colors.red[900],)
    );
  });
  return listView;
}

class Request {
  String type;
  String date;
  String status;

  Request(this.type, this.date,this.status);
}
