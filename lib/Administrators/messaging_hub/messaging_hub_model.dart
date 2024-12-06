import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'messaging_hub_widget.dart' show MessagingHubWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagingHubModel extends FlutterFlowModel<MessagingHubWidget> {
  ///  Local state fields for this page.

  List<String> currentChatters = [];
  void addToCurrentChatters(String item) => currentChatters.add(item);
  void removeFromCurrentChatters(String item) => currentChatters.remove(item);
  void removeAtIndexFromCurrentChatters(int index) =>
      currentChatters.removeAt(index);
  void insertAtIndexInCurrentChatters(int index, String item) =>
      currentChatters.insert(index, item);
  void updateCurrentChattersAtIndex(int index, Function(String) updateFn) =>
      currentChatters[index] = updateFn(currentChatters[index]);

  List<String> secondChatters = [];
  void addToSecondChatters(String item) => secondChatters.add(item);
  void removeFromSecondChatters(String item) => secondChatters.remove(item);
  void removeAtIndexFromSecondChatters(int index) =>
      secondChatters.removeAt(index);
  void insertAtIndexInSecondChatters(int index, String item) =>
      secondChatters.insert(index, item);
  void updateSecondChattersAtIndex(int index, Function(String) updateFn) =>
      secondChatters[index] = updateFn(secondChatters[index]);

  List<String> finalChatters = [];
  void addToFinalChatters(String item) => finalChatters.add(item);
  void removeFromFinalChatters(String item) => finalChatters.remove(item);
  void removeAtIndexFromFinalChatters(int index) =>
      finalChatters.removeAt(index);
  void insertAtIndexInFinalChatters(int index, String item) =>
      finalChatters.insert(index, item);
  void updateFinalChattersAtIndex(int index, Function(String) updateFn) =>
      finalChatters[index] = updateFn(finalChatters[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
