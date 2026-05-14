import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/reagendar_aula/reagendar_aula_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'detalhes_aula_model.dart';
export 'detalhes_aula_model.dart';

class DetalhesAulaWidget extends StatefulWidget {
  const DetalhesAulaWidget({
    super.key,
    required this.idAula,
  });

  final String? idAula;

  static String routeName = 'DetalhesAula';
  static String routePath = '/detalhesAula';

  @override
  State<DetalhesAulaWidget> createState() => _DetalhesAulaWidgetState();
}

class _DetalhesAulaWidgetState extends State<DetalhesAulaWidget> {
  late DetalhesAulaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesAulaModel());

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textFieldFocusNode5 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wrapWithModel(
                model: _model.sidebarModel,
                updateCallback: () => safeSetState(() {}),
                child: SidebarWidget(
                  route: 'Aulas',
                ),
              ),
              Expanded(
                child: FutureBuilder<ApiCallResponse>(
                  future: (_model.apiRequestCompleter ??=
                          Completer<ApiCallResponse>()
                            ..complete(SupabaseGroup.detalhesAulaCall.call(
                              pId: widget!.idAula,
                              token: currentJwtToken,
                            )))
                      .future,
                  builder: (context, snapshot) {
                    // Customize what your widget looks like when it's loading.
                    if (snapshot.hasError) {
                      return Scaffold(
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                        body: Center(
                          child: Text('Erro ao carregar dados.',
                              style: FlutterFlowTheme.of(context).bodyMedium),
                        ),
                      );
                    }
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
                    final colContentDetalhesAulaResponse = snapshot.data!;

                    return SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.sizeOf(context).width <
                                      kBreakpointSmall
                                  ? 16.0
                                  : MediaQuery.sizeOf(context).width <
                                          kBreakpointLarge
                                      ? 24.0
                                      : 48.0,
                              vertical: 24.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  _AulaHeader(
                                    theme: FlutterFlowTheme.of(context),
                                    isCompact: MediaQuery.sizeOf(context).width <
                                        kBreakpointMedium,
                                    statusAula:
                                        DetalhesAulaStruct.maybeFromMap(
                                      colContentDetalhesAulaResponse.jsonBody,
                                    )?.statusAula,
                                    onBack: () => context.safePop(),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius:
                                          BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 16.0,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            _AulaSectionTitle(
                                              theme:
                                                  FlutterFlowTheme.of(context),
                                              icon: Icons.info_outline_rounded,
                                              title: 'Informações da aula',
                                              subtitle:
                                                  'Dados da aula, alunos e status.',
                                              trailing: _AulaStatusChip(
                                                theme:
                                                    FlutterFlowTheme.of(context),
                                                status: DetalhesAulaStruct
                                                        .maybeFromMap(
                                                            colContentDetalhesAulaResponse
                                                                .jsonBody)
                                                    ?.statusAula,
                                              ),
                                            ),
                                            _AulaInfoBanner(
                                              theme:
                                                  FlutterFlowTheme.of(context),
                                              isFinalizada: DetalhesAulaStruct
                                                          .maybeFromMap(
                                                              colContentDetalhesAulaResponse
                                                                  .jsonBody)
                                                      ?.statusAula ==
                                                  'Finalizada',
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _model
                                                                    .textController1 ??=
                                                                TextEditingController(
                                                              text: DetalhesAulaStruct
                                                                      .maybeFromMap(
                                                                          colContentDetalhesAulaResponse
                                                                              .jsonBody)
                                                                  ?.nomeTurma,
                                                            ),
                                                            focusNode: _model
                                                                .textFieldFocusNode1,
                                                            autofocus: false,
                                                            readOnly: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              labelText:
                                                                  'Nome da turma',
                                                              labelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                              hintText:
                                                                  'Nome da Turma',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00000000),
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              filled: true,
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                            cursorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            validator: _model
                                                                .textController1Validator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _model
                                                                    .textController2 ??=
                                                                TextEditingController(
                                                              text: DetalhesAulaStruct
                                                                      .maybeFromMap(
                                                                          colContentDetalhesAulaResponse
                                                                              .jsonBody)
                                                                  ?.nivelInicio,
                                                            ),
                                                            focusNode: _model
                                                                .textFieldFocusNode2,
                                                            autofocus: false,
                                                            readOnly: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              labelText:
                                                                  'Módulo',
                                                              labelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                              hintText:
                                                                  'Módulo',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00000000),
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              filled: true,
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                            cursorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            validator: _model
                                                                .textController2Validator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: TextFormField(
                                                            controller: _model
                                                                    .textController3 ??=
                                                                TextEditingController(
                                                              text: DetalhesAulaStruct
                                                                      .maybeFromMap(
                                                                          colContentDetalhesAulaResponse
                                                                              .jsonBody)
                                                                  ?.professorResponsavelNome,
                                                            ),
                                                            focusNode: _model
                                                                .textFieldFocusNode3,
                                                            autofocus: false,
                                                            readOnly: true,
                                                            obscureText: false,
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              labelText:
                                                                  'Professor Responsável',
                                                              labelStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                              hintText:
                                                                  'Professor',
                                                              hintStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0x00000000),
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                              ),
                                                              filled: true,
                                                              fillColor: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                            cursorColor:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                            validator: _model
                                                                .textController3Validator
                                                                .asValidator(
                                                                    context),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      8.0,
                                                                      0.0,
                                                                      8.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _model.textController4 ??=
                                                                            TextEditingController(
                                                                      text:
                                                                          '${dateTimeFormat(
                                                                        "d/M/y",
                                                                        functions
                                                                            .stringToDatetime(DetalhesAulaStruct.maybeFromMap(colContentDetalhesAulaResponse.jsonBody)?.datetimeinicioAula),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )} | ${dateTimeFormat(
                                                                        "Hm",
                                                                        functions
                                                                            .stringToDatetime(DetalhesAulaStruct.maybeFromMap(colContentDetalhesAulaResponse.jsonBody)?.datetimeinicioAula),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )} - ${dateTimeFormat(
                                                                        "Hm",
                                                                        functions
                                                                            .stringToDatetime(DetalhesAulaStruct.maybeFromMap(colContentDetalhesAulaResponse.jsonBody)?.datetimeTerminoaula),
                                                                        locale:
                                                                            FFLocalizations.of(context).languageCode,
                                                                      )}',
                                                                    ),
                                                                    focusNode:
                                                                        _model
                                                                            .textFieldFocusNode4,
                                                                    autofocus:
                                                                        false,
                                                                    readOnly:
                                                                        true,
                                                                    obscureText:
                                                                        false,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                      labelText:
                                                                          'Data da Aula',
                                                                      labelStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                      hintText:
                                                                          'Data da Aula',
                                                                      hintStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.inter(
                                                                              fontWeight: FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                            ),
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).labelMedium.fontStyle,
                                                                          ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).alternate,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              Color(0x00000000),
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      errorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      focusedErrorBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).error,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8.0),
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .primaryBackground,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.inter(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                    cursorColor:
                                                                        FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                    validator: _model
                                                                        .textController4Validator
                                                                        .asValidator(
                                                                            context),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (DetalhesAulaStruct.maybeFromMap(
                                                                          colContentDetalhesAulaResponse
                                                                              .jsonBody)
                                                                      ?.statusAula !=
                                                                  'Finalizada')
                                                                Builder(
                                                                  builder:
                                                                      (context) =>
                                                                          FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (dialogContext) {
                                                                          return Dialog(
                                                                            elevation:
                                                                                0,
                                                                            insetPadding:
                                                                                EdgeInsets.zero,
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            alignment:
                                                                                AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                FocusScope.of(dialogContext).unfocus();
                                                                                FocusManager.instance.primaryFocus?.unfocus();
                                                                              },
                                                                              child: Container(
                                                                                height: MediaQuery.sizeOf(context).height * 0.4,
                                                                                width: MediaQuery.sizeOf(context).width * 0.6,
                                                                                child: ReagendarAulaWidget(
                                                                                  idAula: widget!.idAula!,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    text:
                                                                        'Reagendar aula',
                                                                    icon: Icon(
                                                                      Icons
                                                                          .calendar_month,
                                                                      size:
                                                                          15.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      height:
                                                                          40.0,
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          0.0,
                                                                          16.0,
                                                                          0.0),
                                                                      iconAlignment:
                                                                          IconAlignment
                                                                              .end,
                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleSmall
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.interTight(
                                                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        _AulaAlunosBlock(
                                                          theme: FlutterFlowTheme
                                                              .of(context),
                                                          label:
                                                              'Alunos escalados',
                                                          icon: Icons
                                                              .groups_rounded,
                                                          nomes: (DetalhesAulaStruct
                                                                          .maybeFromMap(
                                                                              colContentDetalhesAulaResponse
                                                                                  .jsonBody)
                                                                      ?.alunosConvidados ??
                                                                  [])
                                                              .map((e) => e.nome)
                                                              .toList(),
                                                          emptyText:
                                                              'Nenhum aluno escalado.',
                                                        ),
                                                        if (DetalhesAulaStruct
                                                                    .maybeFromMap(
                                                                        colContentDetalhesAulaResponse
                                                                            .jsonBody)
                                                                ?.statusAula ==
                                                            'Finalizada')
                                                          _AulaAlunosBlock(
                                                            theme:
                                                                FlutterFlowTheme
                                                                    .of(context),
                                                            label:
                                                                'Alunos presentes',
                                                            icon: Icons
                                                                .how_to_reg_rounded,
                                                            nomes: (DetalhesAulaStruct.maybeFromMap(colContentDetalhesAulaResponse.jsonBody)?.alunosPresentes ??
                                                                    [])
                                                                .map((e) =>
                                                                    e.nome)
                                                                .toList(),
                                                            emptyText:
                                                                'Nenhum aluno marcou presença.',
                                                          ),
                                                      ].divide(SizedBox(
                                                          height: 12.0)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(height: 20.0)),
                                        ),
                                      ),
                                    ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius:
                                          BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 16.0,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _AulaSectionTitle(
                                            theme:
                                                FlutterFlowTheme.of(context),
                                            icon: Icons.menu_book_outlined,
                                            title: 'Planning',
                                            subtitle:
                                                'Conteúdos vinculados, utilizados e anotações.',
                                          ),
                                          _PlanningSection(
                                            theme:
                                                FlutterFlowTheme.of(context),
                                            data: DetalhesAulaStruct
                                                .maybeFromMap(
                                                    colContentDetalhesAulaResponse
                                                        .jsonBody),
                                            idAula: widget!.idAula,
                                            textController: _model
                                                    .textController5 ??=
                                                TextEditingController(
                                              text: DetalhesAulaStruct
                                                      .maybeFromMap(
                                                          colContentDetalhesAulaResponse
                                                              .jsonBody)
                                                  ?.anotacoesComentarios,
                                            ),
                                            textFocusNode: _model
                                                    .textFieldFocusNode5 ??=
                                                FocusNode(),
                                            finalizada: DetalhesAulaStruct
                                                        .maybeFromMap(
                                                            colContentDetalhesAulaResponse
                                                                .jsonBody)
                                                    ?.statusAula ==
                                                'Finalizada',
                                            aguardandoPlanning:
                                                DetalhesAulaStruct
                                                            .maybeFromMap(
                                                                colContentDetalhesAulaResponse
                                                                    .jsonBody)
                                                        ?.statusAula ==
                                                    'Aguardando Planning',
                                            onRemoverConteudo:
                                                (conteudoId) async {
                                              _model.apiRemoverConteudo =
                                                  await SupabaseGroup
                                                      .removerConteudoVinculadoCall
                                                      .call(
                                                pAulaId: widget!.idAula,
                                                pConteudoId: conteudoId,
                                                token: currentJwtToken,
                                              );
                                              if ((_model
                                                      .apiRemoverConteudo
                                                      ?.succeeded ??
                                                  false)) {
                                                safeSetState(() => _model
                                                    .apiRequestCompleter = null);
                                                await _model
                                                    .waitForApiRequestCompleted();
                                              }
                                              safeSetState(() {});
                                            },
                                            onConcluirPlanning: () async {
                                              await AulasTable().update(
                                                data: {
                                                  'status_aula':
                                                      'Planning Concluído',
                                                },
                                                matchingRows: (rows) => rows
                                                    .eqOrNull(
                                                        'id', widget!.idAula),
                                              );
                                              _model.apiResulthcv =
                                                  await SupabaseGroup
                                                      .criarAulaNoPlanningCall
                                                      .call(
                                                pTurmaId: DetalhesAulaStruct
                                                        .maybeFromMap(
                                                            colContentDetalhesAulaResponse
                                                                .jsonBody)
                                                    ?.turma,
                                                data: DetalhesAulaStruct
                                                        .maybeFromMap(
                                                            colContentDetalhesAulaResponse
                                                                .jsonBody)
                                                    ?.datetimeinicioAula,
                                                token: currentJwtToken,
                                              );
                                              if ((_model.apiResulthcv
                                                      ?.succeeded ??
                                                  true)) {
                                                _model.alunosTurma =
                                                    await MetaAlunosTable()
                                                        .queryRows(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'turma',
                                                    DetalhesAulaStruct
                                                            .maybeFromMap(
                                                                colContentDetalhesAulaResponse
                                                                    .jsonBody)
                                                        ?.turma,
                                                  ),
                                                );
                                                await AulasTable().update(
                                                  data: {
                                                    'alunos_convidados':
                                                        _model.alunosTurma
                                                            ?.map((e) =>
                                                                e.userId)
                                                            .withoutNulls
                                                            .toList(),
                                                  },
                                                  matchingRows: (rows) =>
                                                      rows.eqOrNull(
                                                    'id',
                                                    SupabaseGroup
                                                        .criarAulaNoPlanningCall
                                                        .idaula(
                                                      _model.apiResulthcv
                                                              ?.jsonBody ??
                                                          '',
                                                    ),
                                                  ),
                                                );
                                                if (!context.mounted) return;
                                                context.pushNamed(
                                                  DetalhesAulaWidget
                                                      .routeName,
                                                  queryParameters: {
                                                    'idAula': serializeParam(
                                                        widget!.idAula,
                                                        ParamType.String),
                                                  }.withoutNulls,
                                                );
                                              } else {
                                                if (!context.mounted) return;
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (alertDialogContext) {
                                                    return AlertDialog(
                                                      title: Text((_model
                                                                  .apiResulthcv
                                                                  ?.jsonBody ??
                                                              '')
                                                          .toString()),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  alertDialogContext),
                                                          child: Text('Ok'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              safeSetState(() {});
                                            },
                                          ),
                                        ].divide(SizedBox(height: 20.0)),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 16.0)),
                              ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Helpers visuais — polish da tela Detalhes da Aula
// ===========================================================================

class _AulaHeader extends StatelessWidget {
  const _AulaHeader({
    required this.theme,
    required this.isCompact,
    required this.statusAula,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String? statusAula;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isFinalizada = (statusAula ?? '').toLowerCase() == 'finalizada';
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_note_rounded, size: 14.0, color: theme.primary),
          const SizedBox(width: 6.0),
          Text(
            'Aula',
            style: GoogleFonts.interTight(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: theme.primary,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );

    final titleCol = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        chip,
        const SizedBox(height: 12.0),
        Text(
          'Detalhes da aula',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.headlineMedium.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
            fontSize: isCompact ? 22.0 : 26.0,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          isFinalizada
              ? 'Visualização do histórico — não é possível editar.'
              : 'Informações, planning e anotações desta aula.',
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 14.0,
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
      ],
    );

    final backBtn = _AulaBackButton(theme: theme, onTap: onBack);

    if (isCompact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: backBtn,
          ),
          const SizedBox(width: 12.0),
          Expanded(child: titleCol),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: backBtn,
        ),
        const SizedBox(width: 14.0),
        Expanded(child: titleCol),
      ],
    );
  }
}

