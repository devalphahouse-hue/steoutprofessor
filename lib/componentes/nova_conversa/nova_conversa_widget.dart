import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nova_conversa_model.dart';
export 'nova_conversa_model.dart';

class NovaConversaWidget extends StatefulWidget {
  const NovaConversaWidget({super.key});

  @override
  State<NovaConversaWidget> createState() => _NovaConversaWidgetState();
}

class _NovaConversaWidgetState extends State<NovaConversaWidget> {
  late NovaConversaModel _model;
  String _query = '';
  String? _busyUserId;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NovaConversaModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  String _str(dynamic item, String path, String fallback) {
    final v = getJsonField(item, path)?.toString();
    if (v == null || v.isEmpty || v == 'null') return fallback;
    return v;
  }

  Future<void> _abrirChat(BuildContext ctx, dynamic listaUsersItem) async {
    final userId = getJsonField(listaUsersItem, r'$.id').toString();
    if (_busyUserId != null) return;
    setState(() => _busyUserId = userId);
    try {
      _model.apiResultclt = await SupabaseGroup.buscarChatCall.call(
        pUserA: userId,
        pUserB: currentUserUid,
        token: currentJwtToken,
      );

      final found = SupabaseGroup.buscarChatCall
          .chatid((_model.apiResultclt?.jsonBody ?? ''));

      String chatId;
      if (found == 'false') {
        _model.criarchat = await ChatsTable().insert({
          'user1': currentUserUid,
          'user2': userId,
        });
        chatId = _model.criarchat!.id;
      } else {
        chatId = found!;
      }

      FFAppState().chatId = chatId;
      safeSetState(() {});

      if (!mounted) return;
      Navigator.of(ctx).maybePop();

      ctx.goNamed(
        ChatWidget.routeName,
        extra: <String, dynamic>{
          '__transition_info__': TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: const Duration(milliseconds: 0),
          ),
        },
      );
    } finally {
      if (mounted) setState(() => _busyUserId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 30.0,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _DialogHeader(
            theme: theme,
            onClose: () => Navigator.of(context).maybePop(),
          ),
          Container(height: 1.0, color: theme.alternate),
          _SearchField(
            theme: theme,
            onChanged: (v) {
              EasyDebounce.debounce(
                'nova_conversa_search',
                const Duration(milliseconds: 180),
                () => setState(() => _query = v.trim().toLowerCase()),
              );
            },
          ),
          Container(height: 1.0, color: theme.alternate),
          Expanded(
            child: FutureBuilder<ApiCallResponse>(
              future: _model.listaUser(
                requestFn: () =>
                    SupabaseGroup.listarContatosChatCall.call(
                  token: currentJwtToken,
                ),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.primary),
                      ),
                    ),
                  );
                }
                final response = snapshot.data!;
                final all = response.jsonBody.toList();
                final filtered = _query.isEmpty
                    ? all
                    : all.where((u) {
                        final nome =
                            _str(u, r'$.nome', '').toLowerCase();
                        final email =
                            _str(u, r'$.email', '').toLowerCase();
                        final role =
                            _str(u, r'$.role', '').toLowerCase();
                        return nome.contains(_query) ||
                            email.contains(_query) ||
                            role.contains(_query);
                      }).toList();

