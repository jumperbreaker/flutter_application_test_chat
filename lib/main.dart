import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/chat_list_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NetworkStatus(
        child: ChatListScreen(),
      ),
    );
  }
}

class NetworkStatus extends StatefulWidget {
  final Widget child;

  NetworkStatus({required this.child});

  @override
  _NetworkStatusState createState() => _NetworkStatusState();
}

class _NetworkStatusState extends State<NetworkStatus> {
  ConnectivityResult? _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        setState(() {
          _isConnected = false;
        });
        _showNoInternetDialog(context);
      } else {
        setState(() {
          _isConnected = true;
        });
      }
    } catch (e) {
      print('Couldn\'t check connectivity status: $e');
    }
  }

  Future<void> _showNoInternetDialog(BuildContext context) async {
    final duration = Duration(seconds: 5);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Нет подключения к сети Интернет'),
        content: Text('Пожалуйста, проверьте подключение к сети Интернет и запустите приложение снова.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    setState(() {
      _isConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected
        ? widget.child
        : const SizedBox.shrink(); 
  }
}
