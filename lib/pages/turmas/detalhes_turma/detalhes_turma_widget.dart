import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'detalhes_turma_model.dart';
export 'detalhes_turma_model.dart';

class DetalhesTurmaWidget extends StatefulWidget {
  const DetalhesTurmaWidget({
    super.key,
    required this.idTurma,
  });

  final String? idTurma;

  static String routeName = 'DetalhesTurma';
  static String routePath = '/detalhesTurma';

  @override
  State<DetalhesTurmaWidget> createState() => _DetalhesTurmaWidgetState();
}

class _DetalhesTurmaWidgetState extends State<DetalhesTurmaWidget> {
  late DetalhesTurmaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesTurmaModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().AlterarProfessorVisibility = false;
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double _hPad(double width) {
    if (width < kBreakpointSmall) return 16.0;
    if (width < kBreakpointLarge) return 24.0;
    return 48.0;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < kBreakpointSmall;
    final hPad = _hPad(width);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wrapWithModel(
                model: _model.sidebarModel,
                updateCallback: () => safeSetState(() {}),
                child: const SidebarWidget(route: 'Turma'),
              ),
              Expanded(
                child: FutureBuilder<List<TurmasRow>>(
                  future: TurmasTable().querySingleRow(
                    queryFn: (q) => q.eqOrNull('id', widget.idTurma),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}',
                            style: theme.bodyMedium),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: SizedBox(
                          width: 36.0,
                          height: 36.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primary),
                          ),
                        ),
                      );
                    }
                    final rows = snapshot.data!;
                    final turma = rows.isNotEmpty ? rows.first : null;
                    return SingleChildScrollView(
                      primary: false,
                      padding: EdgeInsets.symmetric(
                        horizontal: hPad,
                        vertical: 20.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Header(
                            theme: theme,
                            isCompact: isCompact,
                            turma: turma,
                            onBack: () => context.safePop(),
                          ),
                          const SizedBox(height: 18.0),
                          _InfoCard(
                            theme: theme,
                            isCompact: isCompact,
                            turma: turma,
                          ),
                          const SizedBox(height: 16.0),
                          _AgendaCard(
                            theme: theme,
                            isCompact: isCompact,
                            turma: turma,
                          ),
                          const SizedBox(height: 16.0),
                          _AlunosCard(
                            theme: theme,
                            isCompact: isCompact,
                            idTurma: widget.idTurma,
                          ),
                          const SizedBox(height: 16.0),
                          _AulasSection(
                            theme: theme,
                            isCompact: isCompact,
                            idTurma: widget.idTurma,
                          ),
                          const SizedBox(height: 24.0),
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

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.theme,
    required this.isCompact,
    required this.turma,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final TurmasRow? turma;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups_2_rounded, color: theme.primary, size: 14.0),
          const SizedBox(width: 6.0),
          Text(
            'Turma',
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w700),
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
        const SizedBox(height: 10.0),
        Text(
          (turma?.nomeDaTurma ?? '').trim().isEmpty
              ? 'Detalhes da turma'
              : turma!.nomeDaTurma!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.headlineMedium.override(
            font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
            fontSize: isCompact ? 22.0 : 28.0,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Veja informações, agenda, alunos vinculados e aulas desta turma.',
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 14.0,
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
      ],
    );

    final backBtn = _BackButton(theme: theme, onTap: onBack);

    if (isCompact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: backBtn,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chip,
                const SizedBox(height: 10.0),
                Text(
                  (turma?.nomeDaTurma ?? '').trim().isEmpty
                      ? 'Detalhes da turma'
                      : turma!.nomeDaTurma!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.headlineMedium.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Informações, agenda, alunos e aulas.',
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    fontSize: 14.0,
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
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

class _BackButton extends StatefulWidget {
  const _BackButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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

// ---------------------------------------------------------------------------
// Section card scaffolding
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.theme,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.child,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 22.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 14.0),
            child: Row(
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: theme.primary, size: 18.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.titleMedium.override(
                          font: GoogleFonts.interTight(
                              fontWeight: FontWeight.w800),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2.0),
                        Text(
                          subtitle!,
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            fontSize: 12.5,
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
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
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: theme.alternate.withValues(alpha: 0.6),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 20.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.theme, required this.count});

  final FlutterFlowTheme theme;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        count.toString(),
        style: GoogleFonts.interTight(
          fontWeight: FontWeight.w800,
          fontSize: 12.5,
          color: theme.primary,
          letterSpacing: 0.0,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Informações da turma
// ---------------------------------------------------------------------------

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.theme,
    required this.isCompact,
    required this.turma,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final TurmasRow? turma;

  @override
  Widget build(BuildContext context) {
    final dataInicio = turma?.dataInicio;
    final dataLabel = dataInicio == null
        ? '—'
        : dateTimeFormat(
            "d/M/y",
            dataInicio,
            locale: FFLocalizations.of(context).languageCode,
          );

    return _SectionCard(
      theme: theme,
      icon: Icons.info_outline_rounded,
      title: 'Informações da turma',
      subtitle: 'Dados gerais cadastrados.',
      child: _InfoGrid(
        theme: theme,
        isCompact: isCompact,
        items: [
          _InfoTileSpec(
            icon: Icons.bookmark_rounded,
            label: 'Nome da turma',
            value: (turma?.nomeDaTurma ?? '').trim().isEmpty
                ? '—'
                : turma!.nomeDaTurma!,
          ),
          _InfoTileSpec(
            icon: Icons.calendar_today_rounded,
            label: 'Data de início',
            value: dataLabel,
          ),
          _InfoTileSpec(
            icon: Icons.menu_book_rounded,
            label: 'Módulo / Nível',
            value: (turma?.moduloNivelTurma ?? '').trim().isEmpty
                ? '—'
                : turma!.moduloNivelTurma!,
          ),
          _InfoTileSpec(
            icon: Icons.person_rounded,
            label: 'Professor',
            valueBuilder: (context) => _ProfessorTile(
              theme: theme,
              professorId: turma?.professorResponsavel,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTileSpec {
  const _InfoTileSpec({
    required this.icon,
    required this.label,
    this.value,
    this.valueBuilder,
  }) : assert(value != null || valueBuilder != null);

  final IconData icon;
  final String label;
  final String? value;
  final Widget Function(BuildContext)? valueBuilder;
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({
    required this.theme,
    required this.isCompact,
    required this.items,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final List<_InfoTileSpec> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = isCompact ? 1 : (width >= 900 ? 2 : 1);
    const gap = 14.0;
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += cols) {
      final group = <Widget>[];
      for (var j = 0; j < cols; j++) {
        if (j > 0) group.add(const SizedBox(width: gap));
        if (i + j < items.length) {
          group.add(
              Expanded(child: _InfoTile(theme: theme, spec: items[i + j])));
        } else {
          group.add(const Expanded(child: SizedBox.shrink()));
        }
      }
      if (rows.isNotEmpty) rows.add(const SizedBox(height: gap));
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: group,
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.theme, required this.spec});

  final FlutterFlowTheme theme;
  final _InfoTileSpec spec;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Row(
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
            child: Icon(spec.icon, size: 18.0, color: theme.primary),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  spec.label.toUpperCase(),
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    color: theme.secondaryText,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4.0),
                if (spec.valueBuilder != null)
                  spec.valueBuilder!(context)
                else
                  Text(
                    spec.value!,
                    style: theme.bodyLarge.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                      letterSpacing: 0.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfessorTile extends StatelessWidget {
  const _ProfessorTile({required this.theme, required this.professorId});

  final FlutterFlowTheme theme;
  final String? professorId;

  @override
  Widget build(BuildContext context) {
    if (professorId == null || professorId!.isEmpty) {
      return Text(
        '—',
        style: theme.bodyLarge.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w700),
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          color: theme.primaryText,
          letterSpacing: 0.0,
        ),
      );
    }
    return FutureBuilder<List<UsersRow>>(
      future: UsersTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('id', professorId),
      ),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container(
            width: 80.0,
            height: 14.0,
            decoration: BoxDecoration(
              color: theme.alternate.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        }
        final user = snap.data!.firstOrNull;
        final name = (user?.nome ?? '').trim();
        final initial = name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();
        return Row(
          children: [
            Container(
              width: 22.0,
              height: 22.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: GoogleFonts.interTight(
                  fontWeight: FontWeight.w700,
                  fontSize: 11.0,
                  color: theme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(
                name.isEmpty ? '—' : name,
                style: theme.bodyLarge.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: 0.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Agenda de aulas
// ---------------------------------------------------------------------------

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.theme,
    required this.isCompact,
    required this.turma,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final TurmasRow? turma;

  @override
  Widget build(BuildContext context) {
    final raw = turma?.agendaAulas.toList() ?? [];
    final items = raw
        .map<AgendaAulasStruct?>(AgendaAulasStruct.maybeFromMap)
        .whereType<AgendaAulasStruct>()
        .toList();

    return _SectionCard(
      theme: theme,
      icon: Icons.calendar_today_rounded,
      title: 'Agenda de aulas',
      subtitle: items.isEmpty
          ? 'Nenhum horário cadastrado.'
          : 'Dias e horários fixos da semana.',
      trailing: items.isEmpty ? null : _CountBadge(theme: theme, count: items.length),
      child: items.isEmpty
          ? _EmptyInline(
              theme: theme,
              icon: Icons.event_busy_rounded,
              text: 'Nenhum horário cadastrado.',
            )
          : Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: items.map((it) {
                final dia = it.dia.trim().isEmpty ? '—' : it.dia;
                final ini = it.horarioInicio.trim();
                final fim = it.horarioFinal.trim();
                final hora = ini.isEmpty && fim.isEmpty
                    ? ''
                    : (ini.isEmpty
                        ? fim
                        : (fim.isEmpty ? ini : '$ini–$fim'));
                return _AgendaChip(theme: theme, dia: dia, hora: hora);
              }).toList(),
            ),
    );
  }
}

class _AgendaChip extends StatelessWidget {
  const _AgendaChip({
    required this.theme,
    required this.dia,
    required this.hora,
  });

  final FlutterFlowTheme theme;
  final String dia;
  final String hora;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
            color: theme.primary.withValues(alpha: 0.18), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 16.0, color: theme.primary),
          const SizedBox(width: 8.0),
          Text(
            dia,
            style: theme.bodyMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          if (hora.isNotEmpty) ...[
            const SizedBox(width: 8.0),
            Container(
              width: 1.0,
              height: 14.0,
              color: theme.alternate,
            ),
            const SizedBox(width: 8.0),
            Text(
              hora,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: theme.primary,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Alunos vinculados
// ---------------------------------------------------------------------------

class _AlunosCard extends StatelessWidget {
  const _AlunosCard({
    required this.theme,
    required this.isCompact,
    required this.idTurma,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String? idTurma;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApiCallResponse>(
      future: SupabaseGroup.listaAlunosPorTurmaCall.call(
        pTurmaId: idTurma,
        token: currentJwtToken,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _SectionCard(
            theme: theme,
            icon: Icons.people_alt_rounded,
            title: 'Alunos vinculados',
            child: _EmptyInline(
              theme: theme,
              icon: Icons.error_outline_rounded,
              text: 'Erro ao carregar alunos.',
            ),
          );
        }
        if (!snapshot.hasData) {
          return _SectionCard(
            theme: theme,
            icon: Icons.people_alt_rounded,
            title: 'Alunos vinculados',
            child: _LoadingInline(theme: theme),
          );
        }
        final alunos = (snapshot.data!.jsonBody
                    .toList()
                    .map<AlunosPorTurmaStruct?>(
                        AlunosPorTurmaStruct.maybeFromMap)
                    .toList()
                as Iterable<AlunosPorTurmaStruct?>)
            .withoutNulls
            .toList();

        return _SectionCard(
          theme: theme,
          icon: Icons.people_alt_rounded,
          title: 'Alunos vinculados',
          subtitle: alunos.isEmpty
              ? 'Nenhum aluno vinculado.'
              : 'Lista de alunos desta turma.',
          trailing: alunos.isEmpty
              ? null
              : _CountBadge(theme: theme, count: alunos.length),
          child: alunos.isEmpty
              ? _EmptyInline(
                  theme: theme,
                  icon: Icons.person_off_rounded,
                  text: 'Nenhum aluno vinculado a esta turma.',
                )
              : Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: alunos
                      .map((a) => _AlunoChip(theme: theme, name: a.nome))
                      .toList(),
                ),
        );
      },
    );
  }
}

class _AlunoChip extends StatelessWidget {
  const _AlunoChip({required this.theme, required this.name});

  final FlutterFlowTheme theme;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();
    return Container(
      padding: const EdgeInsets.fromLTRB(6.0, 6.0, 14.0, 6.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: GoogleFonts.interTight(
                fontWeight: FontWeight.w700,
                fontSize: 12.0,
                color: theme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Text(
            name.trim().isEmpty ? '—' : name,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Aulas (próximas + histórico)
// ---------------------------------------------------------------------------

class _AulasSection extends StatelessWidget {
  const _AulasSection({
    required this.theme,
    required this.isCompact,
    required this.idTurma,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String? idTurma;

  @override
  Widget build(BuildContext context) {
    final proximas = _SectionCard(
      theme: theme,
      icon: Icons.event_available_rounded,
      title: 'Próximas aulas',
      subtitle: 'Aulas agendadas a partir de hoje.',
      child: FutureBuilder<List<AulasRow>>(
        future: AulasTable().queryRows(
          queryFn: (q) => q
              .eqOrNull('turma', idTurma)
              .gteOrNull(
                'datetimeinicio_aula',
                supaSerialize<DateTime>(getCurrentTimestamp),
              )
              .order('datetimeinicio_aula'),
        ),
        builder: (context, snap) {
          if (!snap.hasData) return _LoadingInline(theme: theme);
          final list = snap.data!;
          if (list.isEmpty) {
            return _EmptyInline(
              theme: theme,
              icon: Icons.event_busy_rounded,
              text: 'Sem próximas aulas.',
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < list.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1.0,
                    color: theme.alternate.withValues(alpha: 0.6),
                  ),
                _AulaRow(theme: theme, aula: list[i]),
              ],
            ],
          );
        },
      ),
    );

    final historico = _HistoricoCard(theme: theme, idTurma: idTurma);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        proximas,
        const SizedBox(height: 16.0),
        historico,
      ],
    );
  }
}

class _AulaRow extends StatefulWidget {
  const _AulaRow({required this.theme, required this.aula});

  final FlutterFlowTheme theme;
  final AulasRow aula;

  @override
  State<_AulaRow> createState() => _AulaRowState();
}

class _AulaRowState extends State<_AulaRow> {
  bool _hover = false;

  void _open() {
    context.pushNamed(
      DetalhesAulaWidget.routeName,
      queryParameters: {
        'idAula': serializeParam(widget.aula.id, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final aula = widget.aula;
    final dt = aula.datetimeinicioAula;
    final dataLabel = dt == null
        ? '—'
        : dateTimeFormat(
            "d/M/y",
            dt,
            locale: FFLocalizations.of(context).languageCode,
          );
    final horaLabel = dt == null
        ? ''
        : dateTimeFormat(
            "HH:mm",
            dt,
            locale: FFLocalizations.of(context).languageCode,
          );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding:
              const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
          color: _hover ? t.primary.withValues(alpha: 0.04) : Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DateBadge(theme: t, dataLabel: dataLabel, horaLabel: horaLabel),
              const SizedBox(width: 14.0),
              Expanded(
                child: _StatusChip(theme: t, status: aula.statusAula),
              ),
              const SizedBox(width: 12.0),
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: _hover
                      ? t.primary
                      : t.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: _hover ? t.info : t.primary,
                  size: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({
    required this.theme,
    required this.dataLabel,
    required this.horaLabel,
  });

  final FlutterFlowTheme theme;
  final String dataLabel;
  final String horaLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dataLabel,
            textAlign: TextAlign.center,
            style: theme.bodySmall.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
              fontSize: 12.0,
              fontWeight: FontWeight.w800,
              color: theme.primary,
              letterSpacing: 0.0,
            ),
          ),
          if (horaLabel.isNotEmpty) ...[
            const SizedBox(height: 2.0),
            Text(
              horaLabel,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                color: theme.primary,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.theme, required this.status});

  final FlutterFlowTheme theme;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final raw = (status ?? '').trim();
    Color bg;
    Color fg;
    IconData icon;
    String label;
    if (raw.toLowerCase().contains('aguardando')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
      icon = Icons.schedule_rounded;
      label = raw.isEmpty ? 'Aguardando Planning' : raw;
    } else if (raw.toLowerCase().contains('conclu')) {
      bg = const Color(0xFFD1FAE5);
      fg = const Color(0xFF065F46);
      icon = Icons.check_circle_rounded;
      label = raw;
    } else if (raw.isEmpty) {
      bg = theme.alternate.withValues(alpha: 0.5);
      fg = theme.secondaryText;
      icon = Icons.help_outline_rounded;
      label = 'Sem status';
    } else {
      bg = theme.primary.withValues(alpha: 0.10);
      fg = theme.primary;
      icon = Icons.info_outline_rounded;
      label = raw;
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13.0, color: fg),
            const SizedBox(width: 6.0),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                  color: fg,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoricoCard extends StatefulWidget {
  const _HistoricoCard({required this.theme, required this.idTurma});

  final FlutterFlowTheme theme;
  final String? idTurma;

  @override
  State<_HistoricoCard> createState() => _HistoricoCardState();
}

class _HistoricoCardState extends State<_HistoricoCard> {
  bool _hover = false;

  void _open() {
    context.pushNamed(
      HistoricoAulasWidget.routeName,
      queryParameters: {
        'turma': serializeParam(widget.idTurma, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return _SectionCard(
      theme: t,
      icon: Icons.history_rounded,
      title: 'Histórico de aulas',
      subtitle: 'Aulas já realizadas pela turma.',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedScale(
          scale: _hover ? 1.01 : 1.0,
          duration: const Duration(milliseconds: 140),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _hover
                  ? t.primary.withValues(alpha: 0.06)
                  : t.secondaryBackground,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: _hover
                    ? t.primary.withValues(alpha: 0.40)
                    : t.alternate,
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: t.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.menu_book_rounded,
                          color: t.primary, size: 20.0),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        'Acesse o histórico completo de aulas desta turma.',
                        style: t.bodyMedium.override(
                          font: GoogleFonts.inter(),
                          fontSize: 13.5,
                          color: t.secondaryText,
                          letterSpacing: 0.0,
                          lineHeight: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14.0),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  decoration: BoxDecoration(
                    color: t.primary,
                    borderRadius: BorderRadius.circular(999.0),
                    boxShadow: _hover
                        ? [
                            BoxShadow(
                              color: t.primary.withValues(alpha: 0.32),
                              blurRadius: 14.0,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : const [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(999.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999.0),
                      onTap: _open,
                      hoverColor: Colors.white.withValues(alpha: 0.08),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Acessar histórico',
                              style: GoogleFonts.interTight(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: t.info,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Icon(Icons.arrow_forward_rounded,
                                size: 16.0, color: t.info),
                          ],
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
    );
  }
}

// ---------------------------------------------------------------------------
// Inline helpers
// ---------------------------------------------------------------------------

class _LoadingInline extends StatelessWidget {
  const _LoadingInline({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: SizedBox(
          width: 26.0,
          height: 26.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
          ),
        ),
      ),
    );
  }
}

class _EmptyInline extends StatelessWidget {
  const _EmptyInline({
    required this.theme,
    required this.icon,
    required this.text,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.secondaryText, size: 18.0),
          const SizedBox(width: 10.0),
          Flexible(
            child: Text(
              text,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 13.5,
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
