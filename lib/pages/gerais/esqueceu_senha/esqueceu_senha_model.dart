import '/flutter_flow/flutter_flow_util.dart';
import 'esqueceu_senha_widget.dart' show EsqueceuSenhaWidget;
import 'package:flutter/material.dart';

class EsqueceuSenhaModel extends FlutterFlowModel<EsqueceuSenhaWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressTextController;
  String? Function(BuildContext, String?)? emailAddressTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailAddressFocusNode?.dispose();
    emailAddressTextController?.dispose();
  }
}
