import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExchangeRateController extends GetxController {
  var conversionRates = <String, dynamic>{}.obs;
  var countries = <String>[].obs;
  var flags = <String>[].obs;
  var currency = <dynamic>[].obs;

  var conversionRatesTemp = <String, dynamic>{}.obs;
  var countriesTemp = <String>[].obs;
  var flagsTemp = <String>[].obs;
  var currencyTemp = <dynamic>[].obs;

  @override
  void onInit() {
    fetchData('USD');
    super.onInit();
  }

  Future<void> fetchData(String baseCurrency) async {
    try {
      var url = Uri.https(
          'v6.exchangerate-api.com', '/v6/40259054c2fb1039127bb037/latest/$baseCurrency');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        conversionRates.value = data['conversion_rates'];
        _populateFields();
      } else {
        if (kDebugMode) {
          print('Request failed with status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  Future<void> fetchDataBaseRate(String baseCurrency) async {
    try {
      bool found = conversionRates.keys.any((key) => key.startsWith(baseCurrency));
      if (found) {
        // Find the first key that starts with the targetCurrency
        String matchingKey = conversionRates.keys.firstWhere((key) => key.startsWith(baseCurrency));
        if (kDebugMode) {
          print(matchingKey);
        }

        var url = Uri.https(
            'v6.exchangerate-api.com', '/v6/40259054c2fb1039127bb037/latest/$matchingKey');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          conversionRatesTemp.value = data['conversion_rates'];
          _populateFields();
        } else {
          if (kDebugMode) {
            print('Request failed with status: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  void _populateFields() {
    countries.value = conversionRates.keys.toList();
    currency.value = conversionRates.values.toList();

    flags.value = countries.map((country) {
      return country.substring(0, 2).toUpperCase();
    }).toList();
  }

  double getExchangeRate(String baseCurrency, String targetCurrency) {
    // Check if exchange rate is available
    bool found = conversionRatesTemp.keys.any((key) => key.startsWith(targetCurrency));
    if (found) {
      // Find the first key that starts with the targetCurrency
      String matchingKey = conversionRatesTemp.keys.firstWhere((key) => key.startsWith(targetCurrency));
      var targetRate = conversionRatesTemp[matchingKey];
      if (kDebugMode) {
        print(targetRate);
      }
      if (targetRate != null) {
        if (targetRate is int) {
          // Convert int to double
          return targetRate.toDouble();
        } else if (targetRate is double) {
          return targetRate;
        } else if (targetRate is String) {
          // Try to parse string to double
          double? parsedRate = double.tryParse(targetRate);
          if (parsedRate != null) {
            return parsedRate;
          } else {
            if (kDebugMode) {
              print('Invalid type for exchange rate: $targetRate');
            }
            return 0.0;
          }
        } else {
          // Handle other types if necessary
          if (kDebugMode) {
            print('Invalid type for exchange rate: $targetRate');
          }
          return 0.0;
        }
      } else {
        if (kDebugMode) {
          print('Exchange rate for $targetCurrency is null.');
        }
        return 0.0; // or handle the case according to your requirements
      }
    } else {
      if (kDebugMode) {
        print('Exchange rate not available for $targetCurrency');
      }
      return 0.0;
    }
  }

  double convertCurrency(dynamic amount, String baseCurrency, String targetCurrency) {
    double parsedAmount;
    if (amount is String) {
      parsedAmount = double.tryParse(amount) ?? 0.0;
    } else if (amount is double) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = amount.toDouble();
    } else {
      parsedAmount = 0.0;
    }

    double exchangeRate = getExchangeRate(baseCurrency, targetCurrency);
    return parsedAmount * exchangeRate;
  }
}
