import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// this class contains methods to open a scanning dialog
class QRScannerDialog extends StatefulWidget {
  const QRScannerDialog({
    super.key,
    required this.onScan,
  });

  final void Function(String data) onScan;

  @override
  State<QRScannerDialog> createState() => _QRScannerDialogState();
}
// try to open camera and show an error message in the case of failure. If it succeed then it will return the data scanned
class _QRScannerDialogState extends State<QRScannerDialog> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.qr_code, size: 20),
                const SizedBox(width: 8),
                const Text('Scan QR Code', style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C))),
                    const SizedBox(height: 6),
                    const Text(
                      'Make sure to allow camera access in your device settings.',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: MobileScanner(
                    controller: _controller,
                    onDetect: (capture) {
                      if (_handled) return;
                      final barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                        _handled = true;
                        widget.onScan(barcodes.first.rawValue!);
                        Navigator.of(context).pop();
                      }
                    },
                    errorBuilder: (context, error, child) {
                      setState(() => _error = 'Unable to access camera.');
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'Position the QR code within the frame to scan',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


