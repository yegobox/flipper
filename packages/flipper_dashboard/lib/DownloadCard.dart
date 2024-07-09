import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadCard extends StatefulWidget {
  final String url;
  final String filename;
  final bool downloaded;
  final Report report;

  const DownloadCard({
    Key? key,
    required this.url,
    required this.filename,
    required this.downloaded,
    required this.report,
  }) : super(key: key);

  @override
  _DownloadCardState createState() => _DownloadCardState();
}

class _DownloadCardState extends State<DownloadCard> {
  bool _downloading = false;
  double _progress = 0;
  String? _filePath;
  String? _error;

  Future<void> _downloadFile() async {
    if (_downloading || widget.downloaded) return;

    setState(() {
      _downloading = true;
      _progress = 0;
      _error = null;
    });

    try {
      // Assuming `ProxyService.realm.downloadAssetSave` returns a stream of download progress
      Stream<double> progressStream =
          await ProxyService.realm.downloadAssetSave(
        assetName: widget.filename,
        subPath: "reports",
      );

      final dir = await getApplicationSupportDirectory();
      final filePath = '${dir.path}/${widget.filename}';
      // final filePath = '${dir.path}/REPORT_20240707.XLSX';
      final file = File(filePath);

      // Subscribe to the progress stream
      await for (final progress in progressStream) {
        setState(() {
          _progress = progress;
        });

        // Handle the actual download and file writing logic within the stream
        // This might vary depending on how the stream and download are implemented
      }

      // After stream is done, update state and write the downloaded file
      await file.writeAsBytes(await file.readAsBytes());

      setState(() {
        _downloading = false;
        _filePath = filePath;
      });

      ProxyService.realm.realm!.write(() {
        widget.report.downloaded = true;
      });
    } catch (e) {
      setState(() {
        _downloading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _downloadFile,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.table_chart,
                    color: Colors.green[700],
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.filename,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Excel Spreadsheet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_downloading || widget.downloaded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.downloaded
                        ? 'Downloaded'
                        : 'Downloading: ${(_progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: widget.downloaded ? 1.0 : _progress,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                  ),
                ],
              )
            else if (_error != null)
              Text(
                'Error: $_error',
                style: TextStyle(fontSize: 14, color: Colors.red[700]),
              )
            else if (_filePath != null)
              Text(
                'Downloaded to: $_filePath',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Text(
                'Click to download',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
