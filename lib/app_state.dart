import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _LoggedInAdministrator =
          prefs.getString('ff_LoggedInAdministrator')?.ref ??
              _LoggedInAdministrator;
    });
    _safeInit(() {
      _LoggedInAdminID =
          prefs.getString('ff_LoggedInAdminID') ?? _LoggedInAdminID;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  DocumentReference? _LoggedInAdministrator;
  DocumentReference? get LoggedInAdministrator => _LoggedInAdministrator;
  set LoggedInAdministrator(DocumentReference? value) {
    _LoggedInAdministrator = value;
    value != null
        ? prefs.setString('ff_LoggedInAdministrator', value.path)
        : prefs.remove('ff_LoggedInAdministrator');
  }

  String _LoggedInAdminID = '';
  String get LoggedInAdminID => _LoggedInAdminID;
  set LoggedInAdminID(String value) {
    _LoggedInAdminID = value;
    prefs.setString('ff_LoggedInAdminID', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
