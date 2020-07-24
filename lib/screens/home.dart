import 'dart:convert';
import 'dart:io';

import 'package:clinicapp/config/palette.dart';
import 'package:clinicapp/data/notes.dart';
import 'package:clinicapp/data/user.dart';
import 'package:clinicapp/db/notes.dart';
import 'package:clinicapp/screens/add_contac_screen.dart';
import 'package:clinicapp/screens/test_flare.dart';
import 'package:flutter/material.dart';
import 'package:clinicapp/data/data.dart';
import 'package:clinicapp/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'edit_note_screen.dart';

class Home extends StatefulWidget {
  final User user;
  const Home ({this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool realized=false;

  Future<List<Notes>> getNotes() async{
    await DatabaseNotes.db.deleteNotes();
    var url = 'http://192.168.2.101:8085/user/notes';
    Map<String, String> headers = {
      'Authorization': widget.user.userApi
    };
    var response = await http.get(url,
      headers:headers,
    );
    final jsonData = json.decode(response.body);
    print(jsonData);

    if (response.statusCode == 200) {
      //Token is nested inside data field so it goes one deeper.
      var token;
      print("succes");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(jsonData!=null) { 
        int index=jsonData.length;
        for(var i=0;i<index;i++){
          Notes note=Notes.fromMap(jsonData[i]);
          print(note.idNote);
          note.realized="null";
          await DatabaseNotes.db.newNote(note);
        }

        List<Notes> notes=await DatabaseNotes.db.getNotes();
        return notes;
      } else{
        setState(() {
          realized=true;
        });
        return null;
      }     
    }
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    return null;
  }
  

  /*Future<List<Contactos>> getContactos() async{
    List<Contactos> contacts= new List();
    for(int i=0;i<datos.length;i++){
      print(datos[i]);

      contacts.add(Contactos.fromMap(datos[i]));
    }
    print(contacts);
    return contacts;
  }*/
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body:CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
            
          _buildContacts(screenHeight,screenWidth),
          //_buildYourOwnTest(screenHeight,screenWidth),
        ],
      ),
      floatingActionButton: _buttonAddContact(),
    );
  }

  Widget _buttonAddContact(){
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddScreen(user: widget.user,),
          ),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Palette.primaryColor,
    );
  }

  SliverToBoxAdapter _buildContacts(double screenHeight,double screenWidth) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Contactos',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData || realized) {
                  if (snapshot.data!=null) {
                    final listcontacts=snapshot.data;
                    List<Widget> cardList = new List();
                    for (var i = 0; i < listcontacts.length; i++) {

                      var cardItem =  
                      GestureDetector(
                        child:Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          child:Container(
                            width: (screenWidth/2)-30,
                            //height: (screenHeight/2)-10,
                            child:Column(
                              children: <Widget>[
                                Text(
                                  listcontacts[i].title+listcontacts[i].idNote.toString(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Text(
                                  listcontacts[i].description,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditScreen(user: widget.user,note: listcontacts[i],),
                            ),
                          );
                        },
                      );
                      cardList.add(cardItem);
                    }
                    return Wrap(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      alignment: WrapAlignment.center,
                      //spacing: screenWidth/6,
                      children:  cardList,
                    );
                  }
                  else{
                    return Container(
                      child: Text("No hay nada"),
                    );
                  }
                }
                else {
                  return CircularProgressIndicator();
                }
              }
            ),
              
          ],
        ),
      ),
    );
  }
}

/*
children: datos
                .map((e) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 10,
                  child:Container(
                    width: (screenWidth/2)-30,
                    //height: (screenHeight/2)-10,
                    child:Column(
                      children: <Widget>[
                        Text(
                          e.keys.first,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          e.values.first,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              ).toList(),
            
*/ 