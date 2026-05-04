import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'treinamentos_model.dart';
export 'treinamentos_model.dart';

class TreinamentosWidget extends StatefulWidget {
  const TreinamentosWidget({super.key});

  static String routeName = 'Treinamentos';
  static String routePath = '/treinamentos';

  @override
  State<TreinamentosWidget> createState() => _TreinamentosWidgetState();
}

class _TreinamentosWidgetState extends State<TreinamentosWidget> {
  late TreinamentosModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TreinamentosModel());
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
    final theme = FlutterFlowTheme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < kBreakpointMedium;
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
                child: SidebarWidget(route: 'Treinamentos'),
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
                        _Header(theme: theme, isCompact: isCompact),
                        const SizedBox(height: 24.0),
                        _TreinamentosCard(theme: theme),
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
  const _Header({required this.theme, required this.isCompact});

  final FlutterFlowTheme theme;
  final bool isCompact;

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
              Icon(Icons.school_rounded, size: 14.0, color: theme.primary),
              const SizedBox(width: 6.0),
              Text(
                'Treinamentos',
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
          'Treinamentos do professor',
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
          'Material de capacitação e dicas para suas aulas.',
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

// ---------------------------------------------------------------------------
// Card wrapper
// ---------------------------------------------------------------------------

class _TreinamentosCard extends StatelessWidget {
  const _TreinamentosCard({required this.theme});

  final FlutterFlowTheme theme;

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
      child: FutureBuilder<List<TreinamentosRow>>(
        future: TreinamentosTable().queryRows(
          queryFn: (q) => q
              .eqOrNull('status_treinamento', true)
              .eqOrNull('professor_treinamento', true),
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
          final treinamentos = snapshot.data!;
          if (treinamentos.isEmpty) {
            return _EmptyState(theme: theme);
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Toolbar(theme: theme, total: treinamentos.length),
                const SizedBox(height: 16.0),
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: treinamentos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    return _TreinamentoRow(
                      theme: theme,
                      treinamento: treinamentos[index],
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
              Icon(Icons.menu_book_rounded,
                  size: 14.0, color: theme.primary),
              const SizedBox(width: 6.0),
              Text(
                '$total ${total == 1 ? 'conteúdo' : 'conteúdos'}',
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
        Text(
          'Conteúdos',
          style: GoogleFonts.interTight(
            fontSize: 14.0,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// TreinamentoRow
// ---------------------------------------------------------------------------

class _TreinamentoRow extends StatefulWidget {
  const _TreinamentoRow({
    required this.theme,
    required this.treinamento,
    required this.index,
  });

  final FlutterFlowTheme theme;
  final TreinamentosRow treinamento;
  final int index;

  @override
  State<_TreinamentoRow> createState() => _TreinamentoRowState();
}

class _TreinamentoRowState extends State<_TreinamentoRow> {
  bool _hover = false;

  static const _palette = <List<Color>>[
    [Color(0xFF065F46), Color(0xFF10B981)],
    [Color(0xFF1E40AF), Color(0xFF3B82F6)],
    [Color(0xFF7E22CE), Color(0xFFA855F7)],
    [Color(0xFFB45309), Color(0xFFF59E0B)],
    [Color(0xFFBE185D), Color(0xFFEC4899)],
    [Color(0xFF155E75), Color(0xFF06B6D4)],
  ];

  Future<void> _abrir() async {
    final link = widget.treinamento.linkTreinamento;
    if (link == null || link.isEmpty) return;
    await launchURL(link);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final colors = _palette[widget.index % _palette.length];
    final titulo = (widget.treinamento.tituloTreinamento ?? '').trim();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: t.primaryBackground,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: _hover ? t.primary.withValues(alpha: 0.30) : t.alternate,
            width: 1.0,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 14.0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(14.0),
            onTap: _abrir,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: colors[1].withValues(alpha: 0.28),
                          blurRadius: 8.0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 22.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      titulo.isEmpty ? 'Sem título' : titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.interTight(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: t.primaryText,
                        letterSpacing: -0.1,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  _PillButton(
                    theme: t,
                    label: 'Visualizar',
                    icon: Icons.open_in_new_rounded,
                    onTap: _abrir,
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

// ---------------------------------------------------------------------------
// PillButton
// ---------------------------------------------------------------------------

class _PillButton extends StatefulWidget {
  const _PillButton({
    required this.theme,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: _hover ? t.primary : t.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999.0),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: t.primary.withValues(alpha: 0.30),
                    blurRadius: 12.0,
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
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 7.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.interTight(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w800,
                      color: _hover ? Colors.white : t.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Icon(widget.icon,
                      size: 13.0,
                      color: _hover ? Colors.white : t.primary),
                ],
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
              child: Icon(Icons.school_rounded,
                  color: theme.primary, size: 32.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhum treinamento disponível',
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
                'Quando a franquia publicar materiais para professores, eles aparecerão aqui.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
