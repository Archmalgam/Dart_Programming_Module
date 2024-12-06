import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'startpage_model.dart';
export 'startpage_model.dart';

class StartpageWidget extends StatefulWidget {
  const StartpageWidget({super.key});

  @override
  State<StartpageWidget> createState() => _StartpageWidgetState();
}

class _StartpageWidgetState extends State<StartpageWidget> {
  late StartpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StartpageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: StreamBuilder<List<AdministratorsRecord>>(
              stream: queryAdministratorsRecord(
                singleRecord: true,
              ),
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
                List<AdministratorsRecord> buttonAdministratorsRecordList =
                    snapshot.data!;
                // Return an empty Container when the item does not exist.
                if (snapshot.data!.isEmpty) {
                  return Container();
                }
                final buttonAdministratorsRecord =
                    buttonAdministratorsRecordList.isNotEmpty
                        ? buttonAdministratorsRecordList.first
                        : null;

                return FFButtonWidget(
                  onPressed: () async {
                    GoRouter.of(context).prepareAuthEvent();

                    final user = await authManager.signInWithEmail(
                      context,
                      'AD00000@CampusConnect.com',
                      'JohnDoe',
                    );
                    if (user == null) {
                      return;
                    }

                    _model.outOut = await queryAdministratorsRecordOnce(
                      queryBuilder: (administratorsRecord) =>
                          administratorsRecord.where(
                        'AdminID',
                        isEqualTo: 'AD00000',
                      ),
                      singleRecord: true,
                    ).then((s) => s.firstOrNull);
                    FFAppState().LoggedInAdministrator =
                        _model.outOut?.reference;
                    FFAppState().LoggedInAdminID =
                        buttonAdministratorsRecord!.adminID;

                    context.pushNamedAuth('HomePage', context.mounted);

                    safeSetState(() {});
                  },
                  text: '${buttonAdministratorsRecord?.adminID}',
                  options: FFButtonOptions(
                    height: 40.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter Tight',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
