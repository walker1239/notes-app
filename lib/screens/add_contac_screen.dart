import 'dart:convert';

import 'package:clinicapp/data/user.dart';
import 'package:clinicapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AddScreen extends StatefulWidget {
  final User user;
  const AddScreen ({this.user});
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final titleController= TextEditingController();
  final descriptionController= TextEditingController();
  Future<bool> registrar() async{
    var url = 'http://192.168.2.101:8085/note';
    Map<String, String> headers = {
      'Authorization': widget.user.userApi
    };
    var body = jsonEncode({
    'title': titleController.text.toString(),
    'description':descriptionController.text.toString()});
    var response = await http.post(
      url,
      headers:headers,
      body:body 
    );
    final resp = json.decode(response.body);

    if (resp['success']!=null || resp['success']!='is not true') {
      //Token is nested inside data field so it goes one deeper.
      final token =resp['code'];
      print("succes");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(token=="correcto"){
        Fluttertoast.showToast(
          msg: "Guardando",
          toastLength: Toast.LENGTH_LONG,
        );
        return true;
      }
      else{
        Fluttertoast.showToast(
          msg: resp['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        return false;
      }
      
    }
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    return false;
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Titulo',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: titleController,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              hintText: 'Ingrese sus nombres',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Descripción',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 100.0,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: descriptionController,
            
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.people,
                color: Colors.white,
              ),
              hintText: 'Ingrese sus Apellidos',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async{
          print('Register Button Pressed');
          var value = await registrar();
          if(value == true) {
            Navigator.pop(context,(){
              setState(() {
                
              });
            });
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Registrar',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar contactos"),
        backgroundColor: Colors.blue[200],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*Text(
                        'ClinicApp',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),*/
                      _buildNameTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildLastNameTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildAddBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
