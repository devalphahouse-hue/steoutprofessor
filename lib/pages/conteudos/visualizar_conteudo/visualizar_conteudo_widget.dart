import '/componentes/sidebar_slim/sidebar_slim_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'visualizar_conteudo_model.dart';
export 'visualizar_conteudo_model.dart';

class VisualizarConteudoWidget extends StatefulWidget {
  const VisualizarConteudoWidget({super.key});

  static String routeName = 'VisualizarConteudo';
  static String routePath = '/visualizarConteudo';

  @override
  State<VisualizarConteudoWidget> createState() =>
      _VisualizarConteudoWidgetState();
}

class _VisualizarConteudoWidgetState extends State<VisualizarConteudoWidget> {
  late VisualizarConteudoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VisualizarConteudoModel());
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
    return 32.0;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 768;
    final hPad = _hPad(width);
    final link = FFAppState().linkconteudo;

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
                model: _model.sidebarSlimModel,
                updateCallback: () => safeSetState(() {}),
                child: SidebarSlimWidget(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 24.0, hPad, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _Header(
                        theme: theme,
                        isCompact: isCompact,
                        link: link,
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: _ViewerCard(
                          theme: theme,
                          link: link,
                        ),
                      ),
                    ],
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
    required this.link,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final String link;
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
          Icon(Icons.play_circle_fill_rounded,
              size: 14.0, color: theme.primary),
          const SizedBox(width: 6.0),
          Text(
            'Conteúdo',
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
          'Visualizar conteúdo',
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
          'Use o botão ao lado para abrir em nova aba se a prévia não carregar.',
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
    final actionBtn = _OpenExternalButton(
      theme: theme,
      onTap: link.isEmpty ? null : () => launchURL(link),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: backBtn,
              ),
              const SizedBox(width: 12.0),
              Expanded(child: titleCol),
            ],
          ),
          const SizedBox(height: 12.0),
          Align(alignment: Alignment.centerLeft, child: actionBtn),
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
        const SizedBox(width: 14.0),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: actionBtn,
        ),
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

class _OpenExternalButton extends StatefulWidget {
  const _OpenExternalButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback? onTap;

  @override
  State<_OpenExternalButton> createState() => _OpenExternalButtonState();
}

class _OpenExternalButtonState extends State<_OpenExternalButton> {
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
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: (_hover && !disabled) ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: disabled ? t.alternate.withValues(alpha: 0.4) : t.primary,
            borderRadius: BorderRadius.circular(999.0),
            boxShadow: (_hover && !disabled)
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
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 14.0,
                      color: disabled ? t.secondaryText : Colors.white,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Abrir em nova aba',
                      style: GoogleFonts.interTight(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: disabled ? t.secondaryText : Colors.white,
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

// ---------------------------------------------------------------------------
// ViewerCard
// ---------------------------------------------------------------------------

class _ViewerCard extends StatelessWidget {
  const _ViewerCard({required this.theme, required this.link});

  final FlutterFlowTheme theme;
  final String link;

  @override
  Widget build(BuildContext context) {
    if (link.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: theme.alternate, width: 1.0),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
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
                child: Icon(Icons.link_off_rounded,
                    color: theme.primary, size: 32.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Sem conteúdo carregado',
                style: GoogleFonts.interTight(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryText,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                'Volte e selecione um conteúdo para visualizar.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: theme.secondaryText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: custom_widgets.WebViewer(
          width: double.infinity,
          height: double.infinity,
          url: link,
        ),
      ),
    );
  }
}
