import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'historico_aulas_model.dart';
export 'historico_aulas_model.dart';

class HistoricoAulasWidget extends StatefulWidget {
  const HistoricoAulasWidget({
    super.key,
    required this.turma,
  });

  final String? turma;

  static String routeName = 'HistoricoAulas';
  static String routePath = '/historicoAulas';

  @override
  State<HistoricoAulasWidget> createState() => _HistoricoAulasWidgetState();
}

class _HistoricoAulasWidgetState extends State<HistoricoAulasWidget> {
  late HistoricoAulasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const int _pageSize = 10;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HistoricoAulasModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double _hPad(double width) {
    if (width < 480) return 16.0;
    if (width < 992) return 24.0;
    return 48.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 768;
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
                child: SidebarWidget(route: 'Turma'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 24.0, hPad, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(
                          theme: theme,
                          isCompact: isCompact,
                          turmaId: widget.turma,
                          onBack: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(height: 24.0),
                        _AulasCard(
                          theme: theme,
                          isCompact: isCompact,
                          turmaId: widget.turma,
                          page: _page,
                          pageSize: _pageSize,
                          onPageChanged: (p) =>
                              setState(() => _page = p),
                        ),
                      ],
                    ),
                  ),
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
    required this.turmaId,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String? turmaId;
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
          Icon(Icons.history_rounded, size: 14.0, color: theme.primary),
          const SizedBox(width: 6.0),
          Text(
            'Histórico',
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
          'Histórico de aulas',
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
        FutureBuilder<List<TurmasRow>>(
          future: turmaId == null
              ? Future<List<TurmasRow>>.value(const [])
              : TurmasTable().queryRows(
                  queryFn: (q) => q.eqOrNull('id', turmaId),
                ),
          builder: (context, snapshot) {
            final nome = snapshot.data?.firstOrNull?.nomeDaTurma?.trim();
            final txt = (nome != null && nome.isNotEmpty)
                ? 'Aulas já realizadas pela turma $nome.'
                : 'Aulas já realizadas por esta turma.';
            return Text(
              txt,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 14.0,
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            );
          },
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
// Aulas card
// ---------------------------------------------------------------------------

class _AulasCard extends StatelessWidget {
  const _AulasCard({
    required this.theme,
    required this.isCompact,
    required this.turmaId,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String? turmaId;
  final int page;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FutureBuilder<List<AulasRow>>(
        future: turmaId == null
            ? Future<List<AulasRow>>.value(const [])
            : AulasTable().queryRows(
                queryFn: (q) => q
                    .eqOrNull('turma', turmaId)
                    .order('datetimeinicio_aula', ascending: false),
              ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  'Erro ao carregar dados.',
                  style: theme.bodyMedium,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: SizedBox(
                  width: 36.0,
                  height: 36.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                  ),
                ),
              ),
            );
          }

          final aulas = snapshot.data!;
          final total = aulas.length;

          if (total == 0) {
            return _EmptyState(theme: theme);
          }

          final totalPages = ((total - 1) ~/ pageSize) + 1;
          final safePage = page.clamp(0, totalPages - 1);
          final start = safePage * pageSize;
          final end = (start + pageSize).clamp(0, total);
          final pageItems = aulas.sublist(start, end);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Toolbar(theme: theme, total: total),
              Divider(height: 1.0, thickness: 1.0, color: theme.alternate),
              if (!isCompact) _TableHeader(theme: theme),
              if (!isCompact)
                Divider(height: 1.0, thickness: 1.0, color: theme.alternate),
              ...List.generate(pageItems.length, (index) {
                final aula = pageItems[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AulaRow(
                      theme: theme,
                      isCompact: isCompact,
                      aula: aula,
                    ),
                    if (index < pageItems.length - 1)
                      Divider(
                        height: 1.0,
                        thickness: 1.0,
                        color: theme.alternate.withValues(alpha: 0.6),
                      ),
                  ],
                );
              }),
              Divider(height: 1.0, thickness: 1.0, color: theme.alternate),
              _Pagination(
                theme: theme,
                page: safePage,
                totalPages: totalPages,
                start: start,
                end: end,
                total: total,
                onPrev: safePage == 0
                    ? null
                    : () => onPageChanged(safePage - 1),
                onNext: safePage >= totalPages - 1
                    ? null
                    : () => onPageChanged(safePage + 1),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Toolbar (counter)
// ---------------------------------------------------------------------------

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.theme, required this.total});

  final FlutterFlowTheme theme;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_note_rounded,
                    size: 14.0, color: theme.primary),
                const SizedBox(width: 6.0),
                Text(
                  '$total ${total == 1 ? 'aula' : 'aulas'}',
                  style: GoogleFonts.interTight(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Tooltip(
            message: 'Mais recentes primeiro',
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(999.0),
                border: Border.all(color: theme.alternate, width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_downward_rounded,
                      size: 13.0, color: theme.secondaryText),
                  const SizedBox(width: 4.0),
                  Text(
                    'Recentes',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: theme.secondaryText,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Table header
// ---------------------------------------------------------------------------

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    TextStyle h(FlutterFlowTheme t) => GoogleFonts.interTight(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: t.secondaryText,
          letterSpacing: 0.6,
        );
    return Container(
      color: theme.primaryBackground,
      padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 64.0,
            child: Text('DATA', style: h(theme)),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            flex: 5,
            child: Text('PROFESSOR', style: h(theme)),
          ),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 86.0,
            child: Text('ALUNOS', style: h(theme)),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            flex: 3,
            child: Text('STATUS', style: h(theme)),
          ),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 44.0,
            child: Text(
              'AÇÃO',
              textAlign: TextAlign.center,
              style: h(theme),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Aula row
// ---------------------------------------------------------------------------

class _AulaRow extends StatefulWidget {
  const _AulaRow({
    required this.theme,
    required this.isCompact,
    required this.aula,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
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
    final dt = widget.aula.datetimeinicioAula;
    final locale = FFLocalizations.of(context).languageCode;
    final dataLabel =
        dt == null ? '—' : dateTimeFormat("d/M", dt, locale: locale);
    final horaLabel =
        dt == null ? '' : dateTimeFormat("HH:mm", dt, locale: locale);
    final qtdAlunos = widget.aula.alunosConvidados.length;
    final status = widget.aula.statusAula;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 14.0),
          color: _hover
              ? t.primary.withValues(alpha: 0.04)
              : Colors.transparent,
          child: widget.isCompact
              ? _buildCompact(t, dataLabel, horaLabel, qtdAlunos, status)
              : _buildWide(t, dataLabel, horaLabel, qtdAlunos, status),
        ),
      ),
    );
  }

  Widget _buildWide(FlutterFlowTheme t, String dataLabel, String horaLabel,
      int qtdAlunos, String? status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DateBadge(theme: t, dataLabel: dataLabel, horaLabel: horaLabel),
        const SizedBox(width: 14.0),
        Expanded(
          flex: 5,
          child: _ProfTile(
            theme: t,
            userId: widget.aula.professorResponsavel,
          ),
        ),
        const SizedBox(width: 12.0),
        SizedBox(
          width: 86.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _AlunosBadge(theme: t, count: qtdAlunos),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _StatusChip(theme: t, status: status),
        ),
        const SizedBox(width: 12.0),
        _ActionButton(theme: t, onTap: _open),
      ],
    );
  }

