import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyTile extends StatelessWidget {
  const CurrencyTile({super.key, required this.flag, required this.price, required this.currency});
  final String flag;
  final String price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(.03)
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
              Text(price,style: GoogleFonts.lato(fontSize:25),),
              const SizedBox(height: 20,),
              Text(currency,style: GoogleFonts.ubuntuMono(fontSize:20),)
          ]
          ),
        ),
      ),
    );
  }
}
