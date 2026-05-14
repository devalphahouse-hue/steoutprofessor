import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/custom_code/actions/detect_browser.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendario_aulas_lista_model.dart';
export 'calendario_aulas_lista_model.dart';

class CalendarioAulasListaWidget extends StatefulWidget {
  const CalendarioAulasListaWidget({super.key});

  static String routeName = 'CalendarioAulasLista';
  static String routePath = '/calendarioAulasLista';

  @override
  State<CalendarioAulasListaWidget> createState() =>
      _CalendarioAulasListaWidgetState();
}

class _CalendarioAulasListaWidgetState
    extends State<CalendarioAulasListaWidget> {
  late CalendarioAulasListaModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarioAulasListaModel());
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
                child: SidebarWidget(route: 'Aulas'),
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
                        _AulasCard(theme: theme, isCompact: isCompact),
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
              Icon(Icons.calendar_today_rounded,
                  size: 14.0, color: theme.primary),
              const SizedBox(width: 6.0),
              Text(
                'Calendário',
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
          'Calendário de aulas',
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
          'Acompanhe as próximas aulas programadas.',
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
// AulasCard wrapper
// ---------------------------------------------------------------------------

enum _PeriodoFiltro { todas, hoje, estaSemana, proximaSemana, proximos30 }

class _AulasCard extends StatefulWidget {
  const _AulasCard({required this.theme, required this.isCompact});

  final FlutterFlowTheme theme;
  final bool isCompact;

  @override
  State<_AulasCard> createState() => _AulasCardState();
}

class _AulasCardState extends State<_AulasCard> {
  _PeriodoFiltro _periodo = _PeriodoFiltro.todas;

  static (DateTime, DateTime)? _intervalo(_PeriodoFiltro p) {
    final now = DateTime.now();
    final hoje = DateTime(now.year, now.month, now.day);
    switch (p) {
      case _PeriodoFiltro.todas:
        return null;
      case _PeriodoFiltro.hoje:
        return (hoje, hoje.add(const Duration(days: 1)));
      case _PeriodoFiltro.estaSemana:
        final inicio = hoje.subtract(Duration(days: hoje.weekday - 1));
        return (inicio, inicio.add(const Duration(days: 7)));
      case _PeriodoFiltro.proximaSemana:
        final inicioEstaSemana =
            hoje.subtract(Duration(days: hoje.weekday - 1));
        final inicio = inicioEstaSemana.add(const Duration(days: 7));
        return (inicio, inicio.add(const Duration(days: 7)));
      case _PeriodoFiltro.proximos30:
        return (hoje, hoje.add(const Duration(days: 30)));
    }
  }

  List<AulasRow> _filtrar(List<AulasRow> aulas) {
    final intervalo = _intervalo(_periodo);
    if (intervalo == null) return aulas;
    final (inicio, fim) = intervalo;
    return aulas.where((a) {
      final d = a.datetimeinicioAula;
      if (d == null) return false;
      return !d.isBefore(inicio) && d.isBefore(fim);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
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
      child: FutureBuilder<List<AulasRow>>(
        future: SupaFlow.client
            .from('Aulas')
            .select('*, turmas!inner(deleted_at)')
            .eq('professor_responsavel', currentUserUid)
            .gte(
              'datetimeinicio_aula',
              supaSerialize<DateTime>(getCurrentTimestamp)!,
            )
            .filter('turmas.deleted_at', 'is', null)
            .order('datetimeinicio_aula', ascending: true)
            .then((rows) => rows
                .map((r) => AulasRow(Map<String, dynamic>.from(r)))
                .toList()),
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
          final aulas = snapshot.data!;
          if (aulas.isEmpty) {
            return _EmptyState(theme: theme);
          }
          final filtradas = _filtrar(aulas);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Toolbar(theme: theme, total: filtradas.length),
                const SizedBox(height: 12.0),
                _PeriodoChips(
                  theme: theme,
                  selected: _periodo,
                  onChanged: (p) => setState(() => _periodo = p),
                ),
                const SizedBox(height: 16.0),
                if (filtradas.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: Text(
                        'Nenhuma aula no período selecionado.',
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtradas.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10.0),
                    itemBuilder: (context, index) {
                      return _AulaRow(
                        theme: theme,
                        aula: filtradas[index],
                        isCompact: widget.isCompact,
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

class _PeriodoChips extends StatelessWidget {
  const _PeriodoChips({
    required this.theme,
    required this.selected,
    required this.onChanged,
  });

  final FlutterFlowTheme theme;
  final _PeriodoFiltro selected;
  final ValueChanged<_PeriodoFiltro> onChanged;

  static const _opcoes = <(_PeriodoFiltro, String)>[
    (_PeriodoFiltro.todas, 'Todas'),
    (_PeriodoFiltro.hoje, 'Hoje'),
    (_PeriodoFiltro.estaSemana, 'Esta semana'),
    (_PeriodoFiltro.proximaSemana, 'Próxima semana'),
    (_PeriodoFiltro.proximos30, 'Próximos 30 dias'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < _opcoes.length; i++) ...[
            if (i > 0) const SizedBox(width: 8.0),
            _PeriodoChip(
              theme: theme,
              label: _opcoes[i].$2,
              active: selected == _opcoes[i].$1,
              onTap: () => onChanged(_opcoes[i].$1),
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodoChip extends StatefulWidget {
  const _PeriodoChip({
    required this.theme,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_PeriodoChip> createState() => _PeriodoChipState();
}

class _PeriodoChipState extends State<_PeriodoChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final active = widget.active;
    final bg = active
        ? theme.primary
        : (_hover
            ? theme.primary.withValues(alpha: 0.08)
            : theme.primaryBackground);
    final fg = active ? Colors.white : theme.primaryText;
    final borderColor =
        active ? theme.primary : theme.alternate;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999.0),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Text(
            widget.label,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              color: fg,
              letterSpacing: 0.0,
            ),
          ),
        ),
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
              Icon(Icons.event_rounded, size: 14.0, color: theme.primary),
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
              Icon(Icons.schedule_rounded,
                  size: 13.0, color: theme.secondaryText),
              const SizedBox(width: 4.0),
              Text(
                'Próximas',
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
// AulaRow
// ---------------------------------------------------------------------------

class _AulaRow extends StatefulWidget {
  const _AulaRow({
    required this.theme,
    required this.aula,
    required this.isCompact,
  });

  final FlutterFlowTheme theme;
  final AulasRow aula;
  final bool isCompact;

  @override
  State<_AulaRow> createState() => _AulaRowState();
}

class _AulaRowState extends State<_AulaRow> {
  bool _hover = false;

  void _openDetalhes() {
    context.pushNamed(
      DetalhesAulaWidget.routeName,
      queryParameters: {
        'idAula':
            serializeParam(widget.aula.id, ParamType.String),
      }.withoutNulls,
    );
  }

  Future<void> _entrarNaAula() async {
    final confirmou = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final browserName = detectBrowser();
        final isChrome = browserName == 'chrome';
        bool aceitou = false;
        return StatefulBuilder(
          builder: (stfContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                'Antes de entrar na aula',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.interTight(
                          fontWeight: FontWeight.w700),
                      letterSpacing: 0.0,
                    ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isChrome) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFDC2626), size: 22),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Voce esta usando ${browserDisplayName(browserName)}. Recomendamos fortemente o Google Chrome para evitar problemas de audio e video durante a aula.',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500),
                                      color: const Color(0xFFDC2626),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                    Text(
                      'Para garantir a melhor experiencia na aula ao vivo, siga estas dicas:',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.normal),
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildDicaItem(context, '1.',
                        'Use o Google Chrome — e o navegador mais compativel com a videochamada. Edge, Safari e Firefox podem causar problemas de audio e travamentos'),
                    _buildDicaItem(context, '2.',
                        'Verifique sua internet — abra outro site para confirmar. Conexoes instaveis causam travamento de video e quedas de audio'),
                    _buildDicaItem(context, '3.',
                        'Prefira cabo ou Wi-Fi forte — dados moveis (4G/5G) podem ser instaveis. Se estiver no Wi-Fi, fique proximo ao roteador'),
                    _buildDicaItem(context, '4.',
                        'Feche outros programas e abas — cada aba aberta consome memoria e banda. Feche tudo que nao for essencial'),
                    _buildDicaItem(context, '5.',
                        'Evite computador sobrecarregado — se seu PC estiver lento, reinicie-o antes da aula'),
                    _buildDicaItem(context, '6.',
                        'Teste camera e microfone antes — ao entrar na aula, voce vera uma tela para selecionar e testar seus dispositivos'),
                    const SizedBox(height: 12.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: aceitou,
                            activeColor: FlutterFlowTheme.of(context).primary,
                            onChanged: (v) => setDialogState(
                                () => aceitou = v ?? false),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Li e entendi as recomendacoes',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                _DialogConfirmButton(
                  enabled: aceitou,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
          },
        );
      },
    );
    if (confirmou != true) return;

    FFAppState().jaasJWT = '';
    safeSetState(() {});

    if (!mounted) return;
    context.pushNamed(
      SalaAulaWidget.routeName,
      queryParameters: {
        'aulaId': serializeParam(widget.aula.id, ParamType.String),
      }.withoutNulls,
    );
  }

  bool get _isLive {
    final inicio = widget.aula.datetimeinicioAula;
    final termino = widget.aula.datetimeTerminoaula;
    if (inicio == null || termino == null) return false;
    final agora = getCurrentTimestamp.secondsSinceEpoch;
    return agora >= functions.inicioMenos5Min(inicio)!.secondsSinceEpoch &&
        agora <= termino.secondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final aula = widget.aula;
    final inicio = aula.datetimeinicioAula;
    final termino = aula.datetimeTerminoaula;
    final lc = FFLocalizations.of(context).languageCode;
    final dia = inicio != null ? dateTimeFormat('d', inicio, locale: lc) : '--';
    final mes = inicio != null
        ? dateTimeFormat('MMM', inicio, locale: lc).toUpperCase()
        : '';
    final horario = (inicio != null && termino != null)
        ? '${dateTimeFormat('Hm', inicio, locale: lc)} - ${dateTimeFormat('Hm', termino, locale: lc)}'
        : '--';

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 12.0, 14.0, 12.0),
          child: widget.isCompact
              ? _buildCompact(t, dia, mes, horario)
              : _buildWide(t, dia, mes, horario),
        ),
      ),
    );
  }

  Widget _buildWide(FlutterFlowTheme t, String dia, String mes, String horario) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DateBlock(theme: t, dia: dia, mes: mes, isLive: _isLive),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<TurmasRow>>(
                future: TurmasTable().querySingleRow(
                  queryFn: (q) => q.eqOrNull('id', widget.aula.turma),
                ),
                builder: (context, snapshot) {
                  final nome = (snapshot.data?.isNotEmpty ?? false)
                      ? (snapshot.data!.first.nomeDaTurma ?? '—')
                      : '—';
                  return Text(
                    nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.interTight(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      color: t.primaryText,
                      letterSpacing: -0.2,
                    ),
                  );
                },
              ),
              const SizedBox(height: 6.0),
              Row(
                children: [
                  _StatusChip(theme: t, status: widget.aula.statusAula),
                  const SizedBox(width: 8.0),
                  Icon(Icons.access_time_rounded,
                      size: 13.0, color: t.secondaryText),
                  const SizedBox(width: 4.0),
                  Text(
                    horario,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: t.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12.0),
        _PillButton(
          theme: t,
          label: 'Detalhes',
          icon: Icons.arrow_forward_rounded,
          filled: false,
          onTap: _openDetalhes,
        ),
        if (_isLive) ...[
          const SizedBox(width: 8.0),
          _PillButton(
            theme: t,
            label: 'Entrar na aula',
            icon: Icons.video_call_rounded,
            filled: true,
            onTap: _entrarNaAula,
          ),
        ],
      ],
    );
  }

  Widget _buildCompact(FlutterFlowTheme t, String dia, String mes, String horario) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _DateBlock(theme: t, dia: dia, mes: mes, isLive: _isLive),
            const SizedBox(width: 12.0),
            Expanded(
              child: FutureBuilder<List<TurmasRow>>(
                future: TurmasTable().querySingleRow(
                  queryFn: (q) => q.eqOrNull('id', widget.aula.turma),
                ),
                builder: (context, snapshot) {
                  final nome = (snapshot.data?.isNotEmpty ?? false)
                      ? (snapshot.data!.first.nomeDaTurma ?? '—')
                      : '—';
                  return Text(
                    nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.interTight(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w800,
                      color: t.primaryText,
                      letterSpacing: -0.2,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 6.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _StatusChip(theme: t, status: widget.aula.statusAula),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: t.primaryBackground,
                borderRadius: BorderRadius.circular(999.0),
                border: Border.all(color: t.alternate, width: 1.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 12.0, color: t.secondaryText),
                  const SizedBox(width: 4.0),
                  Text(
                    horario,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: t.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(
              child: _PillButton(
                theme: t,
                label: 'Detalhes',
                icon: Icons.arrow_forward_rounded,
                filled: false,
                onTap: _openDetalhes,
                fullWidth: true,
              ),
            ),
            if (_isLive) ...[
              const SizedBox(width: 8.0),
              Expanded(
                child: _PillButton(
                  theme: t,
                  label: 'Entrar',
                  icon: Icons.video_call_rounded,
                  filled: true,
                  onTap: _entrarNaAula,
                  fullWidth: true,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// DateBlock
// ---------------------------------------------------------------------------

class _DateBlock extends StatelessWidget {
  const _DateBlock({
    required this.theme,
    required this.dia,
    required this.mes,
    required this.isLive,
  });

  final FlutterFlowTheme theme;
  final String dia;
  final String mes;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    final accent = isLive ? theme.success : theme.primary;
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.0),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dia,
            style: GoogleFonts.interTight(
              fontSize: 22.0,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: -0.6,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            mes,
            style: GoogleFonts.interTight(
              fontSize: 10.0,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// StatusChip
// ---------------------------------------------------------------------------

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.theme, required this.status});

  final FlutterFlowTheme theme;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final s = (status ?? '').trim();
    final lower = s.toLowerCase();
    Color bg;
    Color fg;
    IconData icon;

    if (lower.contains('finaliz')) {
      bg = theme.success.withValues(alpha: 0.14);
      fg = theme.success;
      icon = Icons.check_circle_rounded;
    } else if (lower.contains('andamento')) {
      bg = theme.primary.withValues(alpha: 0.14);
      fg = theme.primary;
      icon = Icons.play_circle_rounded;
    } else if (lower.contains('concl')) {
      bg = theme.success.withValues(alpha: 0.14);
      fg = theme.success;
      icon = Icons.task_alt_rounded;
    } else if (lower.contains('aguardando')) {
      bg = theme.warning.withValues(alpha: 0.16);
      fg = theme.warning;
      icon = Icons.schedule_rounded;
    } else if (s.isEmpty) {
      bg = theme.alternate;
      fg = theme.secondaryText;
      icon = Icons.help_outline_rounded;
    } else {
      bg = theme.alternate;
      fg = theme.secondaryText;
      icon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.0, color: fg),
          const SizedBox(width: 4.0),
          Text(
            s.isEmpty ? 'Sem status' : s,
            style: GoogleFonts.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PillButton (filled / outline)
// ---------------------------------------------------------------------------

class _PillButton extends StatefulWidget {
  const _PillButton({
    required this.theme,
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
    this.fullWidth = false,
  });

  final FlutterFlowTheme theme;
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  final bool fullWidth;

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final filled = widget.filled;

    final Color bg = filled
        ? (_hover ? t.primary : t.primary)
        : (_hover ? t.primary.withValues(alpha: 0.08) : t.primaryBackground);
    final Color fg = filled
        ? Colors.white
        : (_hover ? t.primary : t.primaryText);
    final Color borderColor = filled
        ? Colors.transparent
        : (_hover ? t.primary.withValues(alpha: 0.40) : t.alternate);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999.0),
          border: Border.all(color: borderColor, width: 1.0),
          boxShadow: filled && _hover
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
                  horizontal: 14.0, vertical: 8.0),
              child: Row(
                mainAxisSize:
                    widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.interTight(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: fg,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Icon(widget.icon, size: 14.0, color: fg),
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
              child: Icon(Icons.event_available_rounded,
                  color: theme.primary, size: 32.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Nenhuma aula programada',
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
                'Quando suas turmas tiverem aulas marcadas, elas aparecerão aqui.',
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

// ---------------------------------------------------------------------------
// Dialog confirm button
// ---------------------------------------------------------------------------

class _DialogConfirmButton extends StatelessWidget {
  const _DialogConfirmButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 8.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(999.0),
          onTap: enabled ? onPressed : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 22.0, vertical: 11.0),
            decoration: BoxDecoration(
              color: enabled ? theme.primary : const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(999.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmar e entrar',
                  style: GoogleFonts.interTight(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 6.0),
                const Icon(Icons.arrow_forward_rounded,
                    size: 15.0, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dica item (used in pre-class dialog)
// ---------------------------------------------------------------------------

Widget _buildDicaItem(BuildContext context, String numero, String texto) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          numero,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                letterSpacing: 0.0,
              ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            texto,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.normal),
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ],
    ),
  );
}
