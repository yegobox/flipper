import 'package:flipper_models/models/ai_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/excel_analysis_provider.dart';
import 'package:flipper_dashboard/features/ai/widgets/data_visualization/structured_data_visualization.dart';

class ExcelAnalysisModal extends ConsumerStatefulWidget {
  final String filePath;
  final AIModel? preSelectedModel;

  const ExcelAnalysisModal({
    super.key,
    required this.filePath,
    this.preSelectedModel,
  });

  static void show(
    BuildContext context,
    String filePath, {
    AIModel? preSelectedModel,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Excel Analysis',
      pageBuilder: (context, _, __) => ExcelAnalysisModal(
        filePath: filePath,
        preSelectedModel: preSelectedModel,
      ),
    );
  }

  @override
  ConsumerState<ExcelAnalysisModal> createState() => _ExcelAnalysisModalState();
}

class _ExcelAnalysisModalState extends ConsumerState<ExcelAnalysisModal> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(excelAnalysisProvider.notifier)
          .initWithFile(
            widget.filePath,
            preSelectedModel: widget.preSelectedModel,
          );
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(excelAnalysisProvider);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Row(
                    children: [
                      // Column 1: Data Extracted
                      Expanded(flex: 3, child: _buildDataTable(state)),
                      const VerticalDivider(width: 1),
                      // Column 2: Visual Report / AI Context
                      Expanded(flex: 3, child: _buildVisualization(state)),
                      const VerticalDivider(width: 1),
                      // Column 3: AI Chat
                      Expanded(flex: 2, child: _buildChat(state)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final state = ref.watch(excelAnalysisProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF107C10).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.table_chart, color: Color(0xFF107C10)),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Excel Business Analyst',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Interactive Exploration & Visual Trends',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<AIModel>(
                  value: state.selectedModel,
                  underline: const SizedBox(),
                  isDense: true,
                  items: state.availableModels.map((model) {
                    return DropdownMenuItem<AIModel>(
                      value: model,
                      child: Text(
                        model.name + (model.isDefault ? ' (Default)' : ''),
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(excelAnalysisProvider.notifier).setModel(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(ExcelAnalysisState state) {
    if (state.isLoading && state.excelData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.excelData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_rows_outlined,
              size: 48,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text('No data found in Excel file'),
          ],
        ),
      );
    }

    final sheetName = state.excelData.keys.first;
    final headers =
        state.excelData[sheetName]?['headers'] as List<String>? ?? [];
    final rows =
        state.excelData[sheetName]?['rows'] as List<List<dynamic>>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                'Source Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(sheetName, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
                columns: headers
                    .map(
                      (h) => DataColumn(
                        label: Text(
                          h,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    .toList(),
                rows: rows
                    .map(
                      (r) => DataRow(
                        cells: r
                            .map((c) => DataCell(Text(c?.toString() ?? '')))
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisualization(ExcelAnalysisState state) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Visual Analysis:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (state.lastVisualizationData != null)
            Expanded(
              child: SingleChildScrollView(
                child: Builder(
                  builder: (context) {
                    try {
                      final viz = StructuredDataVisualization(
                        state.lastVisualizationData!,
                        null, // currencyService placeholder
                        cardKey: GlobalKey(),
                        onCopyGraph: () {},
                      );
                      return viz.build(context);
                    } catch (e) {
                      return Center(
                        child: Text(
                          'Error rendering chart: $e',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 64,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ask questions to generate charts',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChat(ExcelAnalysisState state) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Analyst Chat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: state.error != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Color(0xFFFF6B6B),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.error!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.history.length,
                  itemBuilder: (context, index) {
                    final message = state.history[index];
                    final isUser = message.role == 'user';
                    final text = message.parts
                        .where((p) => p.toJson().containsKey('text'))
                        .map((p) => p.toJson()['text'] as String)
                        .join('\n');

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.15,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFF0078D4)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              text,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: LinearProgressIndicator(),
          ),
        _buildInputArea(state),
      ],
    );
  }

  Widget _buildInputArea(ExcelAnalysisState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              decoration: InputDecoration(
                hintText: 'Ask about this data...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: state.isLoading ? null : _sendMessage,
            icon: const Icon(Icons.send, color: Color(0xFF0078D4)),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    _chatController.clear();
    ref.read(excelAnalysisProvider.notifier).analyzeMessage(text);

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
