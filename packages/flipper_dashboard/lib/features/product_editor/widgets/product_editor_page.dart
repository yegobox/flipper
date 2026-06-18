import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_footer.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_section.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_section_nav.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_topbar.dart';
import 'package:flutter/material.dart';

class ProductEditorSectionContent {
  const ProductEditorSectionContent({
    required this.def,
    required this.sectionKey,
    required this.child,
  });

  final ProductEditorSectionDef def;
  final GlobalKey sectionKey;
  final Widget child;
}

class ProductEditorPage extends StatefulWidget {
  const ProductEditorPage({
    super.key,
    required this.isEditMode,
    required this.isComposite,
    this.productNameController,
    required this.sections,
    required this.onBack,
    required this.onClose,
    required this.onSave,
    required this.isSaving,
    this.formListenable,
    this.canSaveBuilder,
    this.sectionDefsBuilder,
    this.loadingOverlay,
  }) : assert(
         productNameController != null ||
             (canSaveBuilder != null && sectionDefsBuilder != null),
       );

  final bool isEditMode;
  final bool isComposite;
  final TextEditingController? productNameController;
  final List<ProductEditorSectionContent> sections;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final VoidCallback onSave;
  final bool isSaving;
  final Listenable? formListenable;
  final bool Function()? canSaveBuilder;
  final List<ProductEditorSectionDef> Function()? sectionDefsBuilder;
  final Widget? loadingOverlay;

  @override
  State<ProductEditorPage> createState() => _ProductEditorPageState();
}

class _ProductEditorPageState extends State<ProductEditorPage> {
  final ScrollController _scrollController = ScrollController();
  String _activeId = 'basics';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void didUpdateWidget(covariant ProductEditorPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sections.length != widget.sections.length) {
      final ids = widget.sections.map((s) => s.def.id).toSet();
      if (!ids.contains(_activeId) && widget.sections.isNotEmpty) {
        _activeId = widget.sections.first.def.id;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final top = _scrollController.offset + 90;
    String? current;
    for (final section in widget.sections) {
      final ctx = section.sectionKey.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final pos = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
      if (pos.dy <= top) {
        current = section.def.id;
      }
    }
    if (current != null && current != _activeId) {
      setState(() => _activeId = current!);
    }
  }

  void _goToSection(String id) {
    final section = widget.sections.firstWhere((s) => s.def.id == id);
    final ctx = section.sectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    }
    setState(() => _activeId = id);
  }

  int get _doneCount => _navDefs.where((s) => s.isFilled).length;

  List<ProductEditorSectionDef> get _navDefs =>
      widget.sectionDefsBuilder?.call() ??
      widget.sections.map((s) => s.def).toList();

  bool get _canSave => widget.canSaveBuilder?.call() ?? false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useHorizontalNav = width <= ProductEditorTokens.breakpointNav;
    final hideFooterClose = width <= ProductEditorTokens.breakpointStack;

    Widget chrome(List<ProductEditorSectionDef> navDefs, bool canSave) {
      return Column(
        children: [
          ProductEditorTopBar(
            isEditMode: widget.isEditMode,
            isComposite: widget.isComposite,
            productNameController: widget.productNameController,
            onBack: widget.onBack,
            isSaving: widget.isSaving,
          ),
          Expanded(
            child: ColoredBox(
              color: ProductEditorTokens.app,
              child: Column(
                children: [
                  if (useHorizontalNav)
                    ProductEditorSectionNav(
                      sections: navDefs,
                      activeId: _activeId,
                      onSectionTap: _goToSection,
                      horizontal: true,
                    ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!useHorizontalNav)
                          ProductEditorSectionNav(
                            sections: navDefs,
                            activeId: _activeId,
                            onSectionTap: _goToSection,
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: _buildSheet(useHorizontalNav)),
                              ProductEditorFooter(
                                doneCount:
                                    navDefs.where((s) => s.isFilled).length,
                                totalCount: navDefs.length,
                                canSave: canSave,
                                isSaving: widget.isSaving,
                                onClose: widget.onClose,
                                onSave: widget.onSave,
                                hideClose: hideFooterClose,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final body = widget.formListenable != null
        ? ListenableBuilder(
            listenable: widget.formListenable!,
            builder: (context, _) => chrome(_navDefs, _canSave),
          )
        : chrome(_navDefs, _canSave);

    return Scaffold(
      backgroundColor: ProductEditorTokens.bg,
      body: Stack(
        children: [
          body,
          if (widget.loadingOverlay != null) widget.loadingOverlay!,
        ],
      ),
    );
  }

  Widget _buildSheet(bool useHorizontalNav) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: useHorizontalNav ? 18 : 36,
        vertical: useHorizontalNav ? 22 : 30,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ProductEditorTokens.sheetMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < widget.sections.length; i++) ...[
                ProductEditorSection(
                  sectionKey: widget.sections[i].sectionKey,
                  number: i + 1,
                  title: widget.sections[i].def.title,
                  subtitle: widget.sections[i].def.subtitle,
                  child: widget.sections[i].child,
                ),
                if (i < widget.sections.length - 1)
                  const SizedBox(height: ProductEditorTokens.sectionGap),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
