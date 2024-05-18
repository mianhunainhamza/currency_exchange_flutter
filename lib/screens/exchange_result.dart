import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExchangeResult extends StatelessWidget {
  const ExchangeResult({super.key, required this.exchangeRate});
  final String exchangeRate;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        title: Text(
          '',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(exchangeRate)
        ],
      ),
    );
  }
}
