import 'package:currency_converter/api/currency_rates.dart';
import 'package:currency_converter/screens/onBoard_page.dart';
import 'package:currency_converter/widgets/currency_tile.dart';
import 'package:currency_converter/widgets/default_currency_tile.dart';
import 'package:currency_converter/widgets/history_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, dynamic> values;
  List<String> countries = [];
  List<String> flags = [];
  List<dynamic> currency = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((value) {
      setState(() {
        values = value;
        countries = values.keys.toList();
        currency = values.values.toList();

        for (String country in countries) {
          String flag = country.substring(0, 2);
          flags.add(flag);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Icon(
          Icons.currency_exchange,
          size: 30,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                logout(context);
              },
              child: const Icon(
                Icons.logout,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          (currency.isNotEmpty)
              ? DefaultCurrencyTile(
                  flag: flags.first,
                  currency: ' ${countries.first} Rate',
                  price: currency.first.toString(),
                )
              : const DefaultCurrencyTile(
                  flag: ' ',
                  currency: '-- Rate',
                  price: '0,0',
                ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Currency',
              style: GoogleFonts.libreBaskerville(fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  10,
                  (index) => (currency.isNotEmpty && countries.isNotEmpty && index !=0 && index != 5) ? CurrencyTile(
                    flag: flags[index],
                    currency: countries[index],
                    price: currency[index].toString(),
                  ): const SizedBox(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: GoogleFonts.libreBaskerville(fontSize: 25),
                ),
                const Icon(CupertinoIcons.search)
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CurrencyHistory(
                  flag: 'US',
                  currency: 'Dollar',
                  price: '1,0',
                  changeFlag: 'PK',
                  changePrice: '282342349,1',
                  changeCurrency: 'Pkr',
                ),
                CurrencyHistory(
                  flag: 'GB',
                  currency: 'Pound',
                  price: '1,0',
                  changeFlag: 'PK',
                  changePrice: '351,9',
                  changeCurrency: 'Pkr',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black.withOpacity(.4)),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false to indicate cancellation
              },
            ),
            CupertinoDialogAction(
              child: Text('Logout',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.6))),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true to indicate confirmation
              },
            ),
          ],
        );
      },
    );

    // If user confirms logout, proceed with logout process
    if (confirmLogout) {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Update shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', false);
      // You can also clear other user-related data from shared preferences if needed

      // Navigate to logout screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardPage()),
      );
    }
  }
}
