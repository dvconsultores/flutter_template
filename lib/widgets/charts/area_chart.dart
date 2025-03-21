import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomAreaChart extends StatelessWidget {
  const CustomAreaChart({
    super.key,
    required this.width,
    required this.height,
    required this.series,
    this.loading = false,
    this.interactive = true,
    this.onAnimationComplete,
  });

  final double width;
  final double height;
  final List<CartesianSeries<ChartData, String>> series;
  final bool loading;
  final bool interactive;
  final void Function()? onAnimationComplete;

  @override
  Widget build(BuildContext context) {
    final themeApp = ThemeApp.of(context);

    if (loading) {
      return SizedBox(
        width: width,
        height: height,
        child: LinearProgressIndicator(
          color: themeApp.colors.primary,
          backgroundColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(Vars.radius10)),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        enableAxisAnimation: true,
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(
            format: "point.x: point.y",
          ),
          markerSettings: TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.visible,
            shape: DataMarkerType.circle,
            width: 20,
            height: 20,
            color: themeApp.colors.primary,
            borderColor: themeApp.colors.primary,
          ),
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enableSelectionZooming: true,
          enablePinching: true,
          enableDoubleTapZooming: true,
          enableMouseWheelZooming: true,
        ),
        series: series,
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
