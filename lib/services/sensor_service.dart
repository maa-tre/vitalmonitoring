import 'dart:async';
import 'dart:math';
import '../models/patient.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  final _ecgController = StreamController<List<ECGDataPoint>>.broadcast();
  final _vitalsController = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<List<ECGDataPoint>> get ecgStream => _ecgController.stream;
  Stream<Map<String, dynamic>> get vitalsStream => _vitalsController.stream;

  Timer? _ecgTimer;
  Timer? _vitalsTimer;
  double _phase = 0.0;
  final List<ECGDataPoint> _buffer = [];
  final int _maxPoints = 500;

  void startSimulation() {
    _ecgTimer?.cancel();
    _vitalsTimer?.cancel();
    
    // High-frequency ECG Simulation (250Hz)
    _ecgTimer = Timer.periodic(const Duration(milliseconds: 4), (timer) {
      final point = _generateNextPoint();
      _buffer.add(point);
      if (_buffer.length > _maxPoints) {
        _buffer.removeAt(0);
      }

      // Batch updates every 40ms
      if (timer.tick % 10 == 0) {
        _ecgController.add(List.from(_buffer));
      }
    });

    // Low-frequency Vitals Simulation (Every 2 seconds)
    _vitalsTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final random = Random();
      _vitalsController.add({
        'bodyTemp': 98.0 + (random.nextDouble() * 2.0),
        'roomTemp': 70.0 + (random.nextDouble() * 3.0),
        'aqi': 35 + random.nextInt(30),
        'heartRate': 65 + random.nextInt(20),
      });
    });
  }

  void stopSimulation() {
    _ecgTimer?.cancel();
    _vitalsTimer?.cancel();
  }

  ECGDataPoint _generateNextPoint() {
    _phase += 0.02; // Adjust for heart rate (Higher = Faster)
    if (_phase > 2 * pi) _phase -= 2 * pi;

    double value = 0.0;
    
    // P-wave (Atrial Depolarization)
    if (_phase > 0 && _phase < 0.5) {
      value = 5 * sin(_phase * (pi / 0.5));
    }
    // QRS Complex (Ventricular Depolarization)
    else if (_phase > 0.6 && _phase < 0.7) {
      value = -10 * sin((_phase - 0.6) * (pi / 0.1));
    } else if (_phase >= 0.7 && _phase < 0.9) {
      value = 40 * sin((_phase - 0.7) * (pi / 0.2));
    } else if (_phase >= 0.9 && _phase < 1.0) {
      value = -15 * sin((_phase - 0.9) * (pi / 0.1));
    }
    // T-wave (Ventricular Repolarization)
    else if (_phase > 1.5 && _phase < 2.0) {
      value = 10 * sin((_phase - 1.5) * (pi / 0.5));
    }
    
    // Add some noise for realism
    value += (Random().nextDouble() - 0.5) * 2;
    
    // Normalize to a baseline of 50
    return ECGDataPoint(
      time: DateTime.now(),
      value: 50 + value,
    );
  }

  void dispose() {
    _ecgTimer?.cancel();
    _vitalsTimer?.cancel();
    _ecgController.close();
    _vitalsController.close();
  }
}
