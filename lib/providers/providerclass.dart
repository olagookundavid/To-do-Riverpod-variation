import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../db_helper/database.dart';

class ProviderClass extends ChangeNotifier {
  List<Map<String, dynamic>> _todos = [];

  UnmodifiableListView<Map<String, dynamic>> get todo {
    return UnmodifiableListView(_todos);
  }

  int get notecount => _todos.length;

  void refreshNotes() async {
    final data = await SQLHelper.getItems();
    _todos = data;
    notifyListeners();
  }

  Future<void> addTask(String text) async {
    await SQLHelper.createItem(text);
    refreshNotes();
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await SQLHelper.deleteItem(id);
    refreshNotes();
    notifyListeners();
  }

  Future<void> deleteAllTasks() async {
    await SQLHelper.deleteAllItem();
    refreshNotes();
    notifyListeners();
  }

  // bool isChecked = false;

  Future<void> changeIsChecked(int id, String title, int checkvalue) async {
    await SQLHelper.updatecheckvalue(id, title, checkvalue);
    refreshNotes();
    notifyListeners();
  }
}
