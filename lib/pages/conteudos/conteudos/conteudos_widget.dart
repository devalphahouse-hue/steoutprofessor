import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'conteudos_model.dart';
export 'conteudos_model.dart';

class ConteudosWidget extends StatefulWidget {
  const ConteudosWidget({
    super.key,
    required this.modulo,
    required this.categoria,
    this.aula,
  });

  final String? modulo;
  final String? categoria;
  final String? aula;

  static String routeName = 'Conteudos';
  static String routePath = '/conteudos';

  @override
  State<ConteudosWidget> createState() => _ConteudosWidgetState();
}

class _ConteudosWidgetState extends State<ConteudosWidget> {
  late ConteudosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<String> _selectedIds = {};
  bool _vinculando = false;

  void _toggleSelect(String? id) {
    if (id == null || id.isEmpty) return;
    safeSetState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _vincularSelecionados() async {
    if (_vinculando ||
        _selectedIds.isEmpty ||
        widget.aula == null ||
        widget.aula!.isEmpty) {
      return;
    }
    setState(() => _vinculando = true);
    try {
      _model.aula = await AulasTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', widget.aula),
      );
      final atuais =
          _model.aula?.firstOrNull?.conteudosVinculados.toList() ??
              <String>[];
      final novos =
          _selectedIds.where((id) => !atuais.contains(id)).toList();
      if (novos.isNotEmpty) {
        await AulasTable().update(
          data: {
            'conteudos_vinculados': [...atuais, ...novos],
          },
          matchingRows: (rows) => rows.eqOrNull('id', widget.aula),
        );
      }
      if (!context.mounted) return;
      context.pushNamed(
        DetalhesAulaWidget.routeName,
        queryParameters: {
          'idAula': serializeParam(widget.aula, ParamType.String),
        }.withoutNulls,
      );
    } finally {
      if (mounted) {
        setState(() {
          _vinculando = false;
          _selectedIds.clear();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConteudosModel());
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
    final isVincularContexto =
        widget.aula != null && widget.aula!.isNotEmpty;

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
                child: SidebarWidget(route: 'Modulos'),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      primary: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          hPad,
                          24.0,
                          hPad,
                          isVincularContexto ? 120.0 : 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Header(
                              theme: theme,
                              isCompact: isCompact,
                              categoriaId: widget.categoria,
                              moduloId: widget.modulo,
                              onBack: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(height: 24.0),
                            _ConteudosList(
                              theme: theme,
                              modulo: widget.modulo,
                              categoria: widget.categoria,
                              isSelectable: isVincularContexto,
                              selectedIds: _selectedIds,
                              onToggle: _toggleSelect,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isVincularContexto && _selectedIds.isNotEmpty)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: _BottomSelectionBar(
                          count: _selectedIds.length,
                          loading: _vinculando,
                          onCancelar: () =>
                              safeSetState(() => _selectedIds.clear()),
                          onConfirmar: _vincularSelecionados,
                        ),
                      ),
                  ],
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
    required this.categoriaId,
    required this.moduloId,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String? categoriaId;
  final String? moduloId;
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
          Icon(Icons.collections_bookmark_rounded,
              size: 14.0, color: theme.primary),
          const SizedBox(width: 6.0),
          Text(
            'Conteúdos',
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
        FutureBuilder<List<CategoriasDeConteudoRow>>(
          future: categoriaId == null
              ? Future<List<CategoriasDeConteudoRow>>.value(const [])
              : CategoriasDeConteudoTable().queryRows(
                  queryFn: (q) => q.eqOrNull('id', categoriaId),
                ),
          builder: (context, snapshot) {
            final nome =
                snapshot.data?.firstOrNull?.nomeCategoria?.trim();
            final txt = (nome != null && nome.isNotEmpty)
                ? nome
                : 'Conteúdos';
            return Text(
              txt,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.headlineMedium.override(
                font: GoogleFonts.interTight(fontWeight: FontWeight.w800),
                fontSize: isCompact ? 22.0 : 26.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: -0.4,
              ),
            );
          },
        ),
        const SizedBox(height: 4.0),
        FutureBuilder<List<ModulosDeConteudoRow>>(
          future: moduloId == null
              ? Future<List<ModulosDeConteudoRow>>.value(const [])
              : ModulosDeConteudoTable().queryRows(
                  queryFn: (q) => q.eqOrNull('id', moduloId),
                ),
          builder: (context, snapshot) {
            final nome = snapshot.data?.firstOrNull?.nomeModulo?.trim();
            final txt = (nome != null && nome.isNotEmpty)
                ? 'Conteúdos da categoria em $nome.'
                : 'Conteúdos disponíveis nesta categoria.';
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
// Conteúdos list
// ---------------------------------------------------------------------------

class _ConteudosList extends StatelessWidget {
  const _ConteudosList({
    required this.theme,
    required this.modulo,
    required this.categoria,
    required this.isSelectable,
    required this.selectedIds,
    required this.onToggle,
  });

  final FlutterFlowTheme theme;
  final String? modulo;
  final String? categoria;
  final bool isSelectable;
  final Set<String> selectedIds;
  final void Function(String?) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: FutureBuilder<List<ConteudosRow>>(
        future: ConteudosTable().queryRows(
          queryFn: (q) => q
              .eqOrNull('modulo_conteudo', modulo)
              .eqOrNull('categoria_conteudo', categoria)
              .order('nome_conteudo', ascending: true),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text('Erro ao carregar dados.',
                    style: theme.bodyMedium),
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.primary),
                  ),
                ),
              ),
            );
          }
          final conteudos = snapshot.data!;
          if (conteudos.isEmpty) {
            return _EmptyState(theme: theme);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.collections_bookmark_rounded,
                              size: 14.0, color: theme.primary),
                          const SizedBox(width: 6.0),
                          Text(
                            '${conteudos.length} ${conteudos.length == 1 ? 'conteúdo' : 'conteúdos'}',
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
                  ],
                ),
              ),
              Divider(height: 1.0, thickness: 1.0, color: theme.alternate),
              ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 8.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: conteudos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4.0),
                itemBuilder: (context, index) {
                  final c = conteudos[index];
                  return _ConteudoRow(
                    theme: theme,
                    conteudo: c,
                    isSelectable: isSelectable,
                    selected: selectedIds.contains(c.id),
                    onToggleSelect: () => onToggle(c.id),
                  );
                },
              ),
              const SizedBox(height: 8.0),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ConteudoRow
