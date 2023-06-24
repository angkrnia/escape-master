import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_model.dart';

class MenuService {
  String url = 'https://calm-red-dove-fez.cyclic.app/menu';

  Future<List<Menu>> getMenu() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Menu> menuList = List<Menu>.from(jsonData['data']['menu'].map((x) => Menu.fromJson(x)));
        return menuList;
      } else {
        throw Exception("Error hit API status code not 200: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error hit API: ${e.toString()}");
    }
  }

  Future<Menu> storeMenu(Menu menu) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(menu.toJson()));
      if (response.statusCode == 201) {
        Menu menu = Menu.fromJson(json.decode(response.body));
        return menu;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Menu> getMenuById(int id) async {
    try {
      final response = await http.get(Uri.parse('$url/$id'));
      if (response.statusCode == 200) {
        Menu menu = Menu.fromJson(json.decode(response.body));
        return menu;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Menu> deleteMenu(int id) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'));
      if (response.statusCode == 200) {
        Menu menu = Menu.fromJson(json.decode(response.body));
        return menu;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
