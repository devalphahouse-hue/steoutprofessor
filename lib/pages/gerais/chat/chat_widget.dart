import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/componentes/nova_conversa/nova_conversa_widget.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  static String routeName = 'Chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late ChatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());
    _model.tfMobileTextController ??= TextEditingController();
    _model.tfMobileFocusNode ??= FocusNode();
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
                child: SidebarWidget(route: 'Chat'),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 24.0, hPad, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(theme: theme, isCompact: isCompact),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: FutureBuilder<ApiCallResponse>(
                          future: (_model.apiRequestCompleter ??=
                                  Completer<ApiCallResponse>()
                                    ..complete(SupabaseGroup
                                        .listaChatsAbertosCall
                                        .call(
                                      pUserId: currentUserUid,
                                      token: currentJwtToken,
                                    )))
                              .future,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Erro ao carregar dados.',
                                    style: theme.bodyMedium),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            theme.primary),
                                  ),
                                ),
                              );
                            }
                            final response = snapshot.data!;
                            final meusChats = (response.jsonBody
                                            .toList()
                                            .map<ChatAtivoStruct?>(
                                                ChatAtivoStruct.maybeFromMap)
                                            .toList()
                                        as Iterable<ChatAtivoStruct?>)
                                    .withoutNulls
                                    .toList();

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: isCompact ? 260.0 : 340.0,
                                  child: _ChatsListCard(
                                    theme: theme,
                                    chats: meusChats,
                                    activeChatId: FFAppState().chatId,
                                    onSelect: (id) {
                                      FFAppState().chatId = id;
                                      FFAppState().update(() {});
                                      safeSetState(() {});
                                    },
                                    onNovaConversa: () =>
                                        _abrirNovaConversa(context),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: _ActiveChatCard(
                                    theme: theme,
                                    chats: meusChats,
                                    activeChatId: FFAppState().chatId,
                                    model: _model,
                                  ),
                                ),
                              ],
                            );
                          },
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

  void _abrirNovaConversa(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(24.0),
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(dialogContext).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SizedBox(
              width: (width * 0.55).clamp(360.0, 640.0),
              height: (height * 0.78).clamp(420.0, 760.0),
              child: const NovaConversaWidget(),
            ),
          ),
        );
      },
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
              Icon(Icons.chat_bubble_rounded,
                  size: 14.0, color: theme.primary),
              const SizedBox(width: 6.0),
              Text(
                'Chat',
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
          'Mensagens',
          maxLines: 1,
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
          'Converse com seus alunos e a franquia.',
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
// Chats list card (left panel)
// ---------------------------------------------------------------------------

class _ChatsListCard extends StatelessWidget {
  const _ChatsListCard({
    required this.theme,
    required this.chats,
    required this.activeChatId,
    required this.onSelect,
    required this.onNovaConversa,
  });

  final FlutterFlowTheme theme;
  final List<ChatAtivoStruct> chats;
  final String? activeChatId;
  final ValueChanged<String> onSelect;
  final VoidCallback onNovaConversa;

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
            child: Row(
              children: [
                Text(
                  'Chats ativos',
                  style: GoogleFonts.interTight(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999.0),
                  ),
                  child: Text(
                    '${chats.length}',
                    style: GoogleFonts.interTight(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: theme.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1.0, color: theme.alternate),
          Expanded(
            child: chats.isEmpty
                ? _ChatsEmpty(theme: theme)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6.0),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return _ChatRow(
                        theme: theme,
                        chat: chat,
                        active: chat.chatId == activeChatId,
                        onTap: () => onSelect(chat.chatId),
                      );
                    },
                  ),
          ),
          Container(height: 1.0, color: theme.alternate),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: _NovaConversaButton(theme: theme, onTap: onNovaConversa),
          ),
        ],
      ),
    );
  }
}