  Widget _buildCompact(FlutterFlowTheme t, String dataLabel, String horaLabel,
      int qtdAlunos, String? status) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateBadge(theme: t, dataLabel: dataLabel, horaLabel: horaLabel),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ProfTile(theme: t, userId: widget.aula.professorResponsavel),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: [
                  _AlunosBadge(theme: t, count: qtdAlunos),
                  _StatusChip(theme: t, status: status),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
        _ActionButton(theme: t, onTap: _open),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DateBadge / ProfTile / AlunosBadge / StatusChip / ActionButton
// ---------------------------------------------------------------------------

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
            style: GoogleFonts.interTight(
              fontSize: 13.0,
              fontWeight: FontWeight.w800,
              color: theme.primary,
              letterSpacing: 0.0,
            ),
          ),
          if (horaLabel.isNotEmpty) ...[
            const SizedBox(height: 2.0),
            Text(
              horaLabel,
              style: GoogleFonts.inter(
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

class _ProfTile extends StatelessWidget {
  const _ProfTile({required this.theme, required this.userId});

  final FlutterFlowTheme theme;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsersRow>>(
      future: userId == null || userId!.isEmpty
          ? Future<List<UsersRow>>.value(const [])
          : UsersTable().queryRows(
              queryFn: (q) => q.eqOrNull('id', userId),
            ),
      builder: (context, snapshot) {
        final user = snapshot.data?.firstOrNull;
        final nome = user?.nome?.trim();
        final foto = user?.imagemPerfil?.trim();
        final hasNome = nome != null && nome.isNotEmpty;
        final initial =
            hasNome ? nome.characters.first.toUpperCase() : '?';

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primary.withValues(alpha: 0.10),
                image: (foto != null && foto.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(foto), fit: BoxFit.cover)
                    : null,
              ),
              alignment: Alignment.center,
              child: (foto == null || foto.isEmpty)
                  ? Text(
                      initial,
                      style: GoogleFonts.interTight(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                        color: theme.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                hasNome ? nome : 'Professor',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AlunosBadge extends StatelessWidget {
  const _AlunosBadge({required this.theme, required this.count});

  final FlutterFlowTheme theme;
  final int count;

  @override
  Widget build(BuildContext context) {
    final isZero = count == 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: isZero
            ? theme.alternate.withValues(alpha: 0.5)
            : theme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt_rounded,
            size: 13.0,
            color: isZero ? theme.secondaryText : theme.primary,
          ),
          const SizedBox(width: 6.0),
          Text(
            count.toString(),
            style: GoogleFonts.interTight(
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
              color: isZero ? theme.secondaryText : theme.primary,
              letterSpacing: 0.0,
            ),
          ),
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
    final lower = raw.toLowerCase();
    Color bg;
    Color fg;
    IconData icon;
    String label;
    if (lower.contains('cancel')) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFF991B1B);
      icon = Icons.cancel_rounded;
      label = raw;
    } else if (lower.contains('aguardando')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
      icon = Icons.schedule_rounded;
      label = raw;
    } else if (lower.contains('andamento') || lower.contains('iniciada')) {
      bg = const Color(0xFFDBEAFE);
      fg = const Color(0xFF1E40AF);
      icon = Icons.play_circle_fill_rounded;
      label = raw;
    } else if (lower.contains('conclu') || lower.contains('finaliz')) {
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

class _ActionButton extends StatefulWidget {
  const _ActionButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _hover ? 1.06 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 44.0,
          height: 44.0,
          decoration: BoxDecoration(
            color:
                _hover ? t.primary : t.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: t.primary.withValues(alpha: 0.30),
                      blurRadius: 14.0,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.onTap,
              child: Tooltip(
                message: 'Abrir detalhes',
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18.0,
                    color: _hover ? t.info : t.primary,
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
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 56.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.0,
              height: 72.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.history_toggle_off_rounded,
                  color: theme.primary, size: 32.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhuma aula registrada',
              style: GoogleFonts.interTight(
                fontSize: 17.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6.0),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360.0),
              child: Text(
                'Esta turma ainda não tem aulas no histórico.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: theme.secondaryText,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pagination
// ---------------------------------------------------------------------------

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.theme,
    required this.page,
    required this.totalPages,
    required this.start,
    required this.end,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  final FlutterFlowTheme theme;
  final int page;
  final int totalPages;
  final int start;
  final int end;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final label =
        total == 0 ? '0 resultados' : '${start + 1}–$end de $total';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
              color: theme.secondaryText,
              letterSpacing: 0.1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Página ${page + 1} de $totalPages',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: theme.secondaryText,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(width: 12.0),
              _PaginationButton(
                theme: theme,
                icon: Icons.chevron_left_rounded,
                tooltip: 'Anterior',
                onTap: onPrev,
              ),
              const SizedBox(width: 8.0),
              _PaginationButton(
                theme: theme,
                icon: Icons.chevron_right_rounded,
                tooltip: 'Próxima',
                onTap: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaginationButton extends StatefulWidget {
  const _PaginationButton({
    required this.theme,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  State<_PaginationButton> createState() => _PaginationButtonState();
}

class _PaginationButtonState extends State<_PaginationButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final disabled = widget.onTap == null;
    return MouseRegion(
      cursor:
          disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) {
        if (!disabled) setState(() => _hover = true);
      },
      onExit: (_) {
        if (!disabled) setState(() => _hover = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: disabled
              ? t.alternate.withValues(alpha: 0.4)
              : (_hover
                  ? t.primary.withValues(alpha: 0.12)
                  : t.primaryBackground),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: t.alternate, width: 1.0),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: widget.onTap,
            child: Tooltip(
              message: widget.tooltip,
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 20.0,
                  color: disabled
                      ? t.secondaryText.withValues(alpha: 0.5)
                      : (_hover ? t.primary : t.primaryText),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
