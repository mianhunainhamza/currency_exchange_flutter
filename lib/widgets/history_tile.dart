import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyHistory extends StatelessWidget {
  const CurrencyHistory(
      {super.key,
      required this.flag,
      required this.price,
      required this.currency, required this.changeFlag, required this.changePrice, required this.changeCurrency});

  final String flag;
  final String price;
  final String currency;
  final String changeFlag;
  final String changePrice;
  final String changeCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(.03)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                CountryFlag.fromCountryCode(
                  flag,
                  height: 40,
                  width: 50,
                  borderRadius: 12,
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                price.length > 4 ? "${price.substring(0, 4)}.." : price,
                      style: GoogleFonts.libreBaskerville(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      currency,
                      style: GoogleFonts.ubuntuMono(fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_rounded),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
            changePrice.length > 4 ? '${changePrice.substring(0, 4)}..' : changePrice,
                      style: GoogleFonts.libreBaskerville(fontSize: 22),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      changeCurrency,
                      style: GoogleFonts.ubuntuMono(fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                CountryFlag.fromCountryCode(
                  changeFlag,
                  height: 40,
                  width: 50,
                  borderRadius: 12,
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
