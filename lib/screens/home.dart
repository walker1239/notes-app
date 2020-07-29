import 'dart:convert';
import 'package:clinicapp/data/notes.dart';
import 'package:clinicapp/screens/add_contac_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_color/random_color.dart';

import 'edit_note_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool realized=false;
  RandomColor _randomColor;
  Future<List<Notes>> getNotes() async{
    List<Notes> notes = List<Notes>();
    var url = 'http://192.168.2.101:8085/notes';
    var response = await http.get(url,
    );
    final jsonData = json.decode(response.body);
    print(jsonData);

    if (response.statusCode == 200) {
      print("succes");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(jsonData!=null) { 
        int index=jsonData.length;
        for(var i=0;i<index;i++){
          Notes note=Notes.fromMap(jsonData[i]);
          notes.add(note);
          print(note.idNote);
        }
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
  
  @override
  void initState() {
    _randomColor = RandomColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(  
        title: Text("Notas"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 28.0,
            onPressed: () {
              setState(() {
                
              });
            },
          ),
        ],
      ),
      body:CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildNotes(screenHeight,screenWidth),
        ],
      ),
      floatingActionButton: _buttonAddNote(),
    );
  }

  Widget _buttonAddNote(){
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddScreen(),
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }

  SliverToBoxAdapter _buildNotes(double screenHeight,double screenWidth) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            FutureBuilder(
              future: getNotes(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData || realized) {
                  if (snapshot.data!=null) {
                    final listcontacts=snapshot.data;
                    List<Widget> cardListr = new List();
                    List<Widget> cardListl = new List();
                    for (var i = 0; i < listcontacts.length; i+=2) {
                      //rigth
                      var cardItemr =  
                      GestureDetector(
                        child:Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          child:Container(
                            color: _randomColor.randomColor(
                              colorBrightness: ColorBrightness.light
                            ),
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
                              builder: (context) => EditScreen(note: listcontacts[i],),
                            ),
                          );
                        },
                      );
                      cardListr.add(cardItemr);
                  
                    }
                  for (var i = 1; i < listcontacts.length; i+=2) {
                    var cardIteml =  
                      GestureDetector(
                        child:Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          child:Container(
                            color: _randomColor.randomColor(
                              colorBrightness: ColorBrightness.light
                            ),
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
                              builder: (context) => EditScreen(note: listcontacts[i],),
                            ),
                          );
                        },
                      );
                      cardListl.add(cardIteml);
                    }
                    return Wrap(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //alignment: WrapAlignment.center,
                      //spacing: screenWidth/6,
                      children:  [
                        Column(
                          children:cardListl,
                        ),
                        Column(
                          children:cardListr,
                        ),
                      ],
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
