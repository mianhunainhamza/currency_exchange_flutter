import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/conversion_tile.dart';

class ConversionPage extends StatelessWidget {
  const ConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Convert Currency',
            style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter Amount',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "2345,2 PKR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            const SizedBox(width: 200, child: Divider()),
            const Text(
              '2345,2 PKR = 12 \$',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
            ),
            const SizedBox(
              height: 50,
            ),
            const ConversionTile(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.black.withOpacity(.5)
                ),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(CupertinoIcons.arrow_up_arrow_down,size: 25,color: CupertinoColors.white,)),
              ),
            ),
            const ConversionTile(),
          ],
        ),
      ),
    );
  }
}
