import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar_slim/sidebar_slim_widget.dart';
import '/components/finalizacao_aula_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/request_manager.dart';

import 'dart:async';
import 'sala_aula_widget.dart' show SalaAulaWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SalaAulaModel extends FlutterFlowModel<SalaAulaWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<AulasRow>>? salaAulaSupabaseStream;
  // Stores action output result for [Backend Call - Query Rows] action in SalaAula widget.
  List<UsersRow>? userlog;
  // Stores action output result for [Backend Call - Query Rows] action in SalaAula widget.
  List<AulasRow>? aulatual;
  // Stores action output result for [Backend Call - API (SalaJitsi)] action in SalaAula widget.
  ApiCallResponse? apiResulti7f;
  // Model for SidebarSlim component.
  late SidebarSlimModel sidebarSlimModel;
  Stream<List<ConteudosRow>>? rowSupabaseStream;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  bool apiRequestCompleted = false;
  String? apiRequestLastUniqueKey;

  /// Query cache managers for this widget.

  final _conteudoManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> conteudo({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _conteudoManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearConteudoCache() => _conteudoManager.clear();
  void clearConteudoCacheKey(String? uniqueKey) =>
      _conteudoManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {
    sidebarSlimModel = createModel(context, () => SidebarSlimModel());
  }

  @override
  void dispose() {
    sidebarSlimModel.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    /// Dispose query cache managers for this widget.

    clearConteudoCache();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleted;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
