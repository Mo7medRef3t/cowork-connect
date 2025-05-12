import 'dart:convert';
import 'package:co_work_connect/features/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:co_work_connect/features/data/models/place_model.dart';

class LocalStorageService {
  static const String _bookedPlacesKey = 'booked_places';

  static Future<void> bookSpace(PlaceModel place) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookedPlaces = prefs.getStringList(_bookedPlacesKey) ?? [];

    if (!bookedPlaces.any(
      (item) => PlaceModel.fromJson(jsonDecode(item)).name == place.name,
    )) {
      bookedPlaces.add(jsonEncode(place.toJson()));
      await prefs.setStringList(_bookedPlacesKey, bookedPlaces);
    }
  }

  static Future<List<PlaceModel>> getBookedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookedPlaces = prefs.getStringList(_bookedPlacesKey) ?? [];
    return bookedPlaces
        .map((item) => PlaceModel.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> unBookSpace(String placeName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookedPlaces = prefs.getStringList(_bookedPlacesKey) ?? [];
    bookedPlaces.removeWhere(
      (item) => PlaceModel.fromJson(jsonDecode(item)).name == placeName,
    );
    await prefs.setStringList(_bookedPlacesKey, bookedPlaces);
  }
}

class LocalUserStorageService {
  static const String usersKey = 'users';
  static const String _loggedInUserKey = 'logged_in_user';

  static Future<String?> addUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(usersKey) ?? [];

    for (var item in users) {
      final u = UserModel.fromJson(jsonDecode(item));
      if (u.username == user.username) {
        return 'Username already exists';
      }
      if (u.email == user.email) {
        return 'Email already exists';
      }
    }

    users.add(jsonEncode(user.toJson()));
    await prefs.setStringList(usersKey, users);
    return null; 
  }

  static Future<List<UserModel>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(usersKey) ?? [];
    return users.map((item) => UserModel.fromJson(jsonDecode(item))).toList();
  }

  static Future<UserModel?> authenticate(
    String userOrEmail,
    String password,
  ) async {
    List<UserModel> users = await getUsers();
    try {
      return users.firstWhere(
        (user) =>
            (user.username == userOrEmail || user.email == userOrEmail) &&
            user.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> setLoggedInUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInUserKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(_loggedInUserKey);
    return data == null ? null : UserModel.fromJson(jsonDecode(data));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInUserKey);
  }
}
