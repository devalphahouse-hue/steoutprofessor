import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'categorias_model.dart';
export 'categorias_model.dart';

class CategoriasWidget extends StatefulWidget {
  const CategoriasWidget({
    super.key,
    required this.modulo,
    this.aula,
  });

  final String? modulo;
  final String? aula;

  static String routeName = 'Categorias';
  static String routePath = '/categorias';

  @override
  State<CategoriasWidget> createState() => _CategoriasWidgetState();
}

class _CategoriasWidgetState extends State<CategoriasWidget> {
  late CategoriasModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CategoriasModel());
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

  int _cols(double width) {
    if (width < 540) return 2;
    if (width < 800) return 3;
    if (width < 1100) return 4;
    if (width < 1400) return 5;
    return 6;
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
                          moduloId: widget.modulo,
                          onBack: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(height: 24.0),
                        _CategoriasGrid(
                          theme: theme,
                          cols: _cols(width),
                          modulo: widget.modulo,
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
    required this.moduloId,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
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
          Icon(Icons.menu_book_rounded, size: 14.0, color: theme.primary),
          const SizedBox(width: 6.0),
          Text(
            'Categorias',
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
        FutureBuilder<List<ModulosDeConteudoRow>>(
          future: moduloId == null
              ? Future<List<ModulosDeConteudoRow>>.value(const [])
              : ModulosDeConteudoTable().queryRows(
                  queryFn: (q) => q.eqOrNull('id', moduloId),
                ),
          builder: (context, snapshot) {
            final nome = snapshot.data?.firstOrNull?.nomeModulo?.trim();
            final txt = (nome != null && nome.isNotEmpty)
                ? nome
                : 'Categorias';
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
        Text(
          'Explore as categorias disponíveis neste módulo.',
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
// Grid wrapper
// ---------------------------------------------------------------------------

class _CategoriasGrid extends StatelessWidget {
  const _CategoriasGrid({
    required this.theme,
    required this.cols,
    required this.modulo,
    required this.aula,
  });

  final FlutterFlowTheme theme;
  final int cols;
  final String? modulo;
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
      child: FutureBuilder<List<CategoriasDeConteudoRow>>(
        future: CategoriasDeConteudoTable().queryRows(
          queryFn: (q) => q
              .eqOrNull('status_categoria', true)
              .order('nome_categoria', ascending: true),
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
          final categorias = snapshot.data!;
          if (categorias.isEmpty) {
            return _EmptyState(theme: theme);
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Icon(Icons.category_rounded,
                          size: 14.0, color: theme.primary),
                      const SizedBox(width: 6.0),
                      Text(
                        '${categorias.length} ${categorias.length == 1 ? 'categoria' : 'categorias'}',
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
                const SizedBox(height: 16.0),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.45,
                  ),
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final c = categorias[index];
                    return _CategoriaCard(
                      theme: theme,
                      categoria: c,
                      modulo: modulo,
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
// CategoriaCard
// ---------------------------------------------------------------------------

class _CategoriaCard extends StatefulWidget {
  const _CategoriaCard({
    required this.theme,
    required this.categoria,
    required this.modulo,
    required this.aula,
    required this.index,
  });

  final FlutterFlowTheme theme;
  final CategoriasDeConteudoRow categoria;
  final String? modulo;
  final String? aula;
  final int index;

  @override
  State<_CategoriaCard> createState() => _CategoriaCardState();
}

class _CategoriaCardState extends State<_CategoriaCard> {
  bool _hover = false;

  static const _palette = <List<Color>>[
    [Color(0xFF065F46), Color(0xFF10B981)],
    [Color(0xFF1E40AF), Color(0xFF3B82F6)],
    [Color(0xFF7E22CE), Color(0xFFA855F7)],
    [Color(0xFFB45309), Color(0xFFF59E0B)],
    [Color(0xFFBE185D), Color(0xFFEC4899)],
    [Color(0xFF155E75), Color(0xFF06B6D4)],
    [Color(0xFF991B1B), Color(0xFFEF4444)],
    [Color(0xFF3F6212), Color(0xFF84CC16)],
    [Color(0xFF6B21A8), Color(0xFFD946EF)],
    [Color(0xFF1E3A8A), Color(0xFF60A5FA)],
  ];

  void _open() {
    context.pushNamed(
      ConteudosWidget.routeName,
      queryParameters: {
        'modulo': serializeParam(widget.modulo, ParamType.String),
        'categoria':
            serializeParam(widget.categoria.id, ParamType.String),
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

  IconData _iconFor(String nome) {
    final n = nome.toLowerCase();
    if (n.contains('drill')) return Icons.fitness_center_rounded;
    if (n.contains('filme') || n.contains('vídeo') || n.contains('video')) {
      return Icons.movie_rounded;
    }
    if (n.contains('game') || n.contains('jogo')) {
      return Icons.sports_esports_rounded;
    }
    if (n.contains('grammar') || n.contains('gramática')) {
      return Icons.menu_book_rounded;
    }
    if (n.contains('história') || n.contains('historia') || n.contains('story')) {
      return Icons.auto_stories_rounded;
    }
    if (n.contains('imagem')) return Icons.image_rounded;
    if (n.contains('listening') || n.contains('audio') || n.contains('áudio')) {
      return Icons.hearing_rounded;
    }
    if (n.contains('música') || n.contains('musica') || n.contains('music')) {
      return Icons.music_note_rounded;
    }
    if (n.contains('teatro') || n.contains('drama')) {
      return Icons.theater_comedy_rounded;
    }
    return Icons.collections_bookmark_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final c = widget.categoria;
    final colors = _palette[widget.index % _palette.length];
    final nome = (c.nomeCategoria ?? '').trim();
    final imagem = (c.imagemCategoria ?? '').trim();
    final fallbackIcon = _iconFor(nome);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        scale: _hover ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: t.primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: _hover
                  ? colors[1].withValues(alpha: 0.45)
                  : t.alternate,
              width: 1.0,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: colors[1].withValues(alpha: 0.20),
                      blurRadius: 18.0,
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
                padding: const EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: colors,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors[1].withValues(alpha: 0.28),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: imagem.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                imagem,
                                width: 26.0,
                                height: 26.0,
                                fit: BoxFit.contain,
                                color: Colors.white,
                                colorBlendMode: BlendMode.srcIn,
                                errorBuilder: (ctx, _, __) =>
                                    Icon(fallbackIcon,
                                        color: Colors.white, size: 22.0),
                              ),
                            )
                          : Icon(fallbackIcon,
                              color: Colors.white, size: 22.0),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      nome.isEmpty ? 'Categoria' : nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                        color: t.primaryText,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: _hover
                            ? t.primary
                            : t.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver',
                            style: GoogleFonts.interTight(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: _hover ? Colors.white : t.primary,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 3.0),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 12.0,
                            color: _hover ? Colors.white : t.primary,
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
              child: Icon(Icons.category_rounded,
                  color: theme.primary, size: 32.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhuma categoria disponível',
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
                'As categorias deste módulo aparecerão aqui assim que forem ativadas.',
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
