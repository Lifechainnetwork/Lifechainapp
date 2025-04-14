import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/theme_provider.dart';
import 'services/wallet_connect_service.dart';
import 'services/notification_service.dart';
import 'services/error_handling_service.dart';
import 'services/memory_management_service.dart';
import 'services/offline_data_service.dart';
import 'services/sync_manager.dart';
import 'providers/language_provider.dart';
import 'providers/currency_provider.dart';
import 'providers/connectivity_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_config.dart';
import 'utils/lifecycle_event_handler.dart';
import 'widgets/offline_mode_banner.dart';

// Global key for navigator state
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for better UI appearance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize error handling service
  final errorHandlingService = ErrorHandlingService();
  errorHandlingService.setupGlobalErrorHandling();

  // Initialize memory management service with advanced optimization
  final memoryManagementService = MemoryManagementService();
  await memoryManagementService.initialize();

  // Pre-load app configuration
  await AppConfig.initialize();

  // Load shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Check for and cleanup stale data
  await memoryManagementService.removeStaleData();

  // Start optimizing for battery life
  unawaited(memoryManagementService.requestBatteryOptimization());

  runApp(
    MultiProvider(
      providers: [
        // Services
        ChangeNotifierProvider(create: (_) => WalletConnectService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider.value(value: errorHandlingService),
        Provider.value(value: memoryManagementService),

        // Add offline support services
        ChangeNotifierProvider(create: (_) => OfflineDataService()),
        ChangeNotifierProvider(create: (_) => SyncManager()),

        // Data providers
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),

        // Provide shared preferences
        Provider.value(value: sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final MemoryManagementService _memoryService;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _lowMemoryWarningShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Get memory service
    _memoryService = Provider.of<MemoryManagementService>(
      context,
      listen: false,
    );

    // Setup connectivity monitoring
    _setupConnectivityMonitoring();

    // Set up lifecycle event handling for better memory management
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          // App resumed from background, clear caches if needed
          if (_memoryService.isLowPowerMode) {
            _memoryService.trimImageCache();
          }
          return;
        },
        suspendingCallBack: () async {
          // App going to background, cleanup resources
          _memoryService.trimImageCache();
          return;
        },
      ),
    );
  }

  void _setupConnectivityMonitoring() {
    // Monitor network connectivity changes
    final connectivityProvider = Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    );

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      connectivityProvider.updateConnectivityStatus(result);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle state changes
    switch (state) {
      case AppLifecycleState.paused:
        // App is in background
        _memoryService.trimImageCache();
        break;
      case AppLifecycleState.resumed:
        // App is in foreground
        if (_memoryService.isLowPowerMode) {
          _memoryService.trimImageCache();
        }
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        break;
      case AppLifecycleState.detached:
        // App is detached
        _memoryService.clearImageCache();
        break;
      default:
        // Handle newer Flutter versions that have AppLifecycleState.hidden
        final stateString = state.toString();
        if (stateString == 'AppLifecycleState.hidden') {
          _memoryService.clearImageCache();
        }
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final errorHandlingService = Provider.of<ErrorHandlingService>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    return MaterialApp(
      title: 'Lifechain Wallet',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: themeProvider.currentTheme,
      darkTheme: themeProvider.currentTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: languageProvider.currentLocale,
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('hi', 'IN'), // Hindi
        Locale('es', 'ES'), // Spanish
        Locale('zh', 'CN'), // Chinese
        Locale('ru', 'RU'), // Russian
      ],
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        // Add app-specific localization delegate here
      ],
      home: const SplashScreen(),
      builder: (context, child) {
        // Apply text scaling
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              1.0,
            ), // Prevent system text scaling to maintain design
          ),
          child: _buildWithErrorHandling(
            context,
            child,
            errorHandlingService,
            connectivityProvider,
          ),
        );
      },
    );
  }

  Widget _buildWithErrorHandling(
    BuildContext context,
    Widget? child,
    ErrorHandlingService errorHandlingService,
    ConnectivityProvider connectivityProvider,
  ) {
    // Global error handling widget wrapper
    Widget finalWidget = child!;

    // Check for memory pressure and show warning if needed
    if (_memoryService.currentMemoryPressure == MemoryPressure.critical &&
        !_lowMemoryWarningShown) {
      // Show low memory warning
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLowMemoryWarning(context);
      });
      _lowMemoryWarningShown = true;
    }

    // Show error overlay when there's an error
    if (errorHandlingService.currentError != null) {
      finalWidget = Stack(
        children: [
          child,
          // Error overlay
          Material(
            color: Colors.black54,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorHandlingService.currentError!.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => errorHandlingService.clearCurrentError(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Show connectivity status banner when offline
    if (connectivityProvider.connectivityResult == ConnectivityResult.none) {
      finalWidget = Stack(
        children: [
          finalWidget,
          Positioned(top: 0, left: 0, right: 0, child: OfflineModeBanner()),
        ],
      );
    }

    return finalWidget;
  }

  void _showLowMemoryWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Device is low on memory. Please close other apps for better performance.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
