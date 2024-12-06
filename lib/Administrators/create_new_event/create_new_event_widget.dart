import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'create_new_event_model.dart';
export 'create_new_event_model.dart';

class CreateNewEventWidget extends StatefulWidget {
  const CreateNewEventWidget({super.key});

  @override
  State<CreateNewEventWidget> createState() => _CreateNewEventWidgetState();
}

class _CreateNewEventWidgetState extends State<CreateNewEventWidget> {
  late CreateNewEventModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateNewEventModel());

    _model.eventNameTextController ??= TextEditingController();
    _model.eventNameFocusNode ??= FocusNode();

    _model.eventVenueTextController ??= TextEditingController();
    _model.eventVenueFocusNode ??= FocusNode();

    _model.eventDetailsTextController ??= TextEditingController();
    _model.eventDetailsFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed('ViewEvents');
            },
            child: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: Opacity(
                      opacity: 0.5,
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: FutureBuilder<AdministratorsRecord>(
                          future: AdministratorsRecord.getDocumentOnce(
                              FFAppState().LoggedInAdministrator!),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final textAdministratorsRecord = snapshot.data!;

                            return Text(
                              'Logged in as ${textAdministratorsRecord.adminName}',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'Create an event',
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            expandedTitleScale: 1.0,
          ),
          elevation: 5.0,
        ),
        body: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(
                          0.0,
                          1.0,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'Starting Date',
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                          fontFamily: 'Inter Tight',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                FlutterFlowCalendar(
                  color: FlutterFlowTheme.of(context).primary,
                  iconColor: FlutterFlowTheme.of(context).secondaryText,
                  weekFormat: true,
                  weekStartsMonday: true,
                  onChange: (DateTimeRange? newSelectedDate) {
                    safeSetState(() =>
                        _model.startCalendarSelectedDay = newSelectedDate);
                  },
                  titleStyle: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: 'Inter Tight',
                        letterSpacing: 0.0,
                      ),
                  dayOfWeekStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                  dateStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                  selectedDateStyle:
                      FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                  inactiveDateStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                ),
                Divider(
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.startHoursValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              '19',
                              '29',
                              '21',
                              '22',
                              '23',
                              '24',
                              ''
                            ],
                            onChanged: (val) => safeSetState(
                                () => _model.startHoursValue = val),
                            width: 103.0,
                            height: 40.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: '-',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),
                      Text(
                        'hrs',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: VerticalDivider(
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.startMinsValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              '00',
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              '19',
                              '20',
                              '21',
                              '22',
                              '23',
                              '24',
                              '25',
                              '26',
                              '27',
                              '28',
                              '29',
                              '30',
                              '31',
                              '32',
                              '33',
                              '34',
                              '35',
                              '36',
                              '37',
                              '38',
                              '39',
                              '40',
                              '41',
                              '42',
                              '43',
                              '44',
                              '45',
                              '46',
                              '47',
                              '48',
                              '49',
                              '50',
                              '51',
                              '52',
                              '53',
                              '54',
                              '55',
                              '56',
                              '57',
                              '58',
                              '59',
                              '60'
                            ],
                            onChanged: (val) =>
                                safeSetState(() => _model.startMinsValue = val),
                            width: 103.0,
                            height: 40.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: '-',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),
                      Text(
                        'min',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: VerticalDivider(
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.startSecondsValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              '00',
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              '19',
                              '20',
                              '21',
                              '22',
                              '23',
                              '24',
                              '25',
                              '26',
                              '27',
                              '28',
                              '29',
                              '30',
                              '31',
                              '32',
                              '33',
                              '34',
                              '35',
                              '36',
                              '37',
                              '38',
                              '39',
                              '40',
                              '41',
                              '42',
                              '43',
                              '44',
                              '45',
                              '46',
                              '47',
                              '48',
                              '49',
                              '50',
                              '51',
                              '52',
                              '53',
                              '54',
                              '55',
                              '56',
                              '57',
                              '58',
                              '59',
                              '60'
                            ],
                            onChanged: (val) => safeSetState(
                                () => _model.startSecondsValue = val),
                            width: 103.0,
                            height: 40.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: '-',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),
                      Text(
                        'sc',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].addToStart(SizedBox(width: 10.0)),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'Ending Date',
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                          fontFamily: 'Inter Tight',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                FlutterFlowCalendar(
                  color: FlutterFlowTheme.of(context).primary,
                  iconColor: FlutterFlowTheme.of(context).secondaryText,
                  weekFormat: true,
                  weekStartsMonday: true,
                  onChange: (DateTimeRange? newSelectedDate) {
                    safeSetState(
                        () => _model.endCalendarSelectedDay = newSelectedDate);
                  },
                  titleStyle: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: 'Inter Tight',
                        letterSpacing: 0.0,
                      ),
                  dayOfWeekStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                  dateStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                      ),
                  selectedDateStyle:
                      FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0.0,
                          ),
                  inactiveDateStyle:
                      FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0.0,
                          ),
                ),
                Divider(
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).alternate,
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.endHoursValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              '19',
                              '29',
                              '21',
                              '22',
                              '23',
                              '24',
                              ''
                            ],
                            onChanged: (val) =>
                                safeSetState(() => _model.endHoursValue = val),
                            width: 103.0,
                            height: 40.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: '-',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),
                      Text(
                        'hrs',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: VerticalDivider(
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.endMinsValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              '00',
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              '19',
                              '20',
                              '21',
                              '22',
                              '23',
                              '24',
                              '25',
                              '26',
                              '27',
                              '28',
                              '29',
                              '30',
                              '31',
                              '32',
                              '33',
                              '34',
                              '35',
                              '36',
                              '37',
                              '38',
                              '39',
                              '40',
                              '41',
                              '42',
                              '43',
                              '44',
                              '45',
                              '46',
                              '47',
                              '48',
                              '49',
                              '50',
                              '51',
                              '52',
                              '53',
                              '54',
                              '55',
                              '56',
                              '57',
                              '58',
                              '59',
                              '60'
                            ],
                            onChanged: (val) =>
                                safeSetState(() => _model.endMinsValue = val),
                            width: 103.0,
                            height: 40.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: '-',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),
                      Text(
                        'min',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: VerticalDivider(
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FlutterFlowDropDown<String>(
                            controller: _model.endSecsValueController ??=
                                FormFieldController<String>(null),
                            options: [
                              '00',
                              '01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              '19',
                              '20',
                              '21',
                              '22',
                              '23',
                              '24',
                              '25',
                              '26',
                              '27',
                              '28',
                              '29',
                              '30',
                              '31',
                              '32',
                              '33',
                              '34',
                              '35',
                              '36',
                              '37',
                              '38',
                              '39',
                              '40',
                              '41',
                              '42',
                              '43',
                              '44',
                              '45',
                              '46',
                              '47',
                              '48',
                              '49',
                              '50',
                              '51',
                              '52',
                              '53',
                              '54',
                              '55',
                              '56',
                              '57',
                              '58',
                              '59',
                              '60'
                            ],
                            onChanged: (val) =>
                                safeSetState(() => _model.endSecsValue = val),
                            width: 103.0,
                            height: 40.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: '-',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 8.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ),
                      Text(
                        'sc',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ].addToStart(SizedBox(width: 10.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 76.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFE4E1E1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 10.0, 20.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  'Event Name',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 300.0,
                                height: 71.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                  ),
                                ),
                                child: Container(
                                  width: 200.0,
                                  child: TextFormField(
                                    controller: _model.eventNameTextController,
                                    focusNode: _model.eventNameFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Event Name',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    validator: _model
                                        .eventNameTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 76.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFE4E1E1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 10.0, 20.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  'Event Venue',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 300.0,
                                height: 71.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                  ),
                                ),
                                child: Container(
                                  width: 200.0,
                                  child: TextFormField(
                                    controller: _model.eventVenueTextController,
                                    focusNode: _model.eventVenueFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Event Venue',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                        ),
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    validator: _model
                                        .eventVenueTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 76.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFE4E1E1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                      ),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 10.0, 20.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-1.0, -1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 10.0),
                                child: Text(
                                  'Event Details',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: 300.0,
                                height: 71.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                  ),
                                ),
                                child: Container(
                                  width: 200.0,
                                  child: TextFormField(
                                    controller:
                                        _model.eventDetailsTextController,
                                    focusNode: _model.eventDetailsFocusNode,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      hintText: 'Event Details',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF8EAFC8),
                                          letterSpacing: 0.0,
                                        ),
                                    maxLines: null,
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    validator: _model
                                        .eventDetailsTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (_model.eventNameTextController.text != null &&
                            _model.eventNameTextController.text != '') {
                          if (_model.eventDetailsTextController.text != null &&
                              _model.eventDetailsTextController.text != '') {
                            if ((_model.startHoursValue != '-') ||
                                (_model.startMinsValue != '-') ||
                                (_model.startSecondsValue != '-')) {
                              if ((_model.endHoursValue != '-') ||
                                  (_model.endMinsValue != '-') ||
                                  (_model.endSecsValue != '-')) {
                                if (_model.eventVenueTextController.text !=
                                        null &&
                                    _model.eventVenueTextController.text !=
                                        '') {
                                  _model.startDate =
                                      await actions.combineDateTime(
                                    _model.startCalendarSelectedDay!.start,
                                    _model.startHoursValue!,
                                    _model.startMinsValue!,
                                    _model.startSecondsValue!,
                                    'null',
                                  );
                                  _model.endDate =
                                      await actions.combineDateTime(
                                    _model.endCalendarSelectedDay!.end,
                                    _model.endHoursValue!,
                                    _model.endMinsValue!,
                                    _model.endSecsValue!,
                                    'null',
                                  );

                                  await UpcomingEventsRecord.collection
                                      .doc()
                                      .set(createUpcomingEventsRecordData(
                                        description: _model
                                            .eventDetailsTextController.text,
                                        endDate: _model.endDate,
                                        startDate: _model.startDate,
                                        venue: _model
                                            .eventVenueTextController.text,
                                        name:
                                            _model.eventNameTextController.text,
                                      ));

                                  context.pushNamed('ViewEvents');
                                } else {
                                  // Say event has no start time
                                  await showDialog(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('No Venue!'),
                                        content: Text(
                                            'Please ensure the event has a venue!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                alertDialogContext),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                // Say event has no start time
                                await showDialog(
                                  context: context,
                                  builder: (alertDialogContext) {
                                    return AlertDialog(
                                      title: Text('No End time!'),
                                      content: Text(
                                          'Please ensure all fields of end time are filled!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertDialogContext),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              // Say event has no start time
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('No Start time!'),
                                    content: Text(
                                        'Please ensure all fields of start time are filled!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            // Say EventDetail not set.
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('No description!'),
                                  content: Text(
                                      'Please give a description to the event'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          // Say event is not named.
                          await showDialog(
                            context: context,
                            builder: (alertDialogContext) {
                              return AlertDialog(
                                title: Text('No name!'),
                                content:
                                    Text('Please give a name for the event.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(alertDialogContext),
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        safeSetState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF09E40F),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'Create Event!',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
