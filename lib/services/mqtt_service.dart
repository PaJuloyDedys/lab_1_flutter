import 'dart:async';
import 'dart:math';

class MqttService {
  MqttService._();
  static final MqttService I = MqttService._();

  // --- Streams ---
  final _statusCtrl = StreamController<String>.broadcast();
  final _messageCtrl = StreamController<String>.broadcast();
  final _temperatureCtrl = StreamController<double?>.broadcast();

  Stream<String> get statusStream => _statusCtrl.stream;
  Stream<String> get messageStream => _messageCtrl.stream;
  Stream<double?> get temperatureStream => _temperatureCtrl.stream;

  // --- Internal state ---
  bool _connected = false;
  Timer? _mockTimer;
  final _rnd = Random();

  bool get isConnected => _connected;

  Future<void> connect({
    String host = 'test.mosquitto.org',
    int port = 8081,
    String clientId = 'mock_client',
    String? username,
    String? password,
    bool logging = false,
  }) async {
    if (_connected) {
      _statusCtrl.add('Already connected');
      return;
    }

    _statusCtrl.add('Connecting to $host:$port ...');
    await Future.delayed(const Duration(seconds: 3));

    _connected = true;
    _statusCtrl.add('Connected');
  }

  void disconnect() {
    if (!_connected) {
      _statusCtrl.add('Already disconnected');
      return;
    }
    _mockTimer?.cancel();
    _mockTimer = null;
    _connected = false;
    _statusCtrl.add('Disconnected');
  }

  void subscribe(String topic) {
    if (!_connected) {
      _statusCtrl.add('Not connected: can\'t subscribe');
      return;
    }

    _statusCtrl.add('Subscribed: $topic');

    _mockTimer?.cancel();

    double _currentTemp = 8.0;

    _mockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final delta = (_rnd.nextDouble() * 0.4) - 0.2;
      _currentTemp += delta;

      if (_currentTemp < 4.0) _currentTemp = 4.0;
      if (_currentTemp > 12.0) _currentTemp = 12.0;

      final pretty = (_currentTemp * 10).round() / 10;

      _temperatureCtrl.add(pretty);
      _messageCtrl.add('[$topic] temperature=$pretty°C');
    });

  }

  Future<void> publishString(String topic, String payload) async {
    if (!_connected) {
      _statusCtrl.add('Not connected: can\'t publish');
      return;
    }
    _statusCtrl.add('Published to $topic: $payload');
  }

  void dispose() {
    _mockTimer?.cancel();
    _statusCtrl.close();
    _messageCtrl.close();
    _temperatureCtrl.close();
  }
}
