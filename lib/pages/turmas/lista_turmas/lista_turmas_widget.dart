import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'lista_turmas_model.dart';
export 'lista_turmas_model.dart';

class ListaTurmasWidget extends StatefulWidget {
  const ListaTurmasWidget({super.key});

  static String routeName = 'ListaTurmas';
  static String routePath = '/listaTurmas';

  @override
  State<ListaTurmasWidget> createState() => _ListaTurmasWidgetState();
}

class _ListaTurmasWidgetState extends State<ListaTurmasWidget> {
  late ListaTurmasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchCtrl = TextEditingController();
  String _query = '';
  int _page = 0;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaTurmasModel());
    _searchCtrl.addListener(() {
      setState(() {
        _query = _searchCtrl.text.trim().toLowerCase();
        _page = 0;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: 20.0,
                  ),
                  child: FutureBuilder<ApiCallResponse>(
                    future: SupabaseGroup.listaTurmasCall.call(
                      pIdFranquia: FFAppState().idfranquia,
                      token: currentJwtToken,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Erro ao carregar dados.',
                            style: theme.bodyMedium,
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 36.0,
                            height: 36.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.6,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(theme.primary),
                            ),
                          ),
                        );
                      }
                      final response = snapshot.data!;
                      final turmasAll = (response.jsonBody
                                  .toList()
                                  .map<ListaTurmasStruct?>(
                                      ListaTurmasStruct.maybeFromMap)
                                  .toList()
                              as Iterable<ListaTurmasStruct?>)
                          .withoutNulls
                          .where((e) => e.professorId == currentUserUid)
                          .toList();

                      final filtered = _query.isEmpty
                          ? turmasAll
                          : turmasAll.where((t) {
                              final q = _query;
                              return t.nomeDaTurma
                                      .toLowerCase()
                                      .contains(q) ||
                                  t.professor.toLowerCase().contains(q) ||
                                  t.moduloNivelTurma
                                      .toLowerCase()
                                      .contains(q);
                            }).toList();

                      final totalPages = (filtered.length / _pageSize).ceil();
                      final safePage = totalPages == 0
                          ? 0
                          : _page.clamp(0, totalPages - 1);
                      final start = safePage * _pageSize;
                      final end =
                          (start + _pageSize).clamp(0, filtered.length);
                      final pageItems = filtered.sublist(start, end);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Header(
                            theme: theme,
                            isCompact: isCompact,
                            total: turmasAll.length,
                          ),
                          const SizedBox(height: 18.0),
                          _Toolbar(
                            theme: theme,
                            isCompact: isCompact,
                            controller: _searchCtrl,
                            visible: filtered.length,
                            total: turmasAll.length,
                          ),
                          const SizedBox(height: 14.0),
                          Expanded(
                            child: _TurmasCard(
                              theme: theme,
                              isCompact: isCompact,
                              items: pageItems,
                              isFiltered: _query.isNotEmpty,
                              page: safePage,
                              totalPages: totalPages,
                              start: start,
                              end: end,
                              total: filtered.length,
                              onPrev: safePage > 0
                                  ? () => setState(() => _page = safePage - 1)
                                  : null,
                              onNext: safePage < totalPages - 1
                                  ? () => setState(() => _page = safePage + 1)
                                  : null,
                              onClearSearch: () {
                                _searchCtrl.clear();
                              },
                            ),
                          ),
                        ],
                      );
                    },
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

class _Header extends StatelessWidget {
  const _Header({
    required this.theme,
    required this.isCompact,
    required this.total,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final int total;

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
            'Turmas',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        chip,
        const SizedBox(height: 10.0),
        Text(
          'Minhas turmas',
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
          total == 0
              ? 'Você ainda não tem turmas cadastradas.'
              : 'Acompanhe as turmas em que você é responsável.',
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 14.0,
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.theme,
    required this.isCompact,
    required this.controller,
    required this.visible,
    required this.total,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final TextEditingController controller;
  final int visible;
  final int total;

  @override
  Widget build(BuildContext context) {
    final search = Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14.0),
          Icon(Icons.search_rounded, color: theme.secondaryText, size: 18.0),
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: controller,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                fontSize: 14.0,
                color: theme.primaryText,
                letterSpacing: 0.0,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Buscar por turma, professor ou nível...',
                hintStyle: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  fontSize: 14.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            _PillIcon(
              theme: theme,
              icon: Icons.close_rounded,
              tooltip: 'Limpar busca',
              onTap: () => controller.clear(),
            ),
          const SizedBox(width: 6.0),
        ],
      ),
    );

    final counter = Container(
      height: 44.0,
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate, width: 1.0),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart_rounded, color: theme.primary, size: 16.0),
          const SizedBox(width: 6.0),
          Text(
            '$visible de $total',
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w700),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          search,
          const SizedBox(height: 10.0),
          Align(alignment: Alignment.centerLeft, child: counter),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: 12.0),
        counter,
      ],
    );
  }
}

