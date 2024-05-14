import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  try {
    // Define the URL using https
    var url = Uri.https('v6.exchangerate-api.com', '/v6/40259054c2fb1039127bb037/latest/PKR');

    // Make a GET request to fetch data
    var response = await http.get(url);

    // Check response status
    if (response.statusCode == 200) {
      // Parse JSON response
      Map<String, dynamic> data = json.decode(response.body);

      // Extract conversion rates
      Map<String, dynamic> conversionRates = data['conversion_rates'];

      // Return conversion rates
      return conversionRates;
    } else {
      // Print error message if status code is not 200
      print('Request failed with status: ${response.statusCode}');
      return {};
    }
  } catch (e) {
    // Handle any exceptions
    print('Error fetching data: $e');
    return {};
  }
}
