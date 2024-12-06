import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        drawer: Drawer(
          elevation: 16.0,
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
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
                        'Home Page',
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
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 20.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('ViewEvents');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
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
                                  50.0, 0.0, 50.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Text(
                                          'Manage Academic Calendar',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/download.png',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.contain,
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
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 20.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('SearchForUsers');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
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
                                  50.0, 0.0, 50.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          'assets/images/UsersIcon.png',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        child: Text(
                                          'Manage Students \nand lecturers',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 20.0,
                                                letterSpacing: 0.0,
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
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 20.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('CreatingNewUsers');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
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
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                50.0, 0.0, 50.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Text(
                                        'Add new user',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/Add_New_User.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.contain,
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
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 20.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('AssigningFees');
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
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
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                50.0, 0.0, 50.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/FeesIcon.png',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Text(
                                        'Assign Fees',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
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
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 20.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          GoRouter.of(context).prepareAuthEvent();
                          await authManager.signOut();
                          GoRouter.of(context).clearRedirectLocation();

                          context.goNamedAuth('STARTPAGE', context.mounted);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
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
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                50.0, 0.0, 50.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 10.0, 0.0),
                                      child: Text(
                                        'Logout',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              fontSize: 20.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.logout_sharp,
                                  color: Color(0xFFFF0000),
                                  size: 100.0,
                                ),
                              ],
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
      ),
    );
  }
}
