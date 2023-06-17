import 'package:flutter/scheduler.dart';

class CustomTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
