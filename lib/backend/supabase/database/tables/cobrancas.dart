import '../database.dart';

class CobrancasTable extends SupabaseTable<CobrancasRow> {
  @override
  String get tableName => 'cobrancas';

  @override
  CobrancasRow createRow(Map<String, dynamic> data) => CobrancasRow(data);
}

class CobrancasRow extends SupabaseDataRow {
  CobrancasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CobrancasTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get idCobrancaAsaas => getField<String>('id_cobranca_asaas');
  set idCobrancaAsaas(String? value) =>
      setField<String>('id_cobranca_asaas', value);

  double? get valor => getField<double>('valor');
  set valor(double? value) => setField<double>('valor', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);
}