class _AulaBackButton extends StatefulWidget {
  const _AulaBackButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_AulaBackButton> createState() => _AulaBackButtonState();
}

class _AulaBackButtonState extends State<_AulaBackButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: _hover
                ? t.primary.withValues(alpha: 0.10)
                : t.primaryBackground,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: t.alternate, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: widget.onTap,
              child: Tooltip(
                message: 'Voltar',
                child: Center(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 18.0,
                    color: _hover ? t.primary : t.primaryText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AulaSectionTitle extends StatelessWidget {
  const _AulaSectionTitle({
    required this.theme,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 38.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10.0),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: theme.primary, size: 20.0),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleMedium.override(
                  font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryText,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2.0),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: theme.secondaryText,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12.0),
          trailing!,
        ],
      ],
    );
  }
}

class _AulaStatusChip extends StatelessWidget {
  const _AulaStatusChip({required this.theme, required this.status});

  final FlutterFlowTheme theme;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final raw = (status ?? '').trim();
    final lower = raw.toLowerCase();
    Color bg;
    Color fg;
    IconData icon;
    String label = raw.isEmpty ? 'Sem status' : raw;
    if (lower.contains('cancel')) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFF991B1B);
      icon = Icons.cancel_rounded;
    } else if (lower.contains('aguard')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
      icon = Icons.schedule_rounded;
    } else if (lower.contains('andamento') || lower.contains('iniciada')) {
      bg = const Color(0xFFDBEAFE);
      fg = const Color(0xFF1E40AF);
      icon = Icons.play_circle_fill_rounded;
    } else if (lower.contains('conclu') ||
        lower.contains('finaliz') ||
        lower == 'finalizada') {
      bg = const Color(0xFFD1FAE5);
      fg = const Color(0xFF065F46);
      icon = Icons.check_circle_rounded;
    } else if (raw.isEmpty) {
      bg = theme.alternate.withValues(alpha: 0.5);
      fg = theme.secondaryText;
      icon = Icons.help_outline_rounded;
    } else {
      bg = theme.primary.withValues(alpha: 0.10);
      fg = theme.primary;
      icon = Icons.info_outline_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.0, color: fg),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: GoogleFonts.interTight(
              fontWeight: FontWeight.w800,
              fontSize: 12.0,
              color: fg,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AulaAlunosBlock extends StatelessWidget {
  const _AulaAlunosBlock({
    required this.theme,
    required this.label,
    required this.nomes,
    this.icon = Icons.groups_rounded,
    this.emptyText = 'Nenhum aluno',
  });

  final FlutterFlowTheme theme;
  final String label;
  final List<String> nomes;
  final IconData icon;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.0, color: theme.secondaryText),
              const SizedBox(width: 6.0),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.interTight(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: theme.secondaryText,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Text(
                  nomes.length.toString(),
                  style: GoogleFonts.interTight(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primary,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          if (nomes.isEmpty)
            Text(
              emptyText,
              style: GoogleFonts.inter(
                fontSize: 13.0,
                color: theme.secondaryText,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: nomes
                  .map((n) => _AulaAlunoChip(theme: theme, nome: n))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _AulaAlunoChip extends StatelessWidget {
  const _AulaAlunoChip({required this.theme, required this.nome});

  final FlutterFlowTheme theme;
  final String nome;

  @override
  Widget build(BuildContext context) {
    final n = nome.trim();
    final initial = n.isNotEmpty ? n.characters.first.toUpperCase() : '?';
    return Container(
      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.18),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary.withValues(alpha: 0.14),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: GoogleFonts.interTight(
                fontSize: 11.0,
                fontWeight: FontWeight.w800,
                color: theme.primary,
                letterSpacing: 0.0,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            n.isEmpty ? '—' : n,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AulaInfoBanner extends StatelessWidget {
  const _AulaInfoBanner({required this.theme, required this.isFinalizada});

  final FlutterFlowTheme theme;
  final bool isFinalizada;

  @override
  Widget build(BuildContext context) {
    final color = isFinalizada
        ? const Color(0xFF065F46)
        : const Color(0xFF92400E);
    final bg = isFinalizada
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFEF3C7);
    final icon = isFinalizada
        ? Icons.check_circle_rounded
        : Icons.info_rounded;
    final title = isFinalizada ? 'Aula finalizada' : 'Apenas visualização';
    final body = isFinalizada
        ? 'Esta tela mostra o histórico desta aula. Edição não é permitida.'
        : 'As informações abaixo são apenas para consulta. Para editar, acesse "Detalhes da Turma".';

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withValues(alpha: 0.20), width: 1.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.interTight(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: color,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Planning — helpers visuais portados do stepout-franqueado
// ===========================================================================

class _PlanningSection extends StatelessWidget {
  const _PlanningSection({
    required this.theme,
    required this.data,
    required this.idAula,
    required this.textController,
    required this.textFocusNode,
    required this.finalizada,
    required this.aguardandoPlanning,
    required this.onRemoverConteudo,
    required this.onConcluirPlanning,
  });

  final FlutterFlowTheme theme;
  final DetalhesAulaStruct? data;
  final String? idAula;
  final TextEditingController? textController;
  final FocusNode? textFocusNode;
  final bool finalizada;
  final bool aguardandoPlanning;
  final Future<void> Function(String? conteudoId) onRemoverConteudo;
  final VoidCallback onConcluirPlanning;

  @override
  Widget build(BuildContext context) {
    final vinculados =
        data?.conteudosVinculados ?? const <ConteudosAulaStruct>[];
    final utilizados =
        data?.conteudosUtilizados ?? const <ConteudosAulaStruct>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ConteudosVinculadosBlock(
          theme: theme,
          conteudos: vinculados,
          finalizada: finalizada,
          onAdd: () => context.pushNamed(
            ModulosWidget.routeName,
            queryParameters: {
              'aula': serializeParam(idAula, ParamType.String),
            }.withoutNulls,
          ),
          onRemover: onRemoverConteudo,
        ),
        if (finalizada) ...[
          const SizedBox(height: 14.0),
          _ConteudosUtilizadosBlock(theme: theme, conteudos: utilizados),
        ],
        const SizedBox(height: 16.0),
        _LabeledField(
          theme: theme,
          label: 'Anotações e comentários',
          child: TextFormField(
            controller: textController,
            focusNode: textFocusNode,
            readOnly: finalizada,
            onChanged: finalizada
                ? null
                : (_) => EasyDebounce.debounce(
                      '_model.textController5',
                      const Duration(milliseconds: 2000),
                      () async {
                        await AulasTable().update(
                          data: {
                            'anotacoes_comentarios':
                                textController?.text ?? '',
                          },
                          matchingRows: (rows) => rows.eqOrNull('id', idAula),
                        );
                      },
                    ),
            maxLines: null,
            minLines: 5,
            style: _fieldTextStyle(theme),
            cursorColor: theme.primary,
            decoration: _fieldDecoration(
              theme,
              hint:
                  'Anote pontos importantes desta aula, observações sobre alunos, planejamento...',
              readOnly: finalizada,
            ),
          ),
        ),
        if (aguardandoPlanning) ...[
          const SizedBox(height: 18.0),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _PrimaryActionButton(
              theme: theme,
              icon: Icons.task_alt_rounded,
              label: 'Concluir planning',
              onTap: onConcluirPlanning,
            ),
          ),
        ],
      ],
    );
  }
}

class _ConteudosVinculadosBlock extends StatelessWidget {
  const _ConteudosVinculadosBlock({
    required this.theme,
    required this.conteudos,
    required this.finalizada,
    required this.onAdd,
    required this.onRemover,
  });

  final FlutterFlowTheme theme;
  final List<ConteudosAulaStruct> conteudos;
  final bool finalizada;
  final VoidCallback onAdd;
  final Future<void> Function(String? conteudoId) onRemover;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.bookmark_added_rounded,
                    color: theme.primary, size: 16.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Conteúdos vinculados',
                      style: theme.titleSmall.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      finalizada
                          ? 'Conteúdos definidos para esta aula.'
                          : 'Acesse e vincule conteúdos para esta aula.',
                      style: theme.bodySmall.override(
                        font:
                            GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              if (!finalizada)
                _PrimaryActionButton(
                  theme: theme,
                  icon: Icons.add_rounded,
                  label: 'Vincular conteúdo',
                  onTap: onAdd,
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          if (conteudos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.bookmarks_outlined,
                      color: theme.secondaryText, size: 16.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Nenhum conteúdo vinculado ainda.',
                      style: theme.bodyMedium.override(
                        font:
                            GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: conteudos.map((c) {
                return _ConteudoChip(
                  theme: theme,
                  nome: c.nomeConteudo,
                  removable: !finalizada,
                  onRemove: () => onRemover(c.uuid),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _ConteudosUtilizadosBlock extends StatelessWidget {
  const _ConteudosUtilizadosBlock({
    required this.theme,
    required this.conteudos,
  });

  final FlutterFlowTheme theme;
  final List<ConteudosAulaStruct> conteudos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
            color: theme.success.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: theme.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.task_alt_rounded,
                    color: theme.success, size: 16.0),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Conteúdos utilizados',
                      style: theme.titleSmall.override(
                        font: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Conteúdos efetivamente trabalhados durante a aula.',
                      style: theme.bodySmall.override(
                        font:
                            GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          if (conteudos.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 14.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment_late_outlined,
                      color: theme.secondaryText, size: 16.0),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Nenhum conteúdo registrado.',
                      style: theme.bodyMedium.override(
                        font:
                            GoogleFonts.inter(fontWeight: FontWeight.w500),
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: conteudos.map((c) {
                return _ConteudoChip(
                  theme: theme,
                  nome: c.nomeConteudo,
                  removable: false,
                  accent: theme.success,
                  onRemove: () {},
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _ConteudoChip extends StatefulWidget {
  const _ConteudoChip({
    required this.theme,
    required this.nome,
    required this.removable,
    required this.onRemove,
    this.accent,
  });

  final FlutterFlowTheme theme;
  final String nome;
  final bool removable;
  final VoidCallback onRemove;
  final Color? accent;

  @override
  State<_ConteudoChip> createState() => _ConteudoChipState();
}

class _ConteudoChipState extends State<_ConteudoChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final accent = widget.accent ?? theme.primary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.fromLTRB(
            12.0, 8.0, widget.removable ? 8.0 : 12.0, 8.0),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: _hovered ? 0.14 : 0.10),
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(
            color: accent.withValues(alpha: _hovered ? 0.5 : 0.25),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, color: accent, size: 14.0),
            const SizedBox(width: 8.0),
            Text(
              widget.nome.isEmpty ? '—' : widget.nome,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontWeight: FontWeight.w600,
                fontSize: 13.0,
                color: accent,
              ),
            ),
            if (widget.removable) ...[
              const SizedBox(width: 6.0),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  width: 22.0,
                  height: 22.0,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.close_rounded,
                      color: accent, size: 13.0),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatefulWidget {
  const _PrimaryActionButton({
    required this.theme,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<_PrimaryActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.98 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 44.0,
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: theme.primary
                      .withValues(alpha: _hovered ? 0.30 : 0.18),
                  blurRadius: _hovered ? 18.0 : 12.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: Colors.white, size: 18.0),
                const SizedBox(width: 8.0),
                Text(
                  widget.label,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                    color: Colors.white,
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.theme,
    required this.label,
    required this.child,
  });

  final FlutterFlowTheme theme;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.labelSmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            letterSpacing: 0.4,
            color: theme.secondaryText,
          ),
        ),
        const SizedBox(height: 6.0),
        child,
      ],
    );
  }
}

InputDecoration _fieldDecoration(FlutterFlowTheme theme,
    {String? hint, IconData? prefix, bool readOnly = false}) {
  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: theme.labelMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w400),
      fontWeight: FontWeight.w400,
      fontSize: 13.5,
      color: theme.secondaryText,
    ),
    prefixIcon: prefix == null
        ? null
        : Icon(prefix, color: theme.secondaryText, size: 18.0),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
    filled: true,
    fillColor: readOnly
        ? theme.secondaryBackground.withValues(alpha: 0.6)
        : theme.secondaryBackground,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: readOnly ? theme.alternate : theme.primary,
        width: readOnly ? 1.0 : 1.4,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.error, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(color: theme.error, width: 1.4),
    ),
  );
}

TextStyle _fieldTextStyle(FlutterFlowTheme theme) =>
    theme.bodyMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: theme.primaryText,
    );
