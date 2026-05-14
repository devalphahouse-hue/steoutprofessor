import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'modulos_model.dart';
export 'modulos_model.dart';

class ModulosWidget extends StatefulWidget {
  const ModulosWidget({
    super.key,
    this.aula,
    this.vinculadosCount,
  });

  final String? aula;
  final int? vinculadosCount;

  static String routeName = 'Modulos';
  static String routePath = '/modulos';

  @override
  State<ModulosWidget> createState() => _ModulosWidgetState();
}

class _ModulosWidgetState extends State<ModulosWidget> {
  late ModulosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int? _totalVinculadosAula;

  Future<void> _carregarTotalVinculados() async {
    if (widget.aula == null || widget.aula!.isEmpty) return;
    try {
      final rows = await AulasTable().queryRows(
        queryFn: (q) => q.eqOrNull('id', widget.aula),
      );
      final total = rows.firstOrNull?.conteudosVinculados.length ?? 0;
      if (!mounted) return;
      safeSetState(() => _totalVinculadosAula = total);
    } catch (_) {
      // Sem total atualizado: chip volta ao estado amarelo padrão.
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModulosModel());
    _carregarTotalVinculados();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      safeSetState(() {});
      final count = widget.vinculadosCount ?? 0;
      if (count > 0) {
        final theme = FlutterFlowTheme.of(context);
        final msg = count == 1
            ? '1 conteúdo vinculado à aula com sucesso'
            : '$count conteúdos vinculados à aula com sucesso';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    msg,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: theme.primary,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });
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