// ---------------------------------------------------------------------------

class _ConteudoRow extends StatefulWidget {
  const _ConteudoRow({
    required this.theme,
    required this.conteudo,
    required this.isSelectable,
    required this.selected,
    required this.onToggleSelect,
  });

  final FlutterFlowTheme theme;
  final ConteudosRow conteudo;
  final bool isSelectable;
  final bool selected;
  final VoidCallback onToggleSelect;

  @override
  State<_ConteudoRow> createState() => _ConteudoRowState();
}

class _ConteudoRowState extends State<_ConteudoRow> {
  bool _hover = false;

  void _abrirVisualizar() {
    final link = widget.conteudo.linkConteudo;
    if (link == null || link.isEmpty) return;
    FFAppState().linkconteudo = link;
    safeSetState(() {});
    context.pushNamed(
      VisualizarConteudoWidget.routeName,
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: const Duration(milliseconds: 0),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final c = widget.conteudo;
    final nome = (c.nomeConteudo ?? '').trim();
    final selected = widget.selected;
    final selectable = widget.isSelectable;

    final bgColor = selected
        ? t.primary.withValues(alpha: 0.06)
        : (_hover
            ? t.primary.withValues(alpha: 0.04)
            : Colors.transparent);

    return MouseRegion(
      cursor: selectable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: selectable ? widget.onToggleSelect : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(
              horizontal: 14.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.0),
            border: selected
                ? Border.all(color: t.primary, width: 1.4)
                : Border.all(color: Colors.transparent, width: 1.4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (selectable) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? t.primary : t.secondaryBackground,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: selected ? t.primary : t.alternate,
                      width: 1.6,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10.0),
              ],
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: t.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: t.primary,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  nome.isEmpty ? 'Conteúdo sem nome' : nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: t.primaryText,
                    letterSpacing: 0.1,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              _PillButton(
                theme: t,
                label: 'Visualizar',
                icon: Icons.search_rounded,
                filled: true,
                onTap: _abrirVisualizar,
              ),
              if (selectable) ...[
                const SizedBox(width: 8.0),
                _PillButton(
                  theme: t,
                  label: selected ? 'Adicionado' : 'Adicionar',
                  icon: selected ? Icons.check_rounded : Icons.add_rounded,
                  filled: selected,
                  onTap: widget.onToggleSelect,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatefulWidget {
  const _PillButton({
    required this.theme,
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final disabled = widget.onTap == null;
    final filled = widget.filled;
    final bg = disabled
        ? t.alternate.withValues(alpha: 0.4)
        : (filled
            ? t.primary
            : (_hover
                ? t.primary.withValues(alpha: 0.10)
                : t.primaryBackground));
    final fg = disabled
        ? t.secondaryText
        : (filled ? Colors.white : t.primary);
    final border = filled
        ? null
        : Border.all(
            color: _hover
                ? t.primary.withValues(alpha: 0.35)
                : t.alternate,
            width: 1.0,
          );

    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) {
        if (!disabled) setState(() => _hover = true);
      },
      onExit: (_) {
        if (!disabled) setState(() => _hover = false);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: (_hover && !disabled) ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.0),
            border: border,
            boxShadow: (_hover && !disabled && filled)
                ? [
                    BoxShadow(
                      color: t.primary.withValues(alpha: 0.32),
                      blurRadius: 14.0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(999.0),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14.0, vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, size: 14.0, color: fg),
                    const SizedBox(width: 6.0),
                    Text(
                      widget.label,
                      style: GoogleFonts.interTight(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                        color: fg,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
              child: Icon(Icons.movie_filter_rounded,
                  color: theme.primary, size: 32.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhum conteúdo encontrado',
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
                'Os conteúdos aparecerão aqui assim que forem cadastrados nesta categoria.',
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

class _BottomSelectionBar extends StatelessWidget {
  final int count;
  final bool loading;
  final VoidCallback onCancelar;
  final VoidCallback onConfirmar;
  const _BottomSelectionBar({
    required this.count,
    required this.loading,
    required this.onCancelar,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(
          top: BorderSide(color: theme.alternate, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 22,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: theme.primary),
                    const SizedBox(width: 6),
                    Text(
                      '$count selecionado${count == 1 ? '' : 's'}',
                      style: GoogleFonts.interTight(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: theme.primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _PillButton(
                theme: theme,
                label: 'Limpar',
                icon: Icons.close_rounded,
                filled: false,
                onTap: loading ? null : onCancelar,
              ),
              const SizedBox(width: 8),
              _PillButton(
                theme: theme,
                label: loading ? 'Vinculando…' : 'Vincular na aula',
                icon: loading
                    ? Icons.hourglass_top_rounded
                    : Icons.link_rounded,
                filled: true,
                onTap: loading ? null : onConfirmar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