class _ChatsEmpty extends StatelessWidget {
  const _ChatsEmpty({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.forum_outlined,
                  color: theme.primary, size: 26.0),
            ),
            const SizedBox(height: 14.0),
            Text(
              'Nenhum chat ativo',
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Inicie uma nova conversa para começar.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.0,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatRow extends StatefulWidget {
  const _ChatRow({
    required this.theme,
    required this.chat,
    required this.active,
    required this.onTap,
  });

  final FlutterFlowTheme theme;
  final ChatAtivoStruct chat;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<_ChatRow> {
  bool _hover = false;

  static const _fallbackAvatar =
      'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final user = widget.chat.otherUser;
    final imagem = user.imagemPerfil;
    final imgUrl =
        (imagem.isNotEmpty) ? imagem : _fallbackAvatar;

    final Color bg = widget.active
        ? t.primary.withValues(alpha: 0.10)
        : (_hover ? t.primary.withValues(alpha: 0.05) : Colors.transparent);
    final Color borderColor = widget.active
        ? t.primary.withValues(alpha: 0.35)
        : Colors.transparent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: t.primaryBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: t.alternate, width: 1.0),
                    ),
                    child: Image.network(imgUrl, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nome.isEmpty ? 'Sem nome' : user.nome,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.interTight(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: t.primaryText,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Row(
                          children: [
                            _RoleBadge(theme: t, role: user.role),
                            if (widget.chat.turma.isNotEmpty) ...[
                              const SizedBox(width: 6.0),
                              Flexible(
                                child: Text(
                                  widget.chat.turma,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w600,
                                    color: t.secondaryText,
                                  ),
                                ),
                              ),
                            ],
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
      bg = theme.info != Colors.white
          ? theme.info.withValues(alpha: 0.18)
          : theme.primary.withValues(alpha: 0.10);
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
        role.isEmpty ? '—' : role,
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

class _NovaConversaButton extends StatefulWidget {
  const _NovaConversaButton({required this.theme, required this.onTap});

  final FlutterFlowTheme theme;
  final VoidCallback onTap;

  @override
  State<_NovaConversaButton> createState() => _NovaConversaButtonState();
}

class _NovaConversaButtonState extends State<_NovaConversaButton> {
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
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_comment_rounded,
                      color: Colors.white, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(
                    'Iniciar novo chat',
                    style: GoogleFonts.interTight(
                      fontSize: 13.0,
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
// Active chat card (right panel)
// ---------------------------------------------------------------------------

class _ActiveChatCard extends StatelessWidget {
  const _ActiveChatCard({
    required this.theme,
    required this.chats,
    required this.activeChatId,
    required this.model,
  });

  final FlutterFlowTheme theme;
  final List<ChatAtivoStruct> chats;
  final String? activeChatId;
  final ChatModel model;

  @override
  Widget build(BuildContext context) {
    final hasActive = activeChatId != null && activeChatId!.isNotEmpty;
    final chatAtivo = hasActive
        ? chats.where((e) => e.chatId == activeChatId).firstOrNull
        : null;

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
      clipBehavior: Clip.hardEdge,
      child: chatAtivo == null
          ? _NoChatSelected(theme: theme)
          : Column(
              children: [
                _ChatHeader(theme: theme, chat: chatAtivo),
                Container(height: 1.0, color: theme.alternate),
                Expanded(
                  child: _MessagesList(
                    theme: theme,
                    model: model,
                    chatId: chatAtivo.chatId,
                  ),
                ),
                Container(height: 1.0, color: theme.alternate),
                _MessageInput(
                  theme: theme,
                  model: model,
                  chatId: chatAtivo.chatId,
                ),
              ],
            ),
    );
  }
}

class _NoChatSelected extends StatelessWidget {
  const _NoChatSelected({required this.theme});

  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.chat_outlined,
                  color: theme.primary, size: 38.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Selecione um chat',
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
                'Escolha uma conversa na lista ao lado ou inicie um novo chat para começar a trocar mensagens.',
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

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.theme, required this.chat});

  final FlutterFlowTheme theme;
  final ChatAtivoStruct chat;

  static const _fallbackAvatar =
      'https://qmfitknztvxvzpgjyvxf.supabase.co/storage/v1/object/public/geral/Ellipse%2051.png';

  @override
  Widget build(BuildContext context) {
    final user = chat.otherUser;
    final imagem = user.imagemPerfil;
    final imgUrl =
        (imagem.isNotEmpty) ? imagem : _fallbackAvatar;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: theme.alternate, width: 1.0),
            ),
            child: Image.network(imgUrl, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.nome.isEmpty ? 'Sem nome' : user.nome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.interTight(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    _RoleBadge(theme: theme, role: user.role),
                    if (chat.turma.isNotEmpty) ...[
                      const SizedBox(width: 8.0),
                      Icon(Icons.school_rounded,
                          size: 13.0, color: theme.secondaryText),
                      const SizedBox(width: 4.0),
                      Flexible(
                        child: Text(
                          chat.turma,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({
    required this.theme,
    required this.model,
    required this.chatId,
  });

  final FlutterFlowTheme theme;
  final ChatModel model;
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
      child: StreamBuilder<List<MensagensChatsRow>>(
        stream: model.columnSupabaseStream ??= SupaFlow.client
            .from('mensagens_chats')
            .stream(primaryKey: ['id'])
            .eqOrNull('chat_id', chatId)
            .map((list) =>
                list.map((item) => MensagensChatsRow(item)).toList()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 36.0,
                height: 36.0,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.primary),
                ),
              ),
            );
          }
          final mensagens = snapshot.data!;
          if (mensagens.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.forum_outlined,
                      color: theme.secondaryText, size: 30.0),
                  const SizedBox(height: 10.0),
                  Text(
                    'Comece a conversa',
                    style: GoogleFonts.interTight(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (final m in mensagens)
                  _MessageBubble(
                    theme: theme,
                    mensagem: m,
                    isMine: m.senderId == currentUserUid,
                  ),
              ].divide(const SizedBox(height: 8.0)),
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.theme,
    required this.mensagem,
    required this.isMine,
  });

  final FlutterFlowTheme theme;
  final MensagensChatsRow mensagem;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final texto = mensagem.conteudo ?? '';
    final bg = isMine ? theme.primary : theme.primaryBackground;
    final fg = isMine ? Colors.white : theme.primaryText;

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.45,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14.0),
          topRight: const Radius.circular(14.0),
          bottomLeft: Radius.circular(isMine ? 14.0 : 4.0),
          bottomRight: Radius.circular(isMine ? 4.0 : 14.0),
        ),
        border: isMine
            ? null
            : Border.all(color: theme.alternate, width: 1.0),
        boxShadow: isMine
            ? [
                BoxShadow(
                  color: theme.primary.withValues(alpha: 0.18),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ]
            : const [],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
        child: Text(
          texto.isEmpty ? '—' : texto,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: fg,
            height: 1.4,
            letterSpacing: 0.0,
          ),
        ),
      ),
    );

    return Row(
      mainAxisAlignment:
          isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [bubble],
    );
  }
}