                if (all.isEmpty) {
                  return _EmptyContacts(
                    theme: theme,
                    title: 'Nenhum usuário encontrado',
                    subtitle:
                        'Quando houver usuários disponíveis, eles aparecerão aqui.',
                  );
                }
                if (filtered.isEmpty) {
                  return _EmptyContacts(
                    theme: theme,
                    title: 'Sem resultados',
                    subtitle:
                        'Nenhum contato corresponde a "${_query}".',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 14.0),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    final userId = _str(item, r'$.id', '');
                    return _ContactRow(
                      theme: theme,
                      nome: _str(item, r'$.nome', '[nome não cadastrado]'),
                      email: _str(item, r'$.email', '[sem email]'),
                      role: _str(item, r'$.role', '—'),
                      imagem: _str(item, r'$.imagem_perfil', ''),
                      busy: _busyUserId == userId,
                      onTap: () => _abrirChat(context, item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dialog header
// ---------------------------------------------------------------------------

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.theme, required this.onClose});

  final FlutterFlowTheme theme;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 18.0, 12.0, 16.0),
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
                Icon(Icons.add_comment_rounded,
                    size: 14.0, color: theme.primary),
                const SizedBox(width: 6.0),
                Text(
                  'Nova conversa',
                  style: GoogleFonts.interTight(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primary,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _CloseButton(theme: theme, onTap: onClose),
        ],
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
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
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: _hover ? t.alternate : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onTap,
            child: Tooltip(
              message: 'Fechar',
              child: Center(
                child: Icon(Icons.close_rounded,
                    color: t.primaryText, size: 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search field
// ---------------------------------------------------------------------------

class _SearchField extends StatelessWidget {
  const _SearchField({required this.theme, required this.onChanged});

  final FlutterFlowTheme theme;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.inter(
          fontSize: 13.5,
          color: theme.primaryText,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar por nome, email ou tipo…',
          hintStyle: GoogleFonts.inter(
            fontSize: 13.5,
            color: theme.secondaryText,
          ),
          prefixIcon: Icon(Icons.search_rounded,
              size: 18.0, color: theme.secondaryText),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.alternate, width: 1.0),
            borderRadius: BorderRadius.circular(999.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: theme.primary.withValues(alpha: 0.45), width: 1.5),
            borderRadius: BorderRadius.circular(999.0),
          ),
          filled: true,
          fillColor: theme.primaryBackground,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contact row
// ---------------------------------------------------------------------------

class _ContactRow extends StatefulWidget {
  const _ContactRow({
    required this.theme,
    required this.nome,
    required this.email,
    required this.role,
    required this.imagem,
    required this.busy,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final String nome;
  final String email;
  final String role;
  final String imagem;
  final bool busy;
  final VoidCallback onTap;

  static const _fallbackAvatar =
      'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final imgUrl = widget.imagem.isNotEmpty
        ? widget.imagem
        : _ContactRow._fallbackAvatar;

    return MouseRegion(
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: t.secondaryBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: t.alternate, width: 1.0),
                ),
                child: Image.network(imgUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.interTight(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                        color: t.primaryText,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      widget.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: t.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    _RoleBadge(theme: t, role: widget.role),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              _OpenChatButton(
                theme: t,
                busy: widget.busy,
                onTap: widget.onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.theme, required this.role});

  final FlutterFlowTheme theme;
  final String role;

  @override
  Widget build(BuildContext context) {
    final lower = role.toLowerCase();
    Color bg;
    Color fg;
    if (lower == 'aluno') {
      bg = theme.primary.withValues(alpha: 0.10);
      fg = theme.primary;
    } else if (lower == 'professor') {
      bg = theme.warning.withValues(alpha: 0.16);
      fg = theme.warning;
    } else if (lower == 'franquia') {
      bg = theme.success.withValues(alpha: 0.14);
      fg = theme.success;
    } else {
      bg = theme.alternate;
      fg = theme.secondaryText;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.0),
      ),
      child: Text(
        role,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _OpenChatButton extends StatefulWidget {
  const _OpenChatButton({
    required this.theme,
    required this.busy,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final bool busy;
  final VoidCallback onTap;

  @override
  State<_OpenChatButton> createState() => _OpenChatButtonState();
}

class _OpenChatButtonState extends State<_OpenChatButton> {
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
          color: t.primary,
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
            onTap: widget.busy ? null : widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.busy)
                    const SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    const Icon(Icons.send_rounded,
                        color: Colors.white, size: 14.0),
                  const SizedBox(width: 6.0),
                  Text(
                    widget.busy ? 'Abrindo…' : 'Abrir chat',
                    style: GoogleFonts.interTight(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
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

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyContacts extends StatelessWidget {
  const _EmptyContacts({
    required this.theme,
    required this.title,
    required this.subtitle,
  });

  final FlutterFlowTheme theme;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 56.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.0,
              height: 64.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.people_outline_rounded,
                  color: theme.primary, size: 28.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: GoogleFonts.interTight(
                fontSize: 15.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6.0),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
