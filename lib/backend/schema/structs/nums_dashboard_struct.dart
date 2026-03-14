// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NumsDashboardStruct extends BaseStruct {
  NumsDashboardStruct({
    int? totalAlunos,
    int? turmasCount,
  })  : _totalAlunos = totalAlunos,
        _turmasCount = turmasCount;

  // "total_alunos" field.
  int? _totalAlunos;
  int get totalAlunos => _totalAlunos ?? 0;
  set totalAlunos(int? val) => _totalAlunos = val;

  void incrementTotalAlunos(int amount) => totalAlunos = totalAlunos + amount;

  bool hasTotalAlunos() => _totalAlunos != null;

  // "turmas_count" field.
  int? _turmasCount;
  int get turmasCount => _turmasCount ?? 0;
  set turmasCount(int? val) => _turmasCount = val;

  void incrementTurmasCount(int amount) => turmasCount = turmasCount + amount;

  bool hasTurmasCount() => _turmasCount != null;

  static NumsDashboardStruct fromMap(Map<String, dynamic> data) =>
      NumsDashboardStruct(
        totalAlunos: castToType<int>(data['total_alunos']),
        turmasCount: castToType<int>(data['turmas_count']),
      );

  static NumsDashboardStruct? maybeFromMap(dynamic data) => data is Map
      ? NumsDashboardStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'total_alunos': _totalAlunos,
        'turmas_count': _turmasCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'total_alunos': serializeParam(
          _totalAlunos,
          ParamType.int,
        ),
        'turmas_count': serializeParam(
          _turmasCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static NumsDashboardStruct fromSerializableMap(Map<String, dynamic> data) =>
      NumsDashboardStruct(
        totalAlunos: deserializeParam(
          data['total_alunos'],
          ParamType.int,
          false,
        ),
        turmasCount: deserializeParam(
          data['turmas_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'NumsDashboardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NumsDashboardStruct &&
        totalAlunos == other.totalAlunos &&
        turmasCount == other.turmasCount;
  }

  @override
  int get hashCode => const ListEquality().hash([totalAlunos, turmasCount]);
}

NumsDashboardStruct createNumsDashboardStruct({
  int? totalAlunos,
  int? turmasCount,
}) =>
    NumsDashboardStruct(
      totalAlunos: totalAlunos,
      turmasCount: turmasCount,
    );
