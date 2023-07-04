import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitxkonnect/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LocationsDropDownList extends StatefulWidget {
  const LocationsDropDownList({Key? key}) : super(key: key);

  @override
  State<LocationsDropDownList> createState() => _LocationsDropDownListState();
}

class _LocationsDropDownListState extends State<LocationsDropDownList> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('locations')
            .orderBy('name', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Safety check to ensure that snapshot contains data
          // without this safety check, StreamBuilder dirty state warnings will be thrown
          if (!snapshot.hasData)
            return Center(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitCircle(
                    size: 50,
                    itemBuilder: (context, index) {
                      final colors = [Colors.black, Colors.purple];
                      final color = colors[index % colors.length];
                      return DecoratedBox(
                        decoration: BoxDecoration(color: color),
                      );
                    },
                  ),
                ),
              ),
            );
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: const [
                  Icon(
                    Icons.list,
                    size: 18,
                    color: Colors.yellow,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Choose location',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: snapshot.data!.docs
                  .map((item) => DropdownMenuItem<String>(
                        value: item.get('name'),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: textColor1,
                                ),
                              ),
                              TextSpan(
                                  text: item.get('name'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor1,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as String;
                });
              },
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 15,
              iconEnabledColor: Colors.yellow,
              buttonHeight: 50,
              buttonWidth: 200,
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.black26,
                ),
                color: Colors.teal,
              ).copyWith(
                boxShadow: kElevationToShadow[2],
              ),
              itemHeight: 40,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownPadding: null,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
            ),
          );
        });
  }
}
