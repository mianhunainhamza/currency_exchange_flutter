import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:country_flags/country_flags.dart';

import '../api/currency_rates.dart';
import '../screens/conversion_page.dart';
import 'currency_selection.dart';

class DefaultCurrencyTile extends StatefulWidget {
  const DefaultCurrencyTile({
    super.key,
    required this.flag,
    required this.price,
    required this.currency,
    required this.onCurrencyChanged,
  });

  final String flag;
  final String price;
  final String currency;
  final Function(String) onCurrencyChanged;

  @override
  DefaultCurrencyTileState createState() => DefaultCurrencyTileState();
}

class DefaultCurrencyTileState extends State<DefaultCurrencyTile> {
  final ExchangeRateController exchangeRateController =
  Get.put(ExchangeRateController());

  void showCurrencyDropdown(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: exchangeRateController.flags.map((String country) {
            return GestureDetector(
              child: CurrencySelectionSheet(
                flag: country,
                price: '432,2', // Placeholder price
                currency: country.toUpperCase(),
              ),
              onTap: () async {
                String selectedCurrency = country;
                Navigator.pop(context);

                bool confirmChange = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('Change Base Currency'),
                      content: Text('Do you want to set $selectedCurrency as the base currency?'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        CupertinoDialogAction(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (confirmChange != null && confirmChange) {
                  exchangeRateController.fetchDataAgain(selectedCurrency);
                  // Update currency rates and UI
                  widget.onCurrencyChanged(selectedCurrency);
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Container(
        width: 300,
        height: 310,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Container(
                height: 350,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(.03)),
              ),
            ),
            Positioned(
              left: size.width / 3,
              right: size.width / 3,
              child: CountryFlag.fromCountryCode(
                widget.flag,
                height: 60,
                borderRadius: 30,
              ),
            ),
            Positioned(
              left: size.width / 4,
              top: 100,
              child: SizedBox(
                height: 40,
                width: size.width / 2.5,
                child: Text(
                  widget.price,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.libreBaskerville(fontSize: 27),
                ),
              ),
            ),
            Positioned(
                left: size.width / 4,
                top: 150,
                child: SizedBox(
                  height: 40,
                  width: size.width / 2.5,
                  child: Text(
                    widget.currency,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ubuntuMono(fontSize: 20),
                  ),
                )),
            Positioned(
                bottom: 1,
                left: size.width / 5,
                child: GestureDetector(
                  onTap: () {
                    showCurrencyDropdown(context);
                  },
                  child: Material(
                    elevation: 5,
                    color: CupertinoColors.white.withOpacity(.9),
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(children: [
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(
                          LineIcons.ggCurrency,
                          size: 35,
                          color: CupertinoColors.black,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Currency',
                          style: GoogleFonts.lato(),
                        )
                      ]),
                    ),
                  ),
                )),
            Positioned(
                bottom: 1,
                left: size.width / 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (c) => const ConversionPage()));
                  },
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(15),
                    color: CupertinoColors.white.withOpacity(.9),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(children: [
                        const SizedBox(
                          height: 6,
                        ),
                        const Icon(
                          CupertinoIcons.arrow_up_right,
                          size: 35,
                          color: CupertinoColors.black,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Convert',
                          style: GoogleFonts.lato(),
                        )
                      ]),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
