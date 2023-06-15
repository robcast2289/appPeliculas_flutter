import 'dart:async';

class Debouncer<T> {
  final Duration duration;

  Debouncer({
    required this.duration,
    this.onValue
  });

  void Function(T value)? onValue;

  T? _value;
  Timer? _timer;

  T get value => _value!;

  set value(T val){
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));
  }
}