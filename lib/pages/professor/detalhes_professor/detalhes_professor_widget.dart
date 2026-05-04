import '/backend/supabase/supabase.dart';
import '/componentes/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'detalhes_professor_model.dart';
export 'detalhes_professor_model.dart';

class DetalhesProfessorWidget extends StatefulWidget {
  const DetalhesProfessorWidget({
    super.key,
    required this.profId,
    required this.metaProfId,
  });

  final String? profId;
  final String? metaProfId;

  static String routeName = 'DetalhesProfessor';
  static String routePath = '/detalhesProfessor';

  @override
  State<DetalhesProfessorWidget> createState() =>
      _DetalhesProfessorWidgetState();
}

class _DetalhesProfessorWidgetState extends State<DetalhesProfessorWidget> {
  late DetalhesProfessorModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DetalhesProfessorModel());

    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldMask3 =
        MaskTextInputFormatter(mask: '(##) #####-####');
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textFieldMask4 = MaskTextInputFormatter(mask: '###.###.###-##');
    _model.textFieldFocusNode5 ??= FocusNode();
    _model.textFieldMask5 = MaskTextInputFormatter(mask: '##/##/####');
    _model.textFieldFocusNode6 ??= FocusNode();
    _model.textFieldFocusNode7 ??= FocusNode();
    _model.textFieldMask7 = MaskTextInputFormatter(mask: '#####-###');
    _model.textFieldFocusNode8 ??= FocusNode();
    _model.textFieldFocusNode9 ??= FocusNode();
    _model.textFieldFocusNode10 ??= FocusNode();
    _model.textFieldFocusNode11 ??= FocusNode();
    _model.textFieldFocusNode12 ??= FocusNode();
    _model.textFieldFocusNode13 ??= FocusNode();
    _model.textFieldFocusNode14 ??= FocusNode();

    SchedulerBinding.instance
        .addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  double _hPad(double w) {
    if (w < kBreakpointSmall) return 16.0;
    if (w < kBreakpointLarge) return 24.0;
    return 48.0;
  }

  Future<void> _selecionarFoto() async {
    final selectedMedia = await selectMediaWithSourceBottomSheet(
      context: context,
      storageFolderPath: 'imagens_perfil',
      allowPhoto: true,
    );
    if (selectedMedia == null ||
        !selectedMedia.every(
            (m) => validateFileFormat(m.storagePath, context))) {
      return;
    }
    safeSetState(
        () => _model.isDataUploading_uploadSubsFotoPerfil = true);
    var selectedUploadedFiles = <FFUploadedFile>[];
    var downloadUrls = <String>[];
    try {
      selectedUploadedFiles = selectedMedia
          .map((m) => FFUploadedFile(
                name: m.storagePath.split('/').last,
                bytes: m.bytes,
                height: m.dimensions?.height,
                width: m.dimensions?.width,
                blurHash: m.blurHash,
                originalFilename: m.originalFilename,
              ))
          .toList();
      downloadUrls = await uploadSupabaseStorageFiles(
        bucketName: 'geral',
        selectedFiles: selectedMedia,
      );
    } finally {
      _model.isDataUploading_uploadSubsFotoPerfil = false;
    }
    if (selectedUploadedFiles.length != selectedMedia.length ||
        downloadUrls.length != selectedMedia.length) {
      safeSetState(() {});
      return;
    }
    safeSetState(() {
      _model.uploadedLocalFile_uploadSubsFotoPerfil =
          selectedUploadedFiles.first;
      _model.uploadedFileUrl_uploadSubsFotoPerfil = downloadUrls.first;
    });
    await UsersTable().update(
      data: {
        'imagem_perfil': _model.uploadedFileUrl_uploadSubsFotoPerfil,
      },
      matchingRows: (rows) => rows.eqOrNull('id', widget.profId),
    );
  }

  Future<void> _salvar() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await UsersTable().update(
        data: {
          'nome': _model.textController1?.text,
          'email': _model.textController2?.text,
          'telefone': _model.textController3?.text,
          'cpf': _model.textController4?.text,
          'data_nascimento': _model.textController5?.text,
          'nacionalidade': _model.textController6?.text,
          'cep': _model.textController7?.text,
          'pais': _model.textController8?.text,
          'endereco': _model.textController9?.text,
          'bairro': _model.textController10?.text,
          'numero': _model.textController11?.text,
          'complemento': _model.textController12?.text,
          'cidade': _model.textController13?.text,
          'uf': _model.textController14?.text,
        },
        matchingRows: (rows) => rows.eqOrNull('id', widget.profId),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Alterações salvas com sucesso.'),
            backgroundColor: FlutterFlowTheme.of(context).success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
                child: SidebarWidget(route: 'Professor'),
              ),
              Expanded(
                child: FutureBuilder<List<UsersRow>>(
                  future: UsersTable().querySingleRow(
                    queryFn: (q) => q.eqOrNull('id', widget.profId),
                  ),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.primary),
                          ),
                        ),
                      );
                    }
                    final user = snapshot.data!.isNotEmpty
                        ? snapshot.data!.first
                        : null;

                    return SingleChildScrollView(
                      primary: false,
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(hPad, 24.0, hPad, 32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DetalhesProfessorHeader(
                              theme: theme,
                              isCompact: isCompact,
                              onBack: () => context.safePop(),
                            ),
                            const SizedBox(height: 24.0),
                            _DadosPessoaisSection(
                              theme: theme,
                              isCompact: isCompact,
                              model: _model,
                              user: user,
                              onSelecionarFoto: _selecionarFoto,
                            ),
                            const SizedBox(height: 16.0),
                            _EnderecoSection(
                              theme: theme,
                              isCompact: isCompact,
                              model: _model,
                              user: user,
                            ),
                            const SizedBox(height: 16.0),
                            _TurmasSection(
                              theme: theme,
                              profId: widget.profId,
                            ),
                            const SizedBox(height: 24.0),
                            _SaveBar(
                              theme: theme,
                              saving: _saving,
                              onSave: _salvar,
                              onCancel: () => context.safePop(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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

class _DetalhesProfessorHeader extends StatelessWidget {
  const _DetalhesProfessorHeader({
    required this.theme,
    required this.isCompact,
    required this.onBack,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BackButton(theme: theme, onTap: onBack),
        const SizedBox(width: 14.0),
        Expanded(
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
                    Icon(Icons.person_rounded,
                        size: 14.0, color: theme.primary),
                    const SizedBox(width: 6.0),
                    Text(
                      'Professor',
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
                'Detalhes do professor',
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
                'Edite os dados pessoais, endereço e turmas vinculadas.',
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  fontSize: 14.0,
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          color: _hover
              ? t.primary.withValues(alpha: 0.08)
              : t.primaryBackground,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: _hover
                ? t.primary.withValues(alpha: 0.40)
                : t.alternate,
            width: 1.0,
          ),
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
    );
  }
}

// ---------------------------------------------------------------------------
// Section card primitives
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.theme,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final FlutterFlowTheme theme;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18.0, color: theme.primary),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.interTight(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryText,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18.0),
            Container(height: 1.0, color: theme.alternate),
            const SizedBox(height: 18.0),
            child,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Labeled field
// ---------------------------------------------------------------------------

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.theme,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.initialValue,
    this.hint,
    this.keyboardType,
    this.icon,
    this.formatter,
  });

  final FlutterFlowTheme theme;
  final String label;
  final TextEditingController? Function() controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? hint;
  final TextInputType? keyboardType;
  final IconData? icon;
  final MaskTextInputFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.interTight(
            fontSize: 11.0,
            fontWeight: FontWeight.w800,
            color: theme.secondaryText,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller(),
          focusNode: focusNode,
          autofocus: false,
          keyboardType: keyboardType,
          inputFormatters: formatter != null ? [formatter!] : null,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            color: theme.primaryText,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 13.5,
              color: theme.secondaryText,
            ),
            prefixIcon: icon != null
                ? Icon(icon, size: 18.0, color: theme.secondaryText)
                : null,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
                horizontal: icon != null ? 12.0 : 14.0, vertical: 12.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.alternate, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: theme.primary.withValues(alpha: 0.50), width: 1.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.error, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.error, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: theme.primaryBackground,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Dados pessoais section
// ---------------------------------------------------------------------------

class _DadosPessoaisSection extends StatelessWidget {
  const _DadosPessoaisSection({
    required this.theme,
    required this.isCompact,
    required this.model,
    required this.user,
    required this.onSelecionarFoto,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final DetalhesProfessorModel model;
  final UsersRow? user;
  final VoidCallback onSelecionarFoto;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      theme: theme,
      icon: Icons.badge_rounded,
      title: 'Dados pessoais',
      subtitle: 'Informações de identificação e contato.',
      child: isCompact
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PhotoBlock(
                  theme: theme,
                  model: model,
                  user: user,
                  onSelecionar: onSelecionarFoto,
                ),
                const SizedBox(height: 18.0),
                _buildFields(context),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildFields(context)),
                const SizedBox(width: 24.0),
                _PhotoBlock(
                  theme: theme,
                  model: model,
                  user: user,
                  onSelecionar: onSelecionarFoto,
                ),
              ],
            ),
    );
  }

  Widget _buildFields(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabeledField(
          theme: theme,
          label: 'NOME COMPLETO',
          controller: () =>
              model.textController1 ??=
                  TextEditingController(text: user?.nome),
          focusNode: model.textFieldFocusNode1,
          initialValue: user?.nome,
          icon: Icons.person_outline_rounded,
          hint: 'Nome do professor',
        ),
        const SizedBox(height: 14.0),
        _TwoCol(
          isCompact: isCompact,
          left: _LabeledField(
            theme: theme,
            label: 'E-MAIL',
            controller: () =>
                model.textController2 ??=
                    TextEditingController(text: user?.email),
            focusNode: model.textFieldFocusNode2,
            initialValue: user?.email,
            keyboardType: TextInputType.emailAddress,
            icon: Icons.alternate_email_rounded,
            hint: 'email@exemplo.com',
          ),
          right: _LabeledField(
            theme: theme,
            label: 'TELEFONE',
            controller: () =>
                model.textController3 ??=
                    TextEditingController(text: user?.telefone),
            focusNode: model.textFieldFocusNode3,
            initialValue: user?.telefone,
            keyboardType: TextInputType.phone,
            icon: Icons.phone_outlined,
            formatter: model.textFieldMask3,
            hint: '(11) 99999-9999',
          ),
        ),
        const SizedBox(height: 14.0),
        _TwoCol(
          isCompact: isCompact,
          left: _LabeledField(
            theme: theme,
            label: 'CPF',
            controller: () =>
                model.textController4 ??=
                    TextEditingController(text: user?.cpf),
            focusNode: model.textFieldFocusNode4,
            initialValue: user?.cpf,
            icon: Icons.fingerprint_rounded,
            formatter: model.textFieldMask4,
            hint: '000.000.000-00',
          ),
          right: _LabeledField(
            theme: theme,
            label: 'DATA DE NASCIMENTO',
            controller: () =>
                model.textController5 ??=
                    TextEditingController(text: user?.dataNascimento),
            focusNode: model.textFieldFocusNode5,
            initialValue: user?.dataNascimento,
            icon: Icons.cake_outlined,
            formatter: model.textFieldMask5,
            hint: 'dd/mm/aaaa',
          ),
        ),
        const SizedBox(height: 14.0),
        _LabeledField(
          theme: theme,
          label: 'NACIONALIDADE',
          controller: () =>
              model.textController6 ??=
                  TextEditingController(text: user?.nacionalidade),
          focusNode: model.textFieldFocusNode6,
          initialValue: user?.nacionalidade,
          icon: Icons.flag_outlined,
          hint: 'Brasileiro',
        ),
      ],
    );
  }
}

