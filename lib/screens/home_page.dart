import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/screens/onBoard_page.dart';
import 'package:currency_converter/widgets/currency_tile.dart';
import 'package:currency_converter/widgets/default_currency_tile.dart';
import 'package:currency_converter/widgets/history_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../api/currency_rates.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ExchangeRateController exchangeRateController =
      Get.put(ExchangeRateController());
  String selectedCurrency = '';

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
      body: Obx(() {
        if (exchangeRateController.conversionRates.isEmpty) {
          return _buildShimmerLoading();
        }

        return ListView(
          children: [
            const SizedBox(height: 15),
            DefaultCurrencyTile(
              flag: exchangeRateController.flags.first,
              currency: '${exchangeRateController.countries.first} Rate',
              price: exchangeRateController.currency.first.toString(),
              onCurrencyChanged: (newCurrency) {
                setState(() {
                  selectedCurrency = newCurrency;
                });
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Currency',
                style: GoogleFonts.libreBaskerville(fontSize: 25),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    exchangeRateController.countries.length,
                    (index) => (index == 0)
                        ? const SizedBox()
                        : CurrencyTile(
                            flag: exchangeRateController.flags[index],
                            currency: exchangeRateController.countries[index],
                            price: exchangeRateController.currency[index]
                                .toString(),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: GoogleFonts.libreBaskerville(fontSize: 25),
                  ),
                  GestureDetector(
                    onTap: () {
                      showInformationDialog(context);
                    },
                    child: const Icon(CupertinoIcons.info_circle),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _fetchExchangeHistory(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildHistoryTileShimmer();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Column(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return CurrencyHistory(
                        firstCountry: data['firstCountry'],
                        firstCountryPrice: data['amountConverted'],
                        totalAmount: data['totalExchangeAmount'],
                        secondCountry: data['secondCountry'],
                        exchangeRates: data['exchangeRate'],
                        currency: data['firstCountry'],
                        date: data['date'],
                      );
                    }).toList(),
                  );
                }
                return Column(children: [
                  SizedBox(
                    height: 120,
                    child: Lottie.asset(
                    'assets/empty.json'
                    ),
                  )
                ]);
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      children: [
        const SizedBox(height: 15),
        _buildDefaultCurrencyTileShimmer(),
        const SizedBox(height: 40),
        _buildCurrencyTilesShimmer(),
        const SizedBox(height: 30),
        _buildHistoryTileShimmer(),
      ],
    );
  }

  Widget _buildDefaultCurrencyTileShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyTilesShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: SizedBox(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }

  Widget _buildHistoryTileShimmer() {
    return Column(
      children: [
        _buildHistoryTileItemShimmer(),
        const SizedBox(height: 20),
        _buildHistoryTileItemShimmer(),
      ],
    );
  }

  Widget _buildHistoryTileItemShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          subtitle: Container(
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          trailing: Container(
            width: 70,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot> _fetchExchangeHistory() async {
    try {
      // Get the current user's UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // Query Firestore collection for exchange history where UID matches
        return await FirebaseFirestore.instance
            .collection('exchange_results')
            .where('userId', isEqualTo: uid)
            .get();
      } else {
        throw Exception('User not authenticated.');
      }
    } catch (e) {
      print('Error fetching exchange history: $e');
      throw e;
    }
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
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmLogout) {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLogin', false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardPage()),
      );
    }
  }

  void showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Information"),
          content: const Text(
              "Here you can view your transaction history and other related information. But can't delete it for security reasons"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
