// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ShopSearch extends StatefulWidget {
  const ShopSearch({super.key});

  @override
  _ShopSearchState createState() => _ShopSearchState();
}

class _ShopSearchState extends State<ShopSearch> {
  String dropdownValue = 'One';
  RangeValues _values = const RangeValues(0.0, 500.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 425,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(blurRadius: 2, color: Colors.black12, spreadRadius: 3)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                child: Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 15.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text('Select Price Range',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              RangeSlider(
                  values: _values,
                  min: 0,
                  max: 5000,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey[300],
                  onChanged: (RangeValues values) {
                    setState(() {
                      if (values.end - values.start >= 20) {
                        _values = values;
                      } else {
                        if (_values.start == values.start) {
                          _values =
                              RangeValues(_values.start, _values.start + 20);
                        } else {
                          _values = RangeValues(_values.end - 20, _values.end);
                        }
                      }
                    });
                  }),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 120,
                        height: 45.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$ ${_values.start.round()}',
                              style: const TextStyle(color: Colors.white)),
                        )),
                    const Text(
                      'to',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Container(
                        width: 120,
                        height: 45.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$ ${_values.end.round()}',
                              style: const TextStyle(color: Colors.white)),
                        )),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonTheme(
                      buttonColor: Theme.of(context).primaryColor,
                      minWidth: double.infinity,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
