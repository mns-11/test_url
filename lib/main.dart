import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class FlutterClipboard {
  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? true;
    runApp(VirusCheckApp(isDark: isDark));
  } catch (e, stackTrace) {
    debugPrint('Error initializing app: $e');
    debugPrint('Stack trace: $stackTrace');
    runApp(const VirusCheckApp(isDark: false));
  }
}

class VirusCheckApp extends StatefulWidget {
  final bool isDark;

  const VirusCheckApp({super.key, required this.isDark});

  @override
  State<VirusCheckApp> createState() => _VirusCheckAppState();
}

class _VirusCheckAppState extends State<VirusCheckApp> {
  late ThemeMode _themeMode;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initTheme();
  }

  Future<void> _initTheme() async {
    try {
      _themeMode = widget.isDark ? ThemeMode.dark : ThemeMode.light;
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Error initializing theme: $e');
      _themeMode = ThemeMode.system;
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    }
  }

  Future<void> _toggleTheme(bool isDark) async {
    try {
      setState(() {
        _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDark', isDark);
    } catch (e) {
      debugPrint('Error toggling theme: $e');
      if (mounted) {
        setState(() {
          _themeMode = _themeMode == ThemeMode.dark
              ? ThemeMode.light
              : ThemeMode.dark;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'فحص الروابط',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFEC4899),
          tertiary: const Color(0xFF8B5CF6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 57.0,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: const TextStyle(
            fontSize: 45.0,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(fontSize: 16.0),
          bodyMedium: const TextStyle(fontSize: 14.0),
          bodySmall: const TextStyle(fontSize: 12.0),
          labelLarge: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ).apply(bodyColor: Colors.black87, displayColor: Colors.black87),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF818CF8),
          secondary: const Color(0xFFF472B6),
          tertiary: const Color(0xFFA78BFA),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 57.0,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: const TextStyle(
            fontSize: 45.0,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: const TextStyle(fontSize: 16.0),
          bodyMedium: const TextStyle(fontSize: 14.0),
          bodySmall: const TextStyle(fontSize: 12.0),
          labelLarge: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF818CF8),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: LinkScannerPage(
        isDark: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class LinkScannerPage extends StatefulWidget {
  final bool isDark;
  final Function(bool) onThemeChanged;

  const LinkScannerPage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<LinkScannerPage> createState() => _LinkScannerPageState();
}

class _LinkScannerPageState extends State<LinkScannerPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _result = "";
  IconData _icon = Icons.link;
  Color _iconColor = Colors.grey;
  bool _loading = false;
  List<Map<String, dynamic>> _history = [];
  Map<String, dynamic>? _lastScanResult;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<Map<String, dynamic>> _filteredHistory = [];
  String _currentFilter = 'all';

  static const String _apiKey =
      'd144b68d500a696fd4d0ed937edcfad5496bbd67ed6909c982adabcf5198bb11';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _fadeController.forward();
    _loadHistory();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreHistory();
      }
    });
  }

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoadingMore = false);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('scan_history');
      if (historyJson != null) {
        final List<dynamic> historyList = jsonDecode(historyJson);
        setState(() {
          _history = historyList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          _filteredHistory = _history;
        });
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'scan_history',
        jsonEncode(_history.take(20).toList()),
      );
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  void _filterHistory(String status) {
    setState(() {
      _currentFilter = status;
      if (status == 'all') {
        _filteredHistory = _history;
      } else {
        _filteredHistory = _history.where((item) {
          switch (status) {
            case 'safe':
              return item['status'] == 'آمن';
            case 'suspicious':
              return item['status'] == 'مشبوه';
            case 'dangerous':
              return item['status'] == 'خطر';
            default:
              return true;
          }
        }).toList();
      }
    });
  }

  bool _validateUrl(String url) {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?'
      r'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|'
      r'((\d{1,3}\.){3}\d{1,3}))'
      r'(\:\d+)?(\/[-a-z\d%_.~+]*)*'
      r'(\?[;&a-z\d%_.~+=-]*)?'
      r'(\#[-a-z\d_]*)?\s*',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(url);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final url = _controller.text.trim();
      if (url.isNotEmpty) {
        scanLink(url);
      }
    }
  }

  Future<void> scanLink(String url) async {
    String processedUrl = url.trim();
    if (processedUrl.isEmpty) {
      setState(() {
        _result = "⚠️ الرجاء إدخال رابط للفحص";
        _icon = Icons.error_outline;
        _iconColor = Colors.orange;
      });
      return;
    }

    if (!processedUrl.startsWith('http://') &&
        !processedUrl.startsWith('https://')) {
      processedUrl = 'https://$processedUrl';
    }

    if (!_validateUrl(processedUrl)) {
      setState(() {
        _result = "⚠️ الرابط غير صالح";
        _icon = Icons.error_outline;
        _iconColor = Colors.orange;
      });
      return;
    }

    const apiUrl = 'https://www.virustotal.com/api/v3/urls';
    final scanTime = DateTime.now().toIso8601String();

    setState(() {
      _loading = true;
      _result = '🔄 جاري فحص الرابط...';
      _icon = Icons.search_rounded;
      _iconColor = Colors.blue;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
    _animationController.reset();
    _animationController.forward();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'x-apikey': _apiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'url': processedUrl},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'] as Map<String, dynamic>?;

        if (data == null) {
          throw Exception('استجابة API غير صالحة: لا توجد بيانات');
        }

        final scanId = data['id'] as String?;

        if (scanId == null || scanId.isEmpty) {
          throw Exception('تعذر الحصول على معرف الفحص من API');
        }

        Map<String, dynamic>? scanResult;
        int retries = 0;
        const maxRetries = 5;
        const retryDelay = Duration(seconds: 3);

        while (retries < maxRetries) {
          await Future.delayed(retryDelay);

          final analysisResponse = await http.get(
            Uri.parse('https://www.virustotal.com/api/v3/analyses/$scanId'),
            headers: {'x-apikey': _apiKey, 'Accept': 'application/json'},
          );

          if (analysisResponse.statusCode == 200) {
            final analysisData = jsonDecode(analysisResponse.body);
            final attributes = analysisData['data']?['attributes'];

            if (attributes == null) {
              throw Exception('بيانات الفحص غير صالحة');
            }

            final stats = attributes['stats'];
            if (stats == null) {
              throw Exception('تعذر تحليل نتائج الفحص');
            }

            final total =
                (stats['malicious'] ?? 0) +
                (stats['suspicious'] ?? 0) +
                (stats['harmless'] ?? 0) +
                (stats['undetected'] ?? 0);

            if (attributes['status'] == 'queued' ||
                attributes['status'] == 'in-progress') {
              retries++;
              if (retries < maxRetries) continue;
              throw Exception('استغرقت عملية الفحص وقتاً أطول من المتوقع');
            }

            scanResult = {
              'url': processedUrl,
              'status': stats['malicious'] > 0
                  ? 'خطر'
                  : stats['suspicious'] > 0
                  ? 'مشبوه'
                  : 'آمن',
              'scanTime': scanTime,
              'stats': stats,
              'totalEngines': total,
            };
            break;
          } else {
            throw Exception(
              'خطأ في استرجاع نتائج الفحص: ${analysisResponse.statusCode}',
            );
          }
        }

        if (scanResult == null) {
          throw Exception('فشل في الحصول على نتائج الفحص بعد عدة محاولات');
        }

        final status = scanResult['status']?.toString() ?? 'غير معروف';

        setState(() {
          _lastScanResult = scanResult;
          _result = 'حالة الرابط: $status\n';

          final stats = scanResult!['stats'] is Map<String, dynamic>
              ? Map<String, dynamic>.from(scanResult!['stats'] as Map)
              : <String, dynamic>{};

          final malicious = (stats['malicious'] as int?) ?? 0;
          final suspicious = (stats['suspicious'] as int?) ?? 0;
          final harmless = (stats['harmless'] as int?) ?? 0;

          _result += 'النتائج: $malicious ⚠️ | ';
          _result += '$suspicious ⚠️ | ';
          _result += '$harmless ✅';

          switch (status) {
            case 'آمن':
              _icon = Icons.verified_rounded;
              _iconColor = Colors.green;
              break;
            case 'مشبوه':
              _icon = Icons.warning_amber_rounded;
              _iconColor = Colors.orange;
              break;
            default:
              _icon = Icons.dangerous_rounded;
              _iconColor = Colors.red;
          }

          _addToHistory(scanResult!);
        });
      } else {
        final errorResponse = jsonDecode(response.body);
        final errorMessage =
            errorResponse['error']?['message'] ?? 'خطأ غير معروف';
        throw Exception('فشل في فحص الرابط: $errorMessage');
      }
    } catch (e) {
      debugPrint('Error scanning link: $e');
      setState(() {
        _result = '❌ ${e.toString().replaceAll('Exception: ', '')}';
        _icon = Icons.error_outline;
        _iconColor = Colors.red;
        _addToHistory({
          'url': processedUrl,
          'status': 'خطأ',
          'scanTime': scanTime,
          'error': e.toString(),
          'stats': {
            'malicious': 0,
            'suspicious': 0,
            'harmless': 0,
            'undetected': 0,
          },
          'totalEngines': 0,
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _addToHistory(Map<String, dynamic> scanResult) {
    setState(() {
      _history.insert(0, scanResult);
      if (_history.length > 20) {
        _history = _history.sublist(0, 20);
      }
      _filteredHistory = _history;
      _saveHistory();
    });
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح السجل'),
        content: const Text('هل أنت متأكد من رغبتك في مسح سجل الفحوصات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _history.clear();
                _filteredHistory.clear();
                _saveHistory();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم مسح السجل بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareResult() async {
    if (!mounted) return;

    if (_lastScanResult == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد نتيجة متاحة للمشاركة'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await Share.share(
        '🔍 نتيجة فحص الرابط:\n\n'
        'الرابط: ${_lastScanResult!['url']}\n'
        'الحالة: ${_lastScanResult!['status']}\n'
        'وقت الفحص: ${_formatDate(DateTime.parse(_lastScanResult!['scanTime']))}\n\n'
        'تم الفحص باستخدام تطبيق فحص الروابط',
        subject: 'نتيجة فحص الرابط',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تمت المشاركة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on PlatformException catch (e) {
      debugPrint('Error sharing result: ${e.message}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء المشاركة: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('Unexpected error sharing result: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ غير متوقع أثناء المشاركة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await FlutterClipboard.copy(text);
      if (!mounted) return;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم نسخ النص بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error copying to clipboard: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء نسخ النص'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildProgressIndicator() {
    if (!_loading) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 16),
        LinearProgressIndicator(
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 8),
        Text(
          'جاري تحليل الرابط مع ${_lastScanResult?['totalEngines'] ?? 70} محرك فحص...',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScanResult() {
    if (_lastScanResult == null) return const SizedBox.shrink();

    final stats = _lastScanResult!['stats'] ?? {};
    final total = _lastScanResult!['totalEngines'] ?? 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getStatusColor().withOpacity(0.05),
                  _getStatusColor().withOpacity(0.02),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '📊 تفاصيل الفحص',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share_rounded),
                            onPressed: _shareResult,
                            tooltip: 'مشاركة النتيجة',
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded),
                            onPressed: () =>
                                _copyToClipboard(_lastScanResult!['url']),
                            tooltip: 'نسخ الرابط',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('الرابط', _lastScanResult!['url'], true),
                  const Divider(),
                  _buildStatRow(
                    'الحالة',
                    _lastScanResult!['status'],
                    false,
                    color: _getStatusColor(),
                  ),
                  const Divider(),
                  _buildStatRow(
                    'وقت الفحص',
                    _formatDate(DateTime.parse(_lastScanResult!['scanTime'])),
                    false,
                  ),
                  const SizedBox(height: 20),
                  _buildScanProgress(
                    stats['malicious'] ?? 0,
                    stats['suspicious'] ?? 0,
                    stats['harmless'] ?? 0,
                    stats['undetected'] ?? 0,
                    total,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_lastScanResult?['status']) {
      case 'آمن':
        return Colors.green;
      case 'مشبوه':
        return Colors.orange;
      case 'خطر':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatRow(String label, String value, bool isUrl, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: isUrl
                ? InkWell(
                    onTap: () => _copyToClipboard(value),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue.withOpacity(0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.copy_rounded,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanProgress(
    int malicious,
    int suspicious,
    int harmless,
    int undetected,
    int total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نتائج محركات الفحص ($total محرك)',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        _buildProgressBar(malicious, suspicious, harmless, undetected, total),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildLegendItem('🛡️ آمن', harmless, Colors.green),
            _buildLegendItem('⚠️ مشبوه', suspicious, Colors.orange),
            _buildLegendItem('🔴 ضار', malicious, Colors.red),
            _buildLegendItem('❔ غير محدد', undetected, Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    int malicious,
    int suspicious,
    int harmless,
    int undetected,
    int total,
  ) {
    if (total == 0) {
      return Container(
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey[200],
        ),
        child: const Center(
          child: Text('لا توجد نتائج', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Container(
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          if (harmless > 0)
            Expanded(
              flex: (harmless * 100 ~/ total),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    harmless.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          if (suspicious > 0)
            Expanded(
              flex: (suspicious * 100 ~/ total),
              child: Container(
                color: Colors.orange,
                child: Center(
                  child: Text(
                    suspicious.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          if (malicious > 0)
            Expanded(
              flex: (malicious * 100 ~/ total),
              child: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    malicious.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          if (undetected > 0)
            Expanded(
              flex: (undetected * 100 ~/ total),
              child: Container(
                color: Colors.grey[400],
                child: Center(
                  child: Text(
                    undetected.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label: $count', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildHistoryFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: const Text('الكل'),
            selected: _currentFilter == 'all',
            onSelected: (_) => _filterHistory('all'),
          ),
          FilterChip(
            label: const Text('آمن'),
            selected: _currentFilter == 'safe',
            selectedColor: Colors.green.withOpacity(0.2),
            onSelected: (_) => _filterHistory('safe'),
          ),
          FilterChip(
            label: const Text('مشبوه'),
            selected: _currentFilter == 'suspicious',
            selectedColor: Colors.orange.withOpacity(0.2),
            onSelected: (_) => _filterHistory('suspicious'),
          ),
          FilterChip(
            label: const Text('خطر'),
            selected: _currentFilter == 'dangerous',
            selectedColor: Colors.red.withOpacity(0.2),
            onSelected: (_) => _filterHistory('dangerous'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final safeCount = _history.where((item) => item['status'] == 'آمن').length;
    final suspiciousCount = _history
        .where((item) => item['status'] == 'مشبوه')
        .length;
    final dangerousCount = _history
        .where((item) => item['status'] == 'خطر')
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'إجمالي الفحوصات',
              _history.length,
              Icons.assessment,
            ),
            _buildStatItem('آمنة', safeCount, Icons.check_circle, Colors.green),
            _buildStatItem(
              'مشبوهة',
              suspiciousCount,
              Icons.warning,
              Colors.orange,
            ),
            _buildStatItem('خطرة', dangerousCount, Icons.dangerous, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    int count,
    IconData icon, [
    Color? color,
  ]) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? Colors.blue, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      color ??
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 فحص الروابط'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.onThemeChanged(!widget.isDark),
            tooltip: 'تغيير السمة',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scanner Card
              ScaleTransition(
                scale: _scaleAnimation,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.2),
                                    Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                      strokeWidth: 4,
                                    )
                                  : Icon(_icon, color: _iconColor, size: 80),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _controller,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'https://example.com',
                            labelText: 'أدخل الرابط للفحص',
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.link_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant.withOpacity(0.5),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            suffixIcon: _controller.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded),
                                    onPressed: () {
                                      _controller.clear();
                                      setState(() {
                                        _result = "";
                                        _lastScanResult = null;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.search,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رابط للفحص';
                            }
                            String url = value;
                            if (!url.startsWith('http://') &&
                                !url.startsWith('https://')) {
                              url = 'https://$url';
                            }
                            if (!_validateUrl(url)) {
                              return 'الرجاء إدخال رابط صحيح';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submitForm(),
                        ),
                        const SizedBox(height: 20),
                        _buildProgressIndicator(),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            icon: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.search_rounded, size: 24),
                            label: Text(
                              _loading ? 'جاري الفحص...' : 'بدء الفحص',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _loading ? null : _submitForm,
                          ),
                        ),
                        if (_result.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _lastScanResult?['status'] == 'آمن'
                                    ? Colors.green.withOpacity(0.1)
                                    : _lastScanResult?['status'] == 'مشبوه'
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _lastScanResult?['status'] == 'آمن'
                                      ? Colors.green.withOpacity(0.3)
                                      : _lastScanResult?['status'] == 'مشبوه'
                                      ? Colors.orange.withOpacity(0.3)
                                      : Colors.red.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(_icon, color: _iconColor, size: 32),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      _result,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _iconColor,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              if (_lastScanResult != null) ...[
                const SizedBox(height: 20),
                _buildScanResult(),
              ],

              const SizedBox(height: 24),

              // Statistics
              if (_history.isNotEmpty) ...[
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildStatistics(),
                ),
                const SizedBox(height: 16),
              ],

              // History Section
              ScaleTransition(
                scale: _scaleAnimation,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '📜 سجل الفحوصات',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (_history.isNotEmpty)
                              IconButton(
                                onPressed: _clearHistory,
                                icon: const Icon(
                                  Icons.delete_sweep_rounded,
                                  color: Colors.red,
                                ),
                                tooltip: 'مسح السجل',
                              ),
                          ],
                        ),
                      ),
                      if (_history.isNotEmpty) _buildHistoryFilters(),
                      if (_filteredHistory.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32, top: 16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history_toggle_off_rounded,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد سجلات سابقة',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: Text(
                                  'سيظهر سجل الفحوصات هنا بعد إجراء أول فحص',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                _filteredHistory.length +
                                (_isLoadingMore ? 1 : 0),
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              if (index == _filteredHistory.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final item = _filteredHistory[index];
                              final isSafe = item['status'] == 'آمن';
                              final isSuspicious = item['status'] == 'مشبوه';

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                leading: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isSafe
                                        ? Colors.green.withOpacity(0.1)
                                        : isSuspicious
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSafe
                                        ? Icons.check_circle_rounded
                                        : isSuspicious
                                        ? Icons.warning_amber_rounded
                                        : Icons.dangerous_rounded,
                                    color: isSafe
                                        ? Colors.green
                                        : isSuspicious
                                        ? Colors.orange
                                        : Colors.red,
                                  ),
                                ),
                                title: Text(
                                  item['url'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(
                                  _formatDate(DateTime.parse(item['scanTime'])),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSafe
                                        ? Colors.green.withOpacity(0.1)
                                        : isSuspicious
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['status'],
                                    style: TextStyle(
                                      color: isSafe
                                          ? Colors.green
                                          : isSuspicious
                                          ? Colors.orange
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  _controller.text = item['url'];
                                  _submitForm();
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              ScaleTransition(
                scale: _scaleAnimation,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡ إجراءات سريعة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(
                              icon: Icons.info_outline_rounded,
                              label: 'عن التطبيق',
                              onTap: () {
                                showAboutDialog(
                                  context: context,
                                  applicationName: 'فحص الروابط',
                                  applicationVersion: '1.0.0',
                                  applicationIcon: const Icon(
                                    Icons.security_rounded,
                                    size: 48,
                                  ),
                                  children: [
                                    const SizedBox(height: 16),
                                    const Text(
                                      'تطبيق لفحص الروابط المشبوهة والضارة قبل فتحها. يستخدم خدمة VirusTotal للتحقق من أمان الروابط باستخدام أكثر من 70 محرك فحص.',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: () {
                                        launchUrl(
                                          Uri.parse(
                                            'https://www.virustotal.com',
                                          ),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                      child: const Text(
                                        'زيارة موقع VirusTotal',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.share_rounded,
                              label: 'مشاركة',
                              onTap: () {
                                Share.share(
                                  '🔍 جرب تطبيق فحص الروابط للتحقق من أمان الروابط قبل فتحها!\n\n'
                                  'مميزات التطبيق:\n'
                                  '• فحص الروابط باستخدام VirusTotal\n'
                                  '• واجهة مستخدم سهلة ومريحة\n'
                                  '• سجل للفحوصات السابقة\n'
                                  '• دعم الوضع الليلي\n\n'
                                  'حمله الآن!',
                                  subject: 'تطبيق فحص الروابط',
                                );
                              },
                            ),
                            _buildActionButton(
                              icon: Icons.star_rounded,
                              label: 'تقييم',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'شكراً لك على تقييمك! 🌟',
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Developer credit
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'تطوير المبرمج منصور باسلمه',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withOpacity(0.6),
                    fontSize: 16,
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
