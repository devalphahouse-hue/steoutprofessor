// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> conteudo(AulasRow aulasConteudo) async {
  // Add your function code here!
  final raw = aulasConteudo.data['conteudos_vinculados'];
  if (raw == null || raw is! List || raw.isEmpty) return [];
  return raw.map((e) => e.toString()).toList();
}
