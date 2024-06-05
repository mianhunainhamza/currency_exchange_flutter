import 'package:country_flags/country_flags.dart';
import 'package:currency_converter/screens/exchange_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyHistory extends StatelessWidget {
  const CurrencyHistory({
    super.key,
    required this.firstCountry,
    required this.firstCountryPrice,
    required this.currency,
    required this.secondCountry,
    required this.totalAmount,
    required this.exchangeRates,
    required this.date,
  });

  final String firstCountry;
  final String date;
  final String firstCountryPrice;
  final String currency;
  final String secondCountry;
  final String totalAmount;
  final String exchangeRates;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ExchangeResult(
                    exchangeRate: exchangeRates,
                    firstCountry: firstCountry,
                    secondCountry: secondCountry,
                    amountConverted: firstCountryPrice,
                    date: date,
                    totalExchangeAmount: totalAmount)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(.03),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      firstCountry,
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
                          firstCountryPrice.length > 4
                              ? "${firstCountryPrice.substring(0, 4)}.."
                              : firstCountryPrice,
                          style: GoogleFonts.libreBaskerville(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          currency,
                          style: GoogleFonts.ubuntuMono(fontSize: 16),
                        ),
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
                          totalAmount.length > 4
                              ? '${totalAmount.substring(0, 4)}..'
                              : totalAmount,
                          style: GoogleFonts.libreBaskerville(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          secondCountry,
                          style: GoogleFonts.ubuntuMono(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    CountryFlag.fromCountryCode(
                      secondCountry,
                      height: 40,
                      width: 50,
                      borderRadius: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
