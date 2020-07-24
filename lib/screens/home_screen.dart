import 'package:flutter/material.dart';
import 'package:clinicapp/config/palette.dart';
import 'package:clinicapp/config/styles.dart';
import 'package:clinicapp/data/data.dart';
import 'package:clinicapp/widgets/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _doctor = '3Fernando Manrique';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(screenHeight,screenWidth),
          _buildPreventionTips(screenHeight,screenWidth),
          //_buildYourOwnTest(screenHeight,screenWidth),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(double screenHeight,double screenWidth) {
    
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Zama Bioingenieria Oral',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: 50,
                  height: 50,
                  child:CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/1.jpg')
                  ) 
                ),
                
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    Text(
                      'Proxima cita: ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CountryDropdown(
                      countries: ['1Juan Pedrito', '4Walker Chalco', '3Fernando Manrique'],
                      country: _doctor,
                      onChanged: (val) => setState(() => _doctor = val),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Wrap(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    Text(
                      'Walker Manrique Chalco 12/06/2020 - 10:00 am',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15.0,
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme: DatePickerTheme(
                                headerColor: Colors.white,
                                backgroundColor: Palette.primaryColor,
                                itemStyle: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
                            onChanged: (date) {
                          print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'Reprogramar',
                        style: TextStyle(color: Colors.black),
                      )
                    ),
                  ],
                ),
                
                SizedBox(height: screenHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {},
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Llamar',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                    FlatButton.icon(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      onPressed: () {},
                      color: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      icon: const Icon(
                        Icons.chat_bubble,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Mensaje',
                        style: Styles.buttonTextStyle,
                      ),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPreventionTips(double screenHeight,double screenWidth) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Opciones',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20.0),
            Wrap(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              alignment: WrapAlignment.center,
              //spacing: screenWidth/6,
              children: prevention
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
                        Image.asset(
                          e.keys.first,
                          height: screenHeight * 0.12,
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
            ),
          ],
        ),
      ),
    );
  }
}
