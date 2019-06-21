import 'package:flutter/material.dart';
import './main.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './main.dart';
void main(){
  runApp(MaterialApp(
    title: 'Flutter App',
    home: new Scaffold(
      body:SecondScreen()) 
    ));
}
class SecondScreen extends StatefulWidget {
  final Data data;
   SecondScreen({Key key, this.data}) : super(key: key);
  @override
    SecondScreenState createState(){
      return SecondScreenState();
    }

}
class SecondScreenState extends State<SecondScreen>{
 
  @override
    Widget build(BuildContext context) {
    
      return  Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.data.profile==null?
            Image.asset('lib/assets/profile.png',width: 200,height: 200,):
            Container(
              width:150,
              height:150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.data.profile)
                ),
              ),
              ),
            Container(
              padding: EdgeInsets.only(top:20),
              child:  Text(widget.data.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),
            ),
            Container(
                         margin: EdgeInsets.only(top:20,right: 30,left:30),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(50)),
                          color: Colors.blue[700]
                        ),
                        child:MaterialButton(
                          onPressed:()=>{
                             Navigator.pop(context)
                          },
                          child: Center(
                            child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconButton(
                                  padding: EdgeInsets.only(right:5),
                                  icon: new Icon(MdiIcons.logout,size: 30,color: Colors.white,),
                              ),      
                              Text('Log Out',style: TextStyle(fontSize: 20,color:Colors.white),)
                            ],
                          ),
                          )
                      ),)
        ],
      ),
      );
    }
}