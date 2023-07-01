import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  String url = 'https://calm-red-dove-fez.cyclic.app/categories';

  Future<List<Category>> getMenu() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Category> categoriesList = List<Category>.from(
            jsonData['data']['categories'].map((x) => Category.fromJson(x)));
        return categoriesList;
      } else {
        throw Exception("Error hit API status code not 200: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error hit API: ${e.toString()}");
    }
  }

  Future<Category> deleteCategory(int id) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'));
      if (response.statusCode == 200) {
        Category category = Category.fromJson(json.decode(response.body));
        return category;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