class _PillIcon extends StatefulWidget {
  const _PillIcon({
    required this.theme,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  State<_PillIcon> createState() => _PillIconState();
}

class _PillIconState extends State<_PillIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final btn = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _hover ? 1.06 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 32.0,
          height: 32.0,
          decoration: BoxDecoration(
            color: _hover
                ? t.primary.withValues(alpha: 0.10)
                : t.alternate.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16.0,
            icon: Icon(widget.icon,
                color: _hover ? t.primary : t.secondaryText, size: 16.0),
            onPressed: widget.onTap,
          ),
        ),
      ),
    );
    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}

class _TurmasCard extends StatelessWidget {
  const _TurmasCard({
    required this.theme,
    required this.isCompact,
    required this.items,
    required this.isFiltered,
    required this.page,
    required this.totalPages,
    required this.start,
    required this.end,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.onClearSearch,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final List<ListaTurmasStruct> items;
  final bool isFiltered;
  final int page;
  final int totalPages;
  final int start;
  final int end;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onClearSearch;

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
      child: items.isEmpty
          ? _EmptyState(
              theme: theme,
              isFiltered: isFiltered,
              onClearSearch: onClearSearch,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isCompact) _TableHeaderRow(theme: theme),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1.0,
                      thickness: 1.0,
                      color: theme.alternate.withValues(alpha: 0.6),
                    ),
                    itemBuilder: (context, idx) {
                      return _TurmaRow(
                        theme: theme,
                        isCompact: isCompact,
                        item: items[idx],
                      );
                    },
                  ),
                ),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: theme.alternate.withValues(alpha: 0.6),
                ),
                _Pagination(
                  theme: theme,
                  page: page,
                  totalPages: totalPages,
                  start: start,
                  end: end,
                  total: total,
                  onPrev: onPrev,
                  onNext: onNext,
                ),
              ],
            ),
    );
  }
}

class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    final headerStyle = theme.titleSmall.override(
      font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      color: theme.secondaryText,
      letterSpacing: 0.6,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(
            color: theme.alternate.withValues(alpha: 0.6),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text('NOME DA TURMA', style: headerStyle)),
          const SizedBox(width: 12.0),
          Expanded(flex: 3, child: Text('PROFESSOR', style: headerStyle)),
          const SizedBox(width: 12.0),
          Expanded(flex: 2, child: Text('NÍVEL', style: headerStyle)),
          const SizedBox(width: 12.0),
          SizedBox(
            width: 100.0,
            child: Text('ALUNOS', style: headerStyle, textAlign: TextAlign.center),
          ),
          const SizedBox(width: 12.0),
          const SizedBox(width: 44.0),
        ],
      ),
    );
  }
}

class _TurmaRow extends StatefulWidget {
  const _TurmaRow({
    required this.theme,
    required this.isCompact,
    required this.item,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final ListaTurmasStruct item;

  @override
  State<_TurmaRow> createState() => _TurmaRowState();
}

class _TurmaRowState extends State<_TurmaRow> {
  bool _hover = false;

  void _open() {
    context.pushNamed(
      DetalhesTurmaWidget.routeName,
      queryParameters: {
        'idTurma': serializeParam(widget.item.id, ParamType.String),
      }.withoutNulls,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final item = widget.item;

    final nome = Text(
      item.nomeDaTurma.isEmpty ? '—' : item.nomeDaTurma,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: t.bodyLarge.override(
        font: GoogleFonts.inter(fontWeight: FontWeight.w700),
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
        color: t.primaryText,
        letterSpacing: 0.0,
      ),
    );

    final prof = Row(
      children: [
        _Avatar(theme: t, name: item.professor),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            item.professor.isEmpty ? '—' : item.professor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 13.5,
              color: t.primaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ],
    );

    final nivel = _NivelChip(theme: t, label: item.moduloNivelTurma);

    final alunos = _AlunosBadge(theme: t, count: item.totalAlunos);

    final action = _ActionButton(theme: t, onTap: _open);

    final rowContent = widget.isCompact
        ? _CompactRow(
            nome: nome,
            prof: prof,
            nivel: nivel,
            alunos: alunos,
            action: action,
          )
        : _DesktopRow(
            nome: nome,
            prof: prof,
            nivel: nivel,
            alunos: alunos,
            action: action,
          );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: _open,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: _hover
                ? t.primary.withValues(alpha: 0.04)
                : Colors.transparent,
          ),
          child: rowContent,
        ),
      ),
    );
  }
}

class _DesktopRow extends StatelessWidget {
  const _DesktopRow({
    required this.nome,
    required this.prof,
    required this.nivel,
    required this.alunos,
    required this.action,
  });

  final Widget nome;
  final Widget prof;
  final Widget nivel;
  final Widget alunos;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: nome),
        const SizedBox(width: 12.0),
        Expanded(flex: 3, child: prof),
        const SizedBox(width: 12.0),
        Expanded(flex: 2, child: nivel),
        const SizedBox(width: 12.0),
        SizedBox(width: 100.0, child: Center(child: alunos)),
        const SizedBox(width: 12.0),
        action,
      ],
    );
  }
}

