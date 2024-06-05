import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_flags/country_flags.dart';
import 'package:currency_converter/screens/exchange_result.dart';
import 'package:currency_converter/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../api/currency_rates.dart';
import '../widgets/currency_selection.dart';

class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  bool isLoading = false;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  double exchangeRate = 0;
  double conversionExchangeRate = 0;
  final ExchangeRateController exchangeRateController =
      Get.put(ExchangeRateController());
  String firstCountry = '';
  String secondCountry = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exchangeRateController.fetchDataBaseRate(firstCountry);
    setState(() {
      exchangeRate = exchangeRateController.convertCurrency(
          1, exchangeRateController.countries.first, secondCountry);
    });
  }

  void convertCurrency(double amountInFirstCountry, String secondCountry) {
    // Pass converted value to the next screen while navigating
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void showCurrencyDropdown(BuildContext context, Function(String) onSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: exchangeRateController.flags.map((String country) {
            return GestureDetector(
              child: CurrencySelectionSheet(
                flag: country,
                price: '432,2', // Placeholder price
                currency: country.toUpperCase(),
              ),
              onTap: () {
                onSelected(country);
                Navigator.pop(context);
                exchangeRateController.fetchDataBaseRate(firstCountry);
                setState(() {
                  exchangeRate = exchangeRateController.convertCurrency(
                      1, exchangeRateController.countries.first, secondCountry);
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  void swapCountries() {
    setState(() {
      String temp = firstCountry;
      firstCountry = secondCountry;
      secondCountry = temp;
    });

    exchangeRateController.fetchDataBaseRate(firstCountry).then((_) {
      setState(() {
        exchangeRate = exchangeRateController.convertCurrency(
            1, firstCountry, secondCountry);
      });
    });
  }

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
        title: Text(
          'Convert Currency',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Enter Amount',
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 200,
                height: 90,
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        // Check for non-numeric characters
                        final numericRegex = RegExp(r'^-?\d+(\.\d+)?$');
                        if (!numericRegex.hasMatch(value)) {
                          return 'Please enter a valid number';
                        }
                        final double? amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Amount must be greater than zero';
                        }
                        return null; // If validation passes, return null
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              (exchangeRate.isEqual(0))
                  ? Text(
                      '0 $firstCountry = $exchangeRate $secondCountry',
                      style: const TextStyle(
                          fontWeight: FontWeight.w200, fontSize: 17),
                    )
                  : Text(
                      '1 $firstCountry = $exchangeRate $secondCountry',
                      style: const TextStyle(
                          fontWeight: FontWeight.w200, fontSize: 17),
                    ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  showCurrencyDropdown(context, (String selectedCurrency) {
                    setState(() {
                      firstCountry = selectedCurrency;
                    });
                  });
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.04),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (exchangeRate.isEqual(0))
                                ? const Icon(
                                    CupertinoIcons.flag,
                                    size: 25,
                                  )
                                : CountryFlag.fromCountryCode(
                                    firstCountry,
                                    height: 70,
                                    width: 75,
                                    borderRadius: 15,
                                  ),
                            const SizedBox(width: 25),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${firstCountry.toUpperCase()} Rate",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  (exchangeRate.isEqual(0))
                                      ? Text(
                                          '0 $firstCountry',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 17),
                                        )
                                      : Text(
                                          '1 $firstCountry',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 17),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          CupertinoIcons.arrow_down,
                          color: Colors.black.withOpacity(.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: swapCountries,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black.withOpacity(.5),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        CupertinoIcons.arrow_up_arrow_down,
                        size: 25,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showCurrencyDropdown(context, (String selectedCurrency) {
                    setState(() {
                      secondCountry = selectedCurrency;
                    });
                  });
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.04),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (exchangeRate.isEqual(0))
                                ? const Icon(
                                    CupertinoIcons.flag,
                                    size: 25,
                                  )
                                : CountryFlag.fromCountryCode(
                                    secondCountry,
                                    height: 70,
                                    width: 75,
                                    borderRadius: 15,
                                  ),
                            const SizedBox(width: 25),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${secondCountry.toUpperCase()} Rate",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  (exchangeRate.isEqual(0))
                                      ? const Text(
                                          "0",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 17),
                                        )
                                      : Text(
                                          "$exchangeRate $secondCountry",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 17),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          CupertinoIcons.arrow_down,
                          color: Colors.black.withOpacity(.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height - 730),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await exchangeRateController.fetchDataBaseRate(firstCountry);
                    double conversionExchangeRate =
                    exchangeRateController.convertCurrency(
                        amountController.text.trim(),
                        exchangeRateController.countries.first,
                        secondCountry);
                    setState(() {
                      isLoading = false;
                    });

                    if (conversionExchangeRate != 0 && conversionExchangeRate != 0.0) {
                      DateTime now = DateTime.now();
                      String formattedDateTime =
                      DateFormat('dd/MM/yy HH:mm:ss').format(now);
                      saveExchangeResultToFirebase(
                          context,
                          firstCountry,
                          secondCountry,
                          conversionExchangeRate.toString(),
                          amountController.text.trim(),
                          formattedDateTime);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (c) => ExchangeResult(
                                exchangeRate: exchangeRate.toString(),
                                firstCountry: firstCountry,
                                secondCountry: secondCountry,
                                amountConverted:
                                amountController.text.trim(),
                                date: formattedDateTime,
                                totalExchangeAmount:
                                conversionExchangeRate.toString(),
                              )));
                    } else {
                      // Display error message if conversion or exchange rate is 0 or 0.0
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Select correct Details'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CupertinoColors.black.withOpacity(.8),
                  ),
                  width: size.width / 1.15,
                  height: 60,
                  child: Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Convert Now',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveExchangeResultToFirebase(
    BuildContext context,
    String firstCountry,
    String secCountry,
    String totalAmountExchanged,
    String amountConverted,
    String date,
  ) async {
    try {
      // Get the current user's UID
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        // Reference to the Firestore collection
        CollectionReference exchangeResults =
            FirebaseFirestore.instance.collection('exchange_results');

        // Add the exchange result data to Firestore
        await exchangeResults.add({
          'userId': uid,
          'firstCountry': firstCountry,
          'secondCountry': secondCountry,
          'totalExchangeAmount': totalAmountExchanged,
          'amountConverted': amountConverted,
          'date': date,
          'exchangeRate': exchangeRate.toString(),
          'status': 'Completed',
        });
      }
    } catch (e) {
      print('Error saving exchange result: $e');
      // Handle error
    }
  }
}
