//import 'dart:async';
import 'package:flutter/material.dart';
import './main.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
void main() async {
  runApp(MaterialApp(title: 'Flutter App', home: new Scaffold(body: Registration())));
}

class Registration extends StatefulWidget {
  Registration();
  //final FirebaseApp app;
  @override
  RegistrationState createState() {
    return RegistrationState();
  }
}

class RegistrationState extends State<Registration> {
  String name = null;
  String password = null;
  bool loading = false;
   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _controllerName = new TextEditingController();
   TextEditingController _controllerPassword = new TextEditingController();
  @override
  initState() {
    super.initState();
  }

  void signUpWithEmail(username, password) async {
    if(username!=null && password!=null)
    try {
      final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email:username,
      password: password,
    );
      if (user.uid != null) {
        setState(() {
          loading = false;
        });
        _controllerName.clear();
        _controllerPassword.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } catch (e) {
      print(e.toString());
      
     setState(() {
        loading = false;
      });
      final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('The email address is already in use by another account',textAlign: TextAlign.center,));
     _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    else{
       setState(() {
        loading = false;
      });
      final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please Enter UserName and Password',textAlign: TextAlign.center,));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    // print(user);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height);
    return Scaffold(
      key: _scaffoldKey,
      body:Material(
        child: SingleChildScrollView(
      child: Container(
          height: itemHeight,
          padding: EdgeInsets.only(bottom: 80, top: 80, left: 30, right: 30),
          decoration: new BoxDecoration(color: Colors.blueAccent),
          child: Container(
            padding: EdgeInsets.only(bottom: 30, top: 30, left: 50, right: 50),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(bottom: 10),
                  child: new Image.asset('lib/assets/profile.png'),
                ),
                new Theme(
                  data: new ThemeData(
                      primaryColor: Colors.blue[700],
                      hintColor: Colors.blue[700]),
                  child: new TextField(
                    controller: _controllerName,
                    style: TextStyle(color: Colors.blue[700], fontSize: 15),
                    //autofocus: true,
                    decoration: InputDecoration(
                      //hintText: 'UserName',
                      labelText: 'UserName',
                      labelStyle:
                          TextStyle(color: Colors.blue[700], fontSize: 15),
                      //border: OutlineInputBorder(borderSide: new BorderSide(color:Colors.teal)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 10),
                ),
                new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.blue[700],
                    hintColor: Colors.blue[700],
                  ),
                  child: new TextField(
                     controller: _controllerPassword,
                    style: TextStyle(color: Colors.blue[700], fontSize: 15),
                    //autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(
                        //border: OutlineInputBorder(borderSide: new BorderSide(width: 10)),
                        //hintText: 'UserName',
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Colors.blue[700], fontSize: 15)),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 30),
                  decoration: new BoxDecoration(
                      //border: new Border.all(color: Colors.red,width: 3),
                      borderRadius: new BorderRadius.all(Radius.circular(50)),
                      color: Colors.blue[700]),
                  child: MaterialButton(
                    elevation: 5,
                    minWidth: 700,
                    padding: EdgeInsets.all(15),
                    child: loading
                        ? SizedBox(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white), 
                          ),
                          width:25,
                          height: 25,)
                        : Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                    //color: Colors.blue[700],
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                    signUpWithEmail(name, password);
                    },
                  ),
                ),
                
              ],
            )),
          )),
    )));
  }
}