  int _cols(double width) {
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    if (width < 1500) return 4;
    return 5;
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
                child: SidebarWidget(route: 'Modulos'),
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
                          isVincularContexto:
                              widget.aula != null && widget.aula!.isNotEmpty,
                          vinculadosCount: _totalVinculadosAula,
                          onVoltarAula: (widget.aula != null &&
                                  widget.aula!.isNotEmpty)
                              ? () => context.pushNamed(
                                    DetalhesAulaWidget.routeName,
                                    queryParameters: {
                                      'idAula': serializeParam(
                                          widget.aula, ParamType.String),
                                    }.withoutNulls,
                                  )
                              : null,
                        ),
                        const SizedBox(height: 24.0),
                        _ModulosGrid(
                          theme: theme,
                          cols: _cols(width),
                          aula: widget.aula,
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
    this.isVincularContexto = false,
    this.vinculadosCount,
    this.onVoltarAula,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final bool isVincularContexto;
  final int? vinculadosCount;
  final VoidCallback? onVoltarAula;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              Icon(Icons.menu_book_rounded,
                  size: 14.0, color: theme.primary),
              const SizedBox(width: 6.0),
              Text(
                'Módulos',
                style: GoogleFonts.interTight(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: theme.primary,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          'Acervo de conteúdos',
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
        Text(
          'Confira o acervo de materiais disponíveis para utilizar nas aulas.',
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            fontSize: 14.0,
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
        if (isVincularContexto) ...[
          const SizedBox(height: 12.0),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12.0,
            runSpacing: 8.0,
            children: [
              Builder(builder: (_) {
                final count = vinculadosCount ?? 0;
                final isSucesso = count > 0;
                final cor = isSucesso ? theme.primary : theme.warning;
                final icone = isSucesso
                    ? Icons.check_circle_rounded
                    : Icons.link_rounded;
                final texto = isSucesso
                    ? (count == 1
                        ? '1 conteúdo vinculado à aula'
                        : '$count conteúdos vinculados à aula')
                    : 'Selecione um conteúdo para vincular à aula';
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: cor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999.0),
                    border:
                        Border.all(color: cor.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icone, size: 14.0, color: cor),
                      const SizedBox(width: 6.0),
                      Text(
                        texto,
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: cor,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (onVoltarAula != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onVoltarAula,
                    borderRadius: BorderRadius.circular(999.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: theme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(999.0),
                        border: Border.all(
                            color: theme.primary.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_rounded,
                              size: 14.0, color: theme.primary),
                          const SizedBox(width: 6.0),
                          Text(
                            'Voltar à aula',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Grid wrapper
// ---------------------------------------------------------------------------

class _ModulosGrid extends StatelessWidget {
  const _ModulosGrid({
    required this.theme,
    required this.cols,
    required this.aula,
  });

  final FlutterFlowTheme theme;
  final int cols;
  final String? aula;

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
      child: FutureBuilder<List<ModulosDeConteudoRow>>(
        future: ModulosDeConteudoTable().queryRows(
          queryFn: (q) => q
              .eqOrNull('status_modulo', true)
              .order('nome_modulo', ascending: true),
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
          final modulos = snapshot.data!;
          if (modulos.isEmpty) {
            return _EmptyState(theme: theme);
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Toolbar(theme: theme, total: modulos.length),
                const SizedBox(height: 16.0),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 2.6,
                  ),
                  itemCount: modulos.length,
                  itemBuilder: (context, index) {
                    final m = modulos[index];
                    return _ModuloCard(
                      theme: theme,
                      modulo: m,
                      aula: aula,
                      index: index,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Toolbar
// ---------------------------------------------------------------------------

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.theme, required this.total});

  final FlutterFlowTheme theme;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              Icon(Icons.layers_rounded,
                  size: 14.0, color: theme.primary),
              const SizedBox(width: 6.0),
              Text(
                '$total ${total == 1 ? 'módulo' : 'módulos'}',
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
        Container(
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
              Icon(Icons.sort_by_alpha_rounded,
                  size: 13.0, color: theme.secondaryText),
              const SizedBox(width: 4.0),
              Text(
                'A → Z',
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
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// ModuloCard
// ---------------------------------------------------------------------------

class _ModuloCard extends StatefulWidget {
  const _ModuloCard({
    required this.theme,
    required this.modulo,
    required this.aula,
    required this.index,
  });

  final FlutterFlowTheme theme;
  final ModulosDeConteudoRow modulo;
  final String? aula;
  final int index;

  @override
  State<_ModuloCard> createState() => _ModuloCardState();
}

class _ModuloCardState extends State<_ModuloCard> {
  bool _hover = false;

  static const _palette = <List<Color>>[
    [Color(0xFF065F46), Color(0xFF10B981)], // verde
    [Color(0xFF1E40AF), Color(0xFF3B82F6)], // azul
    [Color(0xFF7E22CE), Color(0xFFA855F7)], // roxo
    [Color(0xFFB45309), Color(0xFFF59E0B)], // âmbar
    [Color(0xFFBE185D), Color(0xFFEC4899)], // rosa
    [Color(0xFF155E75), Color(0xFF06B6D4)], // ciano
  ];

  void _open() {
    context.pushNamed(
      CategoriasWidget.routeName,
      queryParameters: {
        'modulo': serializeParam(widget.modulo.id, ParamType.String),
        if (widget.aula != null && widget.aula!.isNotEmpty)
          'aula': serializeParam(widget.aula, ParamType.String),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.fade,
          duration: const Duration(milliseconds: 0),
        ),
      },
    );
  }

  String _moduloNumber(String? nome) {
    if (nome == null) return '?';
    final match = RegExp(r'\d+').firstMatch(nome);
    if (match == null) return '?';
    return match.group(0)!;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final m = widget.modulo;
    final colors = _palette[widget.index % _palette.length];
    final num = _moduloNumber(m.nomeModulo);
    final nivel = (m.nivelModulo ?? '').trim();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: t.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: _hover
                  ? t.primary.withValues(alpha: 0.35)
                  : t.alternate,
              width: 1.0,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: colors[1].withValues(alpha: 0.18),
                      blurRadius: 20.0,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: _open,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colors,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                        boxShadow: [
                          BoxShadow(
                            color: colors[1].withValues(alpha: 0.30),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -8.0,
                            top: -8.0,
                            child: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withValues(alpha: 0.14),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              num,
                              style: GoogleFonts.interTight(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.8,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MÓDULO',
                            style: GoogleFonts.interTight(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: t.secondaryText,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            (m.nomeModulo ?? '').trim().isEmpty
                                ? 'Sem nome'
                                : m.nomeModulo!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.interTight(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w800,
                              color: t.primaryText,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              _NivelBadge(theme: t, nivel: nivel),
                              const SizedBox(width: 8.0),
                              AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 160),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 9.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: _hover
                                      ? t.primary
                                      : t.primary
                                          .withValues(alpha: 0.10),
                                  borderRadius:
                                      BorderRadius.circular(999.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Ver',
                                      style: GoogleFonts.interTight(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w800,
                                        color: _hover
                                            ? Colors.white
                                            : t.primary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 3.0),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 13.0,
                                      color: _hover
                                          ? Colors.white
                                          : t.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
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

// ---------------------------------------------------------------------------
// NivelBadge / Empty state
// ---------------------------------------------------------------------------

class _NivelBadge extends StatelessWidget {
  const _NivelBadge({required this.theme, required this.nivel});

  final FlutterFlowTheme theme;
  final String nivel;

  @override
  Widget build(BuildContext context) {
    final isEmpty = nivel.isEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isEmpty
            ? theme.alternate.withValues(alpha: 0.5)
            : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: isEmpty
              ? theme.alternate
              : const Color(0xFF1E40AF).withValues(alpha: 0.18),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.signal_cellular_alt_rounded,
            size: 12.0,
            color: isEmpty
                ? theme.secondaryText
                : const Color(0xFF1E40AF),
          ),
          const SizedBox(width: 4.0),
          Text(
            isEmpty ? 'Sem nível' : 'Nível $nivel',
            style: GoogleFonts.interTight(
              fontSize: 11.0,
              fontWeight: FontWeight.w800,
              color: isEmpty
                  ? theme.secondaryText
                  : const Color(0xFF1E40AF),
              letterSpacing: 0.2,
            ),
          ),
        ],
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
              child: Icon(Icons.menu_book_rounded,
                  color: theme.primary, size: 32.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhum módulo disponível',
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
                'Os módulos aparecerão aqui assim que estiverem ativos.',
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