class _MessageInput extends StatefulWidget {
  const _MessageInput({
    required this.theme,
    required this.model,
    required this.chatId,
  });

  final FlutterFlowTheme theme;
  final ChatModel model;
  final String chatId;

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  bool _sending = false;

  Future<void> _enviar() async {
    final texto = (widget.model.tfMobileTextController?.text ?? '').trim();
    if (texto.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await MensagensChatsTable().insert({
        'sender_id': currentUserUid,
        'chat_id': widget.chatId,
        'conteudo': texto,
      });
      widget.model.tfMobileTextController?.clear();
      widget.model.apiRequestCompleter = null;
      await widget.model.waitForApiRequestCompleted();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.model.tfMobileTextController,
              focusNode: widget.model.tfMobileFocusNode,
              onChanged: (_) => EasyDebounce.debounce(
                '_model.tfMobileTextController',
                const Duration(milliseconds: 200),
                () => safeSetState(() {}),
              ),
              onFieldSubmitted: (_) => _enviar(),
              autofocus: false,
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 4,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: t.primaryText,
                letterSpacing: 0.0,
              ),
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem…',
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: t.secondaryText,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14.0, vertical: 12.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: t.alternate, width: 1.0),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: t.primary.withValues(alpha: 0.45),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: t.error, width: 1.0),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: t.error, width: 1.0),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                filled: true,
                fillColor: t.primaryBackground,
              ),
              validator:
                  widget.model.tfMobileTextControllerValidator?.asValidator(
                      context),
            ),
          ),
          const SizedBox(width: 8.0),
          _SendButton(theme: t, onTap: _enviar, busy: _sending),
        ],
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton({
    required this.theme,
    required this.onTap,
    required this.busy,
  });

  final FlutterFlowTheme theme;
  final VoidCallback onTap;
  final bool busy;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
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
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: t.primary,
          shape: BoxShape.circle,
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
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.busy ? null : widget.onTap,
            child: Center(
              child: widget.busy
                  ? const SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}
