import '../database.dart';

class FranquiasTable extends SupabaseTable<FranquiasRow> {
  @override
  String get tableName => 'franquias';

  @override
  FranquiasRow createRow(Map<String, dynamic> data) => FranquiasRow(data);
}

class FranquiasRow extends SupabaseDataRow {
  FranquiasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FranquiasTable();

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get razaoSocial => getField<String>('razao_social');
  set razaoSocial(String? value) => setField<String>('razao_social', value);

  bool? get statusFranquia => getField<bool>('status_franquia');
  set statusFranquia(bool? value) => setField<bool>('status_franquia', value);

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userResponsavel => getField<String>('user_responsavel');
  set userResponsavel(String? value) =>
      setField<String>('user_responsavel', value);
}
