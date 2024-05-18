import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencySelectionSheet extends StatelessWidget {
  const CurrencySelectionSheet({super.key, required this.flag, required this.price, required this.currency});
  final String flag;
  final String price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(.03)
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                CountryFlag.fromCountryCode(
                  flag,
                  height: 40,
                  width: 50,
                  borderRadius: 12,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(width: 20,),
                Text(currency,style: GoogleFonts.ubuntuMono(fontSize:20),)
              ]
          ),
        ),
      ),
    );
  }
}
