import 'package:flutter/material.dart';

class CountryDropdown extends StatelessWidget {
  final List<String> countries;
  final String country;
  final Function(String) onChanged;

  const CountryDropdown({
    @required this.countries,
    @required this.country,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: country,
          items: countries
              .map((e) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 12.0,
                          backgroundImage: AssetImage(
                            'assets/images/${e[0]}.jpg',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          getName(e),
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    value: e,
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
  String getName(String e){
    final a = e.replaceAll(RegExp(e[0]), ''); 
    return a;
  }
}
