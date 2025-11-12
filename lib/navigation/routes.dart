import 'package:visionscan/presentation/screens/document/operations/screen_merge_pdfs.dart';
import 'package:visionscan/presentation/screens/qr/screen_barcode_generate_result.dart';
import 'package:visionscan/presentation/screens/qr/screen_result.dart';

import '../presentation/screens/document/operations/screen_remove_pdf_pages.dart';
import '../presentation/screens/document/operations/screen_reorder_pdf_pages.dart';
import '../presentation/screens/document/operations/screen_select_pdf.dart';
import '../presentation/screens/document/operations/screen_split_pdf.dart';
import '../presentation/screens/document/screen_pdf_preview.dart';
import '../presentation/screens/document/screen_saved_pdfs.dart';
import '../presentation/screens/qr/screen_code_generate.dart';
import '../presentation/screens/qr/screen_qr_dashboard.dart';
import '../presentation/screens/qr/screen_qr_generate_result.dart';
import '../presentation/screens/qr/screen_qr_history.dart';
import '../presentation/screens/qr/screen_qr_scanner.dart';
import '../presentation/screens/screen_dashboard.dart';
import '../presentation/screens/screen_splash.dart';
import 'app_router.dart';

class Routes {
  static const splash = '/';
  static const dashboard = '/dashboard';
  static const qrDashboard = '/qrDashboard';
  static const savedPdfs = '/savedPdfs';
  static const mergePdfs = '/mergePdfs';
  static const splitPdfs = '/splitPdfs';
  static const selectPdf = '/selectPdf';
  static const pdfPreview = '/pdfPreview';
  static const qrHistory = '/qrHistory';
  static const qrScanner = '/qrScanner';
  static const qrGenerate = '/qrGenerate';
  static const qrScanResult = '/qrScanResult';
  static const qrGenerateResult = '/qrGenerateResult';
  static const barGenerateResult = '/barGenerateResult';
  static const documentScanPreview = '/documentScanPreview';
  static const removePdfPages = '/removePdfPages';
  static const reorderPdfPages = '/reorderPdfPages';
}

final appRoutes = <RouteConfig>[
  RouteConfig(name: Routes.splash, pattern: Routes.splash, builder: (context, params) => const ScreenSplash()),
  RouteConfig(name: Routes.dashboard, pattern: Routes.dashboard, builder: (context, params) => const ScreenDashboard()),
  RouteConfig(name: Routes.qrDashboard, pattern: Routes.qrDashboard, builder: (context, params) => const ScreenQRDashboard()),
  RouteConfig(name: Routes.savedPdfs, pattern: Routes.savedPdfs, builder: (context, params) => const ScreenSavedPdfs()),
  RouteConfig(name: Routes.mergePdfs, pattern: Routes.mergePdfs, builder: (context, params) => const ScreenMergePdfs()),
  RouteConfig(name: Routes.splitPdfs, pattern: Routes.splitPdfs, builder: (context, params) => const ScreenSplitPdf()),
  RouteConfig(
    name: Routes.selectPdf,
    pattern: Routes.selectPdf,
    builder: (context, params) {
      return ScreenSelectPdf(title: params["title"] as String);
    },
  ),
  RouteConfig(
    name: Routes.pdfPreview,
    pattern: Routes.pdfPreview,
    builder: (context, params) {
      return ScreenPdfPreview(scannedDocument: params["scannedDocuments"], isScanned: params["isScanned"]);
    },
  ),
  RouteConfig(name: Routes.qrHistory, pattern: Routes.qrHistory, builder: (context, params) => const ScreenQrHistory()),
  RouteConfig(name: Routes.qrScanner, pattern: Routes.qrScanner, builder: (context, params) => const ScreenQRScanner()),
  RouteConfig(
    name: Routes.qrGenerate,
    pattern: Routes.qrGenerate,
    builder: (context, params) {
      return ScreenCodeGenerate(type: params["type"], title: params["title"]);
    },
  ),
  RouteConfig(
    name: Routes.qrScanResult,
    pattern: Routes.qrScanResult,
    builder: (context, params) {
      return ScreenResult(qrContent: params["qrContent"]);
    },
  ),
  RouteConfig(
    name: Routes.qrGenerateResult,
    pattern: Routes.qrGenerateResult,
    builder: (context, params) {
      return ScreenQrGenerateResult(qrContent: params["qrContent"], type: params["type"]);
    },
  ),
  RouteConfig(
    name: Routes.barGenerateResult,
    pattern: Routes.barGenerateResult,
    builder: (context, params) {
      return ScreenBarCodeGenerateResult(barContent: params["barContent"], type: params["type"]);
    },
  ),
  RouteConfig(
    name: Routes.reorderPdfPages,
    pattern: Routes.reorderPdfPages,
    builder: (context, params) {
      return ScreenReorderPdfPages(selectedFile: params["selectedFile"]);
    },
  ),
  RouteConfig(
    name: Routes.removePdfPages,
    pattern: Routes.removePdfPages,
    builder: (context, params) {
      return ScreenRemovePdfPages(selectedFile: params["selectedFile"]);
    },
  ),
];
