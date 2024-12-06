import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'assigning_fees_copy_widget.dart' show AssigningFeesCopyWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';

class AssigningFeesCopyModel extends FlutterFlowModel<AssigningFeesCopyWidget> {
  ///  Local state fields for this page.

  List<StudentsRecord> studentDocuments = [];
  void addToStudentDocuments(StudentsRecord item) => studentDocuments.add(item);
  void removeFromStudentDocuments(StudentsRecord item) =>
      studentDocuments.remove(item);
  void removeAtIndexFromStudentDocuments(int index) =>
      studentDocuments.removeAt(index);
  void insertAtIndexInStudentDocuments(int index, StudentsRecord item) =>
      studentDocuments.insert(index, item);
  void updateStudentDocumentsAtIndex(
          int index, Function(StudentsRecord) updateFn) =>
      studentDocuments[index] = updateFn(studentDocuments[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for SearchBar widget.
  final searchBarKey = GlobalKey();
  FocusNode? searchBarFocusNode;
  TextEditingController? searchBarTextController;
  String? searchBarSelectedOption;
  String? Function(BuildContext, String?)? searchBarTextControllerValidator;
  List<StudentsRecord> simpleSearchResults = [];
  // Stores action output result for [Firestore Query - Query a collection] action in SearchBar widget.
  StudentsRecord? foundDoc;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchBarFocusNode?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();
  }
}
