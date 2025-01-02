// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ProductService {
//   Future<List<Product>> fetchProducts() async {
//     final response = await http.get(Uri.parse('https://example.com/api/products'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => Product.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
// }