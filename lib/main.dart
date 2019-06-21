import 'dart:async';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './secondScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import './registration.dart';

void main() async {
  runApp(MaterialApp(title: 'Flutter App',
   home: new Scaffold(body: Login()),
   debugShowCheckedModeBanner:false
   ));
}

class Login extends StatefulWidget {
  Login();
  //final FirebaseApp app;
  @override
  LoginState createState() {
    return LoginState();
  }
}

class Data {
  String name;
  String profile;
  Data({this.name, this.profile});
}

class LoginState extends State<Login> {
  String name = null;
  String password = null;
  bool loading = false;
  bool facebookloading = false;
  bool googleloading = false;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _controllerName = new TextEditingController();
   TextEditingController _controllerPassword = new TextEditingController();
  @override
  initState() {
    super.initState();
  }

  void getSignedInAccount() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        await _firebaseAuth.signInWithCredential(credential);
    //print("signed in " + user.displayName);
    //print("image : "+user.photoUrl);
    try {
       setState(() {
          googleloading = false;
        });
      final data = Data(name: user.displayName, profile: user.photoUrl);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondScreen(data: data)),
      );
    } catch (e) {
        setState(() {
          googleloading = false;
        });
      final snackBar = SnackBar(
          backgroundColor: Colors.red, content: Text('Google Login Cancel'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        setState(() {
          facebookloading = false;
        });
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('Facebook  Login Error..'));
        Scaffold.of(context).showSnackBar(snackBar);
        //onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
      setState(() {
          facebookloading = false;
        });
        print("CancelledByUser");
        // onLoginStatusChanged(false);
        final snackBar = SnackBar(
            backgroundColor: Colors.red, content: Text('Login Cancel By User'));
        Scaffold.of(context).showSnackBar(snackBar);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
         setState(() {
          facebookloading = false;
        });
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${facebookLoginResult.accessToken.token}');
        var profile = json.decode(graphResponse.body);
        final data = Data(
            name: profile['name'], profile: profile['picture']['data']['url']);
        print(profile);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondScreen(data: data)),
        );
        // onLoginStatusChanged(true);
        break;
    }
  }

  loginWithEmail(username, password) async {
    // final FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
    //   email:username,
    //   password: password,
    // );
    try {
      final FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      if (user.uid != null) {
        setState(() {
          loading = false;
          name=null;
          password=null;
        });
        _controllerName.clear();
        _controllerPassword.clear();
        var data = Data(name: user.email, profile: null);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondScreen(data: data)),
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
      final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please Check UserName and Password',textAlign: TextAlign.center,));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    // print(user);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height);
    return (Material(
        child: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(bottom: 10, top: 30, left: 30, right: 30),
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
                            'Login',
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
                      loginWithEmail(name, password);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: new BoxDecoration(
                      //border: new Border.all(color: Colors.red,width: 3),
                      borderRadius: new BorderRadius.all(Radius.circular(50)),
                      color: Colors.blue[700]),
                  child: MaterialButton(
                      minWidth: 200,
                      onPressed: () {
                         setState(() {
                         facebookloading=true;
                      });
                        initiateFacebookLogin();
                        },
                      child: Center(
                        child: facebookloading
                        ? SizedBox(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white), 
                          ),
                          width:25,
                          height: 25,)
                          : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Icon(MdiIcons.facebookBox),
                            new IconButton(
                              padding: EdgeInsets.only(right: 5),
                              icon: new Icon(
                                MdiIcons.facebookBox,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Facebook',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: new BoxDecoration(
                      //border: new Border.all(color: Colors.red,width: 3),
                      borderRadius: new BorderRadius.all(Radius.circular(50)),
                      color: Colors.blue[700]),
                  child: MaterialButton(
                      minWidth: 200,
                      onPressed: () {
                         setState(() {
                         googleloading=true;
                      });
                        getSignedInAccount();
                      },
                      child: Center(
                        child:  googleloading
                        ? SizedBox(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white), 
                          ),
                          width:25,
                          height: 25,)
                          :Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Icon(MdiIcons.facebookBox),
                            new IconButton(
                              padding: EdgeInsets.only(right: 5),
                              icon: new Icon(
                                MdiIcons.google,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Google',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: new BoxDecoration(
                      //border: new Border.all(color: Colors.red,width: 3),
                      borderRadius: new BorderRadius.all(Radius.circular(50)),
                      color: Colors.blue[700]),
                  child: MaterialButton(
                      minWidth: 200,
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Registration()),
                          );
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SignUp',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      )),
                )
              ],
            )),
            
          )),
    )));
  }
}
