import 'dart:async';
import 'dart:math';
import '../models/patient.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  final _ecgController = StreamController<List<ECGDataPoint>>.broadcast();
  Stream<List<ECGDataPoint>> get ecgStream => _ecgController.stream;

  Timer? _timer;
  double _phase = 0.0;
  final List<ECGDataPoint> _buffer = [];
  final int _maxPoints = 500;

  void startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 4), (timer) {
      final point = _generateNextPoint();
      _buffer.add(point);
      if (_buffer.length > _maxPoints) {
        _buffer.removeAt(0);
      }

      // Batch updates to the UI every 10 samples (40ms) to avoid over-rendering
      if (timer.tick % 10 == 0) {
        _ecgController.add(List.from(_buffer));
      }
    });
  }

  void stopSimulation() {
    _timer?.cancel();
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
    _timer?.cancel();
    _ecgController.close();
  }
}