class _PhotoBlock extends StatefulWidget {
  const _PhotoBlock({
    required this.theme,
    required this.model,
    required this.user,
    required this.onSelecionar,
  });

  final FlutterFlowTheme theme;
  final DetalhesProfessorModel model;
  final UsersRow? user;
  final VoidCallback onSelecionar;

  @override
  State<_PhotoBlock> createState() => _PhotoBlockState();
}

class _PhotoBlockState extends State<_PhotoBlock> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final m = widget.model;
    final url = (m.uploadedFileUrl_uploadSubsFotoPerfil.isNotEmpty)
        ? m.uploadedFileUrl_uploadSubsFotoPerfil
        : (widget.user?.imagemPerfil ?? '');
    final hasFoto = url.isNotEmpty;
    final loading = m.isDataUploading_uploadSubsFotoPerfil;

    return SizedBox(
      width: 168.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 132.0,
            height: 132.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: t.primaryBackground,
              shape: BoxShape.circle,
              border: Border.all(color: t.alternate, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: hasFoto
                ? Image.network(url, fit: BoxFit.cover)
                : Center(
                    child: Icon(Icons.person_rounded,
                        size: 64.0, color: t.alternate),
                  ),
          ),
          const SizedBox(height: 14.0),
          MouseRegion(
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
                  onTap: loading ? null : widget.onSelecionar,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 9.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (loading)
                          const SizedBox(
                            width: 14.0,
                            height: 14.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        else
                          const Icon(Icons.photo_camera_rounded,
                              size: 15.0, color: Colors.white),
                        const SizedBox(width: 6.0),
                        Text(
                          loading ? 'Enviando…' : 'Selecionar foto',
                          style: GoogleFonts.interTight(
                            fontSize: 12.5,
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
          ),
          const SizedBox(height: 8.0),
          Text(
            'PNG, JPG até 10MB',
            style: GoogleFonts.inter(
              fontSize: 11.0,
              color: t.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoCol extends StatelessWidget {
  const _TwoCol({
    required this.isCompact,
    required this.left,
    required this.right,
  });

  final bool isCompact;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          left,
          const SizedBox(height: 14.0),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 14.0),
        Expanded(child: right),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Endereço section
// ---------------------------------------------------------------------------

class _EnderecoSection extends StatelessWidget {
  const _EnderecoSection({
    required this.theme,
    required this.isCompact,
    required this.model,
    required this.user,
  });

  final FlutterFlowTheme theme;
  final bool isCompact;
  final DetalhesProfessorModel model;
  final UsersRow? user;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      theme: theme,
      icon: Icons.location_on_rounded,
      title: 'Endereço',
      subtitle: 'Localização residencial.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TwoCol(
            isCompact: isCompact,
            left: _LabeledField(
              theme: theme,
              label: 'CEP',
              controller: () =>
                  model.textController7 ??=
                      TextEditingController(text: user?.cep),
              focusNode: model.textFieldFocusNode7,
              initialValue: user?.cep,
              keyboardType: TextInputType.number,
              icon: Icons.search_rounded,
              formatter: model.textFieldMask7,
              hint: '00000-000',
            ),
            right: _LabeledField(
              theme: theme,
              label: 'PAÍS',
              controller: () =>
                  model.textController8 ??=
                      TextEditingController(text: user?.pais),
              focusNode: model.textFieldFocusNode8,
              initialValue: user?.pais,
              icon: Icons.public_rounded,
              hint: 'Brasil',
            ),
          ),
          const SizedBox(height: 14.0),
          _TwoCol(
            isCompact: isCompact,
            left: _LabeledField(
              theme: theme,
              label: 'ENDEREÇO',
              controller: () =>
                  model.textController9 ??=
                      TextEditingController(text: user?.endereco),
              focusNode: model.textFieldFocusNode9,
              initialValue: user?.endereco,
              icon: Icons.signpost_outlined,
              hint: 'Rua / Av.',
            ),
            right: _LabeledField(
              theme: theme,
              label: 'BAIRRO',
              controller: () =>
                  model.textController10 ??=
                      TextEditingController(text: user?.bairro),
              focusNode: model.textFieldFocusNode10,
              initialValue: user?.bairro,
              icon: Icons.holiday_village_outlined,
              hint: 'Bairro',
            ),
          ),
          const SizedBox(height: 14.0),
          _FourCol(
            isCompact: isCompact,
            children: [
              _LabeledField(
                theme: theme,
                label: 'NÚMERO',
                controller: () =>
                    model.textController11 ??=
                        TextEditingController(text: user?.numero),
                focusNode: model.textFieldFocusNode11,
                initialValue: user?.numero,
                hint: 'Nº',
              ),
              _LabeledField(
                theme: theme,
                label: 'COMPLEMENTO',
                controller: () =>
                    model.textController12 ??=
                        TextEditingController(text: user?.complemento),
                focusNode: model.textFieldFocusNode12,
                initialValue: user?.complemento,
                hint: 'Apto / Bloco',
              ),
              _LabeledField(
                theme: theme,
                label: 'CIDADE',
                controller: () =>
                    model.textController13 ??=
                        TextEditingController(text: user?.cidade),
                focusNode: model.textFieldFocusNode13,
                initialValue: user?.cidade,
                hint: 'Cidade',
              ),
              _LabeledField(
                theme: theme,
                label: 'UF',
                controller: () =>
                    model.textController14 ??=
                        TextEditingController(text: user?.uf),
                focusNode: model.textFieldFocusNode14,
                initialValue: user?.uf,
                hint: 'SP',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FourCol extends StatelessWidget {
  const _FourCol({required this.isCompact, required this.children});

  final bool isCompact;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 14.0),
            children[i],
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 12.0),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Turmas section
// ---------------------------------------------------------------------------

class _TurmasSection extends StatelessWidget {
  const _TurmasSection({required this.theme, required this.profId});

  final FlutterFlowTheme theme;
  final String? profId;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      theme: theme,
      icon: Icons.groups_rounded,
      title: 'Turmas vinculadas',
      subtitle: 'Turmas em que este professor é o responsável.',
      child: FutureBuilder<List<TurmasRow>>(
        future: TurmasTable().queryRows(
          queryFn: (q) => q.eqOrNull('professor_responsavel', profId),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(theme.primary),
                  ),
                ),
              ),
            );
          }
          final turmas = snapshot.data!;
          if (turmas.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                      child: Icon(Icons.groups_outlined,
                          color: theme.primary, size: 26.0),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'Nenhuma turma vinculada',
                      style: GoogleFonts.interTight(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: theme.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'As turmas atribuídas aparecerão aqui.',
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
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for (final t in turmas)
                _TurmaChip(theme: theme, nome: t.nomeDaTurma ?? '—'),
            ],
          );
        },
      ),
    );
  }
}

class _TurmaChip extends StatelessWidget {
  const _TurmaChip({required this.theme, required this.nome});

  final FlutterFlowTheme theme;
  final String nome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
            color: theme.primary.withValues(alpha: 0.20), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_rounded, size: 14.0, color: theme.primary),
          const SizedBox(width: 6.0),
          Text(
            nome,
            style: GoogleFonts.interTight(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: theme.primary,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Save bar
// ---------------------------------------------------------------------------

class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.theme,
    required this.saving,
    required this.onSave,
    required this.onCancel,
  });

  final FlutterFlowTheme theme;
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _SaveBarButton(
          theme: theme,
          label: 'Cancelar',
          icon: Icons.close_rounded,
          filled: false,
          onTap: onCancel,
        ),
        const SizedBox(width: 10.0),
        _SaveBarButton(
          theme: theme,
          label: saving ? 'Salvando…' : 'Salvar alterações',
          icon: Icons.check_rounded,
          filled: true,
          loading: saving,
          onTap: onSave,
        ),
      ],
    );
  }
}

class _SaveBarButton extends StatefulWidget {
  const _SaveBarButton({
    required this.theme,
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
    this.loading = false,
  });

  final FlutterFlowTheme theme;
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  final bool loading;

  @override
  State<_SaveBarButton> createState() => _SaveBarButtonState();
}

class _SaveBarButtonState extends State<_SaveBarButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final filled = widget.filled;

    final bg = filled
        ? t.primary
        : (_hover ? t.primary.withValues(alpha: 0.08) : t.primaryBackground);
    final fg = filled
        ? Colors.white
        : (_hover ? t.primary : t.primaryText);
    final borderColor = filled
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
            onTap: widget.loading ? null : widget.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18.0, vertical: 11.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.loading)
                    SizedBox(
                      width: 14.0,
                      height: 14.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(fg),
                      ),
                    )
                  else
                    Icon(widget.icon, size: 15.0, color: fg),
                  const SizedBox(width: 7.0),
                  Text(
                    widget.label,
                    style: GoogleFonts.interTight(
                      fontSize: 13.0,
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
    );
  }
}
