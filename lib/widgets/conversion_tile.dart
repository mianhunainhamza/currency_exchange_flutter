import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'currency_tile_conversion.dart';

class ConversionTile extends StatefulWidget {
  const ConversionTile({super.key});

  @override
  ConversionTileState createState() => ConversionTileState();
}

class ConversionTileState extends State<ConversionTile> {
  String? selectedCurrency = 'pk';
  final List<String> currencies = ['pk', 'us', 'gb'];

  void _showCurrencyDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: currencies.map((String currency) {
            return GestureDetector(child:  ConversionTileConversion(flag: currency, price: '432,2', currency: currency.toUpperCase(),),
              onTap: () {
                setState(() {
                  selectedCurrency = currency;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CountryFlag.fromCountryCode(
                  selectedCurrency!,
                  height: 70,
                  width: 75,
                  borderRadius: 15,
                ),
                const SizedBox(
                  width: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${selectedCurrency?.toUpperCase()} Rate",
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      const Text(
                        '2345,2\$',
                        style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Custom Dropdown Button
            GestureDetector(
              onTap: () {
                _showCurrencyDropdown(context);
              },
              child: Icon(
                CupertinoIcons.arrow_down,
                color: Colors.black.withOpacity(.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
