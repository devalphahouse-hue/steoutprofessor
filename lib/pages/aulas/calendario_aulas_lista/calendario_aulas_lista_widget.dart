import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/detect_browser.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calendario_aulas_lista_model.dart';
export 'calendario_aulas_lista_model.dart';

class CalendarioAulasListaWidget extends StatefulWidget {
  const CalendarioAulasListaWidget({super.key});

  static String routeName = 'CalendarioAulasLista';
  static String routePath = '/calendarioAulasLista';

  @override
  State<CalendarioAulasListaWidget> createState() =>
      _CalendarioAulasListaWidgetState();
}

class _CalendarioAulasListaWidgetState
    extends State<CalendarioAulasListaWidget> {
  late CalendarioAulasListaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarioAulasListaModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().dataParamentroCalendario = getCurrentTimestamp;
      safeSetState(() {});
      FFAppState().ListaDiasCalendarioAulas = functions
          .gerarLista7Dias(getCurrentTimestamp)!
          .toList()
          .cast<DiaCalendarioAulasStruct>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
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
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(valueOrDefault<double>(
                          MediaQuery.sizeOf(context).width < kBreakpointSmall
                              ? 16.0
                              : 48.0,
                          0.0,
                        )),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          constraints: BoxConstraints(
                            maxWidth: 1440.0,
                          ),
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Calendário de Aulas',
                                style: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                'Acompanhe as próximas aulas programadas',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Material(
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4.0,
                                        color: Color(0x33000000),
                                        offset: Offset(
                                          0.0,
                                          2.0,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  alignment: AlignmentDirectional(-1.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        FutureBuilder<List<AulasRow>>(
                                          future: AulasTable().queryRows(
                                            queryFn: (q) => q
                                                .eqOrNull(
                                                  'professor_responsavel',
                                                  currentUserUid,
                                                )
                                                .gteOrNull(
                                                  'datetimeinicio_aula',
                                                  supaSerialize<DateTime>(
                                                      getCurrentTimestamp),
                                                )
                                                .order('datetimeinicio_aula',
                                                    ascending: true),
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            List<AulasRow>
                                                listViewAulasRowList =
                                                snapshot.data!;

                                            return ListView.separated(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount:
                                                  listViewAulasRowList.length,
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(height: 12.0),
                                              itemBuilder:
                                                  (context, listViewIndex) {
                                                final listViewAulasRow =
                                                    listViewAulasRowList[
                                                        listViewIndex];
                                                return Material(
                                                  color: Colors.transparent,
                                                  elevation: 2.0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Container(
                                                    width: 100.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                dateTimeFormat(
                                                                  "d/M H:mm",
                                                                  listViewAulasRow
                                                                      .datetimeinicioAula!,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .interTight(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .titleMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .titleMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              FutureBuilder<
                                                                  List<
                                                                      TurmasRow>>(
                                                                future: TurmasTable()
                                                                    .querySingleRow(
                                                                  queryFn: (q) =>
                                                                      q.eqOrNull(
                                                                    'id',
                                                                    listViewAulasRow
                                                                        .turma,
                                                                  ),
                                                                ),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  // Customize what your widget looks like when it's loading.
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            50.0,
                                                                        height:
                                                                            50.0,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          valueColor:
                                                                              AlwaysStoppedAnimation<Color>(
                                                                            FlutterFlowTheme.of(context).primary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  List<TurmasRow>
                                                                      textTurmasRowList =
                                                                      snapshot
                                                                          .data!;

                                                                  final textTurmasRow = textTurmasRowList
                                                                          .isNotEmpty
                                                                      ? textTurmasRowList
                                                                          .first
                                                                      : null;

                                                                  return Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      textTurmasRow
                                                                          ?.nomeDaTurma,
                                                                      'nomeTurma',
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
                                                                  );
                                                                },
                                                              ),
                                                              Text(
                                                                valueOrDefault<
                                                                    String>(
                                                                  listViewAulasRow
                                                                      .statusAula,
                                                                  'statusAula',
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
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
                                                              ),
                                                              Text(
                                                                '${dateTimeFormat(
                                                                  "Hm",
                                                                  listViewAulasRow
                                                                      .datetimeinicioAula,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                )} - ${dateTimeFormat(
                                                                  "Hm",
                                                                  listViewAulasRow
                                                                      .datetimeTerminoaula,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                )}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .inter(
                                                                        fontWeight: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(context)
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
                                                              ),
                                                            ].divide(SizedBox(
                                                                height: 5.0)),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              InkWell(
                                                                splashColor: Colors
                                                                    .transparent,
                                                                focusColor: Colors
                                                                    .transparent,
                                                                hoverColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                onTap:
                                                                    () async {
                                                                  context
                                                                      .pushNamed(
                                                                    DetalhesAulaWidget
                                                                        .routeName,
                                                                    queryParameters:
                                                                        {
                                                                      'idAula':
                                                                          serializeParam(
                                                                        listViewAulasRow
                                                                            .id,
                                                                        ParamType
                                                                            .String,
                                                                      ),
                                                                    }.withoutNulls,
                                                                  );
                                                                },
                                                                child: Text(
                                                                  '+ ver mais',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .inter(
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
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
                                                                ),
                                                              ),
                                                              if ((getCurrentTimestamp
                                                                          .secondsSinceEpoch >=
                                                                      functions
                                                                          .inicioMenos5Min(listViewAulasRow
                                                                              .datetimeinicioAula)!
                                                                          .secondsSinceEpoch) &&
                                                                  (getCurrentTimestamp
                                                                          .secondsSinceEpoch <=
                                                                      listViewAulasRow
                                                                          .datetimeTerminoaula!
                                                                          .secondsSinceEpoch))
                                                                FFButtonWidget(
                                                                  onPressed:
                                                                      () async {
                                                                    final confirmou =
                                                                        await showDialog<bool>(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          false,
                                                                      builder:
                                                                          (dialogContext) {
                                                                        final browserName = detectBrowser();
                                                                        final isChrome = browserName == 'chrome';
                                                                        bool aceitou = false;
                                                                        return StatefulBuilder(
                                                                          builder: (stfContext, setDialogState) {
                                                                            return AlertDialog(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(16.0),
                                                                              ),
                                                                              title: Text(
                                                                                'Antes de entrar na aula',
                                                                                style: FlutterFlowTheme.of(context).headlineSmall.override(
                                                                                      font: GoogleFonts.interTight(
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                      letterSpacing: 0.0,
                                                                                    ),
                                                                              ),
                                                                              content: SingleChildScrollView(
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    if (!isChrome) ...[
                                                                                      Container(
                                                                                        width: double.infinity,
                                                                                        padding: EdgeInsets.all(12.0),
                                                                                        decoration: BoxDecoration(
                                                                                          color: Color(0xFFFEE2E2),
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                          border: Border.all(color: Color(0xFFFCA5A5)),
                                                                                        ),
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 22),
                                                                                            SizedBox(width: 8.0),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                'Voce esta usando ${browserDisplayName(browserName)}. Recomendamos fortemente o Google Chrome para evitar problemas de audio e video durante a aula.',
                                                                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                      font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                                                                                      color: Color(0xFFDC2626),
                                                                                                      letterSpacing: 0.0,
                                                                                                    ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(height: 16.0),
                                                                                    ],
                                                                                    Text(
                                                                                      'Para garantir a melhor experiencia na aula ao vivo, siga estas dicas:',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            font: GoogleFonts.inter(
                                                                                              fontWeight: FontWeight.normal,
                                                                                            ),
                                                                                            letterSpacing: 0.0,
                                                                                          ),
                                                                                    ),
                                                                                    SizedBox(height: 16.0),
                                                                                    _buildDicaItem(context, '1.', 'Use o Google Chrome — e o navegador mais compativel com a videochamada. Edge, Safari e Firefox podem causar problemas de audio e travamentos'),
                                                                                    _buildDicaItem(context, '2.', 'Verifique sua internet — abra outro site para confirmar. Conexoes instaveis causam travamento de video e quedas de audio'),
                                                                                    _buildDicaItem(context, '3.', 'Prefira cabo ou Wi-Fi forte — dados moveis (4G/5G) podem ser instaveis. Se estiver no Wi-Fi, fique proximo ao roteador'),
                                                                                    _buildDicaItem(context, '4.', 'Feche outros programas e abas — cada aba aberta consome memoria e banda. Feche tudo que nao for essencial'),
                                                                                    _buildDicaItem(context, '5.', 'Evite computador sobrecarregado — se seu PC estiver lento, reinicie-o antes da aula'),
                                                                                    _buildDicaItem(context, '6.', 'Teste camera e microfone antes — ao entrar na aula, voce vera uma tela para selecionar e testar seus dispositivos'),
                                                                                    SizedBox(height: 12.0),
                                                                                    Row(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: 24,
                                                                                          height: 24,
                                                                                          child: Checkbox(
                                                                                            value: aceitou,
                                                                                            activeColor: FlutterFlowTheme.of(context).primary,
                                                                                            onChanged: (v) => setDialogState(() => aceitou = v ?? false),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 8.0),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            'Li e entendi as recomendacoes',
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                                                                                                  letterSpacing: 0.0,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                FFButtonWidget(
                                                                                  onPressed: aceitou ? () => Navigator.of(dialogContext).pop(true) : null,
                                                                                  text: 'Confirmar e entrar',
                                                                                  options: FFButtonOptions(
                                                                                    height: 44.0,
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                                    color: aceitou ? FlutterFlowTheme.of(context).primary : Color(0xFFCCCCCC),
                                                                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                          font: GoogleFonts.interTight(
                                                                                            fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                                          ),
                                                                                          color: Colors.white,
                                                                                          letterSpacing: 0.0,
                                                                                        ),
                                                                                    elevation: 0.0,
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                    if (confirmou !=
                                                                        true) {
                                                                      return;
                                                                    }

                                                                    FFAppState()
                                                                        .jaasJWT = '';
                                                                    safeSetState(
                                                                        () {});

                                                                    context
                                                                        .pushNamed(
                                                                      SalaAulaWidget
                                                                          .routeName,
                                                                      queryParameters:
                                                                          {
                                                                        'aulaId':
                                                                            serializeParam(
                                                                          listViewAulasRow
                                                                              .id,
                                                                          ParamType
                                                                              .String,
                                                                        ),
                                                                      }.withoutNulls,
                                                                    );
                                                                  },
                                                                  text:
                                                                      'Entrar na aula',
                                                                  options:
                                                                      FFButtonOptions(
                                                                    height:
                                                                        40.0,
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            32.0,
                                                                            0.0,
                                                                            32.0,
                                                                            0.0),
                                                                    iconPadding:
                                                                        EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    textStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .titleSmall
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.interTight(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                                                          ),
                                                                          color:
                                                                              Colors.white,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .titleSmall
                                                                              .fontStyle,
                                                                        ),
                                                                    elevation:
                                                                        0.0,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                            ].divide(SizedBox(
                                                                width: 20.0)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDicaItem(BuildContext context, String numero, String texto) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            numero,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  letterSpacing: 0.0,
                ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              texto,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.normal),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
