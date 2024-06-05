import 'package:currency_converter/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class ExchangeResult extends StatelessWidget {
  const ExchangeResult(
      {super.key,
      required this.exchangeRate,
      required this.firstCountry,
      required this.secondCountry,
      required this.amountConverted,
      required this.date,
      required this.totalExchangeAmount});

  final String firstCountry;
  final String secondCountry;
  final String totalExchangeAmount;
  final String amountConverted;
  final String date;
  final String exchangeRate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.04),
                borderRadius: BorderRadius.circular(30)),
            width: size.width,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Successfully Converted',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    totalExchangeAmount,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                    width: size.width / 2,
                    child: const Divider(),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      '$amountConverted $firstCountry',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      LineIcons.coins,
                      color: Colors.black.withOpacity(.3),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'To $secondCountry',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w300),
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  buildRow('Converted', '$amountConverted $firstCountry'),
                  const SizedBox(
                    height: 30,
                  ),
                  buildRow('Conversion Rate',
                      '1 $firstCountry to 1 $secondCountry = $exchangeRate'),
                  const SizedBox(
                    height: 30,
                  ),
                  buildRow('Date', date),
                  const SizedBox(
                    height: 30,
                  ),
                  buildRow('Status', 'Completed'),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height - 630),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: CupertinoColors.black.withOpacity(.8),
              ),
              width: size.width / 1.15,
              height: 60,
              child: const Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Row buildRow(String firstValue, String secondValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          firstValue,
          style: GoogleFonts.lato(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          secondValue,
          style: GoogleFonts.lato(fontWeight: FontWeight.w300, fontSize: 15),
        ),
      ],
    );
  }
}
