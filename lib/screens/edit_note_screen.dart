import 'dart:convert';

import 'package:clinicapp/data/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class EditScreen extends StatefulWidget {
  final Notes note;
  const EditScreen ({this.note});
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController titleController;
  TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(text: widget.note.title);
    descriptionController = new TextEditingController(text: widget.note.description);
  }
  Future<bool> guardar() async{
    var url = 'http://192.168.2.101:8085/notes/${widget.note.idNote.toString()}';
    var body = jsonEncode({
    'title': titleController.text.toString(),
    'description':descriptionController.text.toString()});
    var response = await http.put(
      url,
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

  Future<bool> eliminar() async{
    var url = 'http://192.168.2.101:8085/notes/${widget.note.idNote.toString()}';
    var response = await http.delete(
      url,
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

   Widget _buildTitleTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Titulo',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.text,
            controller: titleController,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.text_fields,
                color: Colors.black,
              ),
              hintText: 'Ingresa el titulo',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Descripción',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: descriptionController,
            
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.text_fields,
                color: Colors.black,
              ),
              hintText: 'Ingresa la descripción',
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
          var value = await guardar();
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
          'Guardar',
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

  Widget _buildDeleteBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async{
          print('Eliminar');
          var value = await eliminar();
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
          'Eliminar',
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
        title: Text("Nota"),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
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
                      _buildTitleTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildDescriptionTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildAddBtn(),

                      _buildDeleteBtn(),
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
