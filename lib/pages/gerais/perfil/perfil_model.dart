import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import 'perfil_widget.dart' show PerfilWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class PerfilModel extends FlutterFlowModel<PerfilWidget> {
  ///  Local state fields for this page.

  List<VinculacaoTurmasStruct> vincularTurmas = [];
  void addToVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.add(item);
  void removeFromVincularTurmas(VinculacaoTurmasStruct item) =>
      vincularTurmas.remove(item);
  void removeAtIndexFromVincularTurmas(int index) =>
      vincularTurmas.removeAt(index);
  void insertAtIndexInVincularTurmas(int index, VinculacaoTurmasStruct item) =>
      vincularTurmas.insert(index, item);
  void updateVincularTurmasAtIndex(
          int index, Function(VinculacaoTurmasStruct) updateFn) =>
      vincularTurmas[index] = updateFn(vincularTurmas[index]);

  ///  State fields for stateful widgets in this page.

  // Model for Sidebar component.
  late SidebarModel sidebarModel;
  // State field(s) for TextFieldNome widget.
  FocusNode? textFieldNomeFocusNode;
  TextEditingController? textFieldNomeTextController;
  String? Function(BuildContext, String?)? textFieldNomeTextControllerValidator;
  // State field(s) for TextFieldEmail widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  // State field(s) for TextFieldTelefone widget.
  FocusNode? textFieldTelefoneFocusNode;
  TextEditingController? textFieldTelefoneTextController;
  late MaskTextInputFormatter textFieldTelefoneMask;
  String? Function(BuildContext, String?)?
      textFieldTelefoneTextControllerValidator;
  // State field(s) for TextFieldCPF widget.
  FocusNode? textFieldCPFFocusNode;
  TextEditingController? textFieldCPFTextController;
  late MaskTextInputFormatter textFieldCPFMask;
  String? Function(BuildContext, String?)? textFieldCPFTextControllerValidator;
  // State field(s) for TextFieldDNasc widget.
  FocusNode? textFieldDNascFocusNode;
  TextEditingController? textFieldDNascTextController;
  late MaskTextInputFormatter textFieldDNascMask;
  String? Function(BuildContext, String?)?
      textFieldDNascTextControllerValidator;
  // State field(s) for TextFieldNocion widget.
  FocusNode? textFieldNocionFocusNode;
  TextEditingController? textFieldNocionTextController;
  String? Function(BuildContext, String?)?
      textFieldNocionTextControllerValidator;
  bool isDataUploading_uploadSubsFotoPerfilFranquia = false;
  FFUploadedFile uploadedLocalFile_uploadSubsFotoPerfilFranquia =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadSubsFotoPerfilFranquia = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController7;
  late MaskTextInputFormatter textFieldMask;
  String? Function(BuildContext, String?)? textController7Validator;
  // Stores action output result for [Backend Call - API (BuscarCEP)] action in TextField widget.
  ApiCallResponse? resultCEP;
  // State field(s) for TextFieldPais widget.
  FocusNode? textFieldPaisFocusNode;
  TextEditingController? textFieldPaisTextController;
  String? Function(BuildContext, String?)? textFieldPaisTextControllerValidator;
  // State field(s) for TextFieldEndereco widget.
  FocusNode? textFieldEnderecoFocusNode;
  TextEditingController? textFieldEnderecoTextController;
  String? Function(BuildContext, String?)?
      textFieldEnderecoTextControllerValidator;
  // State field(s) for TextFieldBairro widget.
  FocusNode? textFieldBairroFocusNode;
  TextEditingController? textFieldBairroTextController;
  String? Function(BuildContext, String?)?
      textFieldBairroTextControllerValidator;
  // State field(s) for TextFieldNumero widget.
  FocusNode? textFieldNumeroFocusNode;
  TextEditingController? textFieldNumeroTextController;
  String? Function(BuildContext, String?)?
      textFieldNumeroTextControllerValidator;
  // State field(s) for TextFieldComple widget.
  FocusNode? textFieldCompleFocusNode;
  TextEditingController? textFieldCompleTextController;
  String? Function(BuildContext, String?)?
      textFieldCompleTextControllerValidator;
  // State field(s) for TextFieldCidade widget.
  FocusNode? textFieldCidadeFocusNode;
  TextEditingController? textFieldCidadeTextController;
  String? Function(BuildContext, String?)?
      textFieldCidadeTextControllerValidator;
  // State field(s) for TextFieldUF widget.
  FocusNode? textFieldUFFocusNode;
  TextEditingController? textFieldUFTextController;
  String? Function(BuildContext, String?)? textFieldUFTextControllerValidator;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    sidebarModel.dispose();
    textFieldNomeFocusNode?.dispose();
    textFieldNomeTextController?.dispose();

    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();

    textFieldTelefoneFocusNode?.dispose();
    textFieldTelefoneTextController?.dispose();

    textFieldCPFFocusNode?.dispose();
    textFieldCPFTextController?.dispose();

    textFieldDNascFocusNode?.dispose();
    textFieldDNascTextController?.dispose();

    textFieldNocionFocusNode?.dispose();
    textFieldNocionTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController7?.dispose();

    textFieldPaisFocusNode?.dispose();
    textFieldPaisTextController?.dispose();

    textFieldEnderecoFocusNode?.dispose();
    textFieldEnderecoTextController?.dispose();

    textFieldBairroFocusNode?.dispose();
    textFieldBairroTextController?.dispose();

    textFieldNumeroFocusNode?.dispose();
    textFieldNumeroTextController?.dispose();

    textFieldCompleFocusNode?.dispose();
    textFieldCompleTextController?.dispose();

    textFieldCidadeFocusNode?.dispose();
    textFieldCidadeTextController?.dispose();

    textFieldUFFocusNode?.dispose();
    textFieldUFTextController?.dispose();
  }
}
