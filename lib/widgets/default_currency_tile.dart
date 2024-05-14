import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/conversion_page.dart';

class DefaultCurrencyTile extends StatelessWidget {
  const DefaultCurrencyTile(
      {super.key,
      required this.flag,
      required this.price,
      required this.currency});

  final String flag;
  final String price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: Container(
        width: size.width - 60,
        height: size.height - 670,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Container(
              height: size.height - 700,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(.03)),
            ),
          ),
          Positioned(
            left: 150,
            right: 150,
            child: CountryFlag.fromCountryCode(
              flag,
              height: size.height * .07,
              borderRadius: 30,
            ),
          ),
          Positioned(
            left: 130,
            top: 100,
            child: SizedBox(
              height: 40,
              width: 130,
              child: Text(
                price,
                textAlign: TextAlign.center,
                style: GoogleFonts.libreBaskerville(fontSize: 27),
              ),
            ),
          ),
          Positioned(
              left: 130,
              top: 150,
              child: SizedBox(
                height: 40,
                width: 130,
                child: Text(
                  textAlign: TextAlign.center,
                  currency,
                  style: GoogleFonts.ubuntuMono(fontSize: 20),
                ),
              )),
          Positioned(
              bottom: 1,
              left: 100,
              child: Material(
                elevation: 5,
                color: CupertinoColors.white.withOpacity(.9),
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: size.width - 370,
                  height: size.width - 370,
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
              )),
          Positioned(
              bottom: 1,
              left: 220,
              child: GestureDetector(
                onTap: ()
                {
                  Navigator.push(context, CupertinoPageRoute(builder: (c) => const ConversionPage()));
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  color: CupertinoColors.white.withOpacity(.9),
                  child: SizedBox(
                    width: size.width - 370,
                    height: size.width - 370,
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
        ]),
      ),
    );
  }
}