class _CompactRow extends StatelessWidget {
  const _CompactRow({
    required this.nome,
    required this.prof,
    required this.nivel,
    required this.alunos,
    required this.action,
  });

  final Widget nome;
  final Widget prof;
  final Widget nivel;
  final Widget alunos;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              nome,
              const SizedBox(height: 8.0),
              prof,
              const SizedBox(height: 10.0),
              Wrap(spacing: 8.0, runSpacing: 8.0, children: [nivel, alunos]),
            ],
          ),
        ),
        const SizedBox(width: 10.0),
        action,
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.theme, required this.name});

  final FlutterFlowTheme theme;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().substring(0, 1).toUpperCase();
    return Container(
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
    );
  }
}

class _NivelChip extends StatelessWidget {
  const _NivelChip({required this.theme, required this.label});

  final FlutterFlowTheme theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    final raw = label.trim();
    final isEmpty = raw.isEmpty;
    final lower = raw.toLowerCase();

    Color bg;
    Color fg;
    IconData icon;
    if (isEmpty) {
      bg = theme.alternate.withValues(alpha: 0.5);
      fg = theme.secondaryText;
      icon = Icons.help_outline_rounded;
    } else if (lower.contains('avançado') || lower.contains('avancado')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFF92400E);
      icon = Icons.workspace_premium_rounded;
    } else if (lower.startsWith('módulo') || lower.startsWith('modulo')) {
      bg = const Color(0xFFE0E7FF);
      fg = const Color(0xFF3730A3);
      icon = Icons.menu_book_rounded;
    } else {
      bg = theme.primary.withValues(alpha: 0.10);
      fg = theme.primary;
      icon = Icons.signal_cellular_alt_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.0, color: fg),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(
              isEmpty ? 'Sem nível' : raw,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
                color: fg,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
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
            color: _hover ? t.primary : t.primary.withValues(alpha: 0.10),
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
                    Icons.edit_rounded,
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
    final label = total == 0
        ? '0 resultados'
        : '${start + 1}–$end de $total';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(),
              fontSize: 12.5,
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PaginationButton(
                theme: theme,
                icon: Icons.chevron_left_rounded,
                tooltip: 'Anterior',
                onTap: onPrev,
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  totalPages == 0
                      ? '0 / 0'
                      : '${page + 1} / $totalPages',
                  style: theme.bodySmall.override(
                    font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: theme.primary,
                    letterSpacing: 0.2,
                  ),
                ),
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
    final enabled = widget.onTap != null;
    return MouseRegion(
      cursor: enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hover = enabled),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: !enabled
              ? t.alternate.withValues(alpha: 0.3)
              : (_hover
                  ? t.primary.withValues(alpha: 0.10)
                  : t.primaryBackground),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: t.alternate,
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: widget.onTap,
            child: Tooltip(
              message: widget.tooltip,
              child: Icon(
                widget.icon,
                size: 18.0,
                color: !enabled
                    ? t.secondaryText.withValues(alpha: 0.5)
                    : (_hover ? t.primary : t.primaryText),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.theme,
    required this.isFiltered,
    required this.onClearSearch,
  });

  final FlutterFlowTheme theme;
  final bool isFiltered;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.0,
            height: 72.0,
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              isFiltered ? Icons.search_off_rounded : Icons.groups_2_rounded,
              color: theme.primary,
              size: 32.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            isFiltered
                ? 'Nenhuma turma encontrada'
                : 'Você ainda não tem turmas',
            style: theme.titleMedium.override(
              font: GoogleFonts.interTight(fontWeight: FontWeight.w700),
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: theme.primaryText,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            isFiltered
                ? 'Tente ajustar a busca para encontrar o que procura.'
                : 'Quando uma turma for atribuída a você, ela aparecerá aqui.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              fontSize: 13.5,
              color: theme.secondaryText,
              letterSpacing: 0.0,
              lineHeight: 1.4,
            ),
          ),
          if (isFiltered) ...[
            const SizedBox(height: 18.0),
            _ClearSearchButton(theme: theme, onTap: onClearSearch),
          ],
        ],
      ),
    );
  }
}

class _ClearSearchButton extends StatefulWidget {
  const _ClearSearchButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_ClearSearchButton> createState() => _ClearSearchButtonState();
}

class _ClearSearchButtonState extends State<_ClearSearchButton> {
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
        scale: _hover ? 1.03 : 1.0,
        child: Material(
          color: _hover ? t.primary : t.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(999.0),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded,
                      size: 16.0, color: _hover ? t.info : t.primary),
                  const SizedBox(width: 8.0),
                  Text(
                    'Limpar busca',
                    style: GoogleFonts.interTight(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.0,
                      color: _hover ? t.info : t.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
