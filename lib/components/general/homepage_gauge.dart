import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomepageGauge extends StatelessWidget {
  final int percent;
  HomepageGauge(this.percent);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 156.0,
        width: 156.0,
        child: Center(
            child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showAxisLine: false,
                showTicks: false,
                minimum: 0,
                maximum: 99,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 33,
                      color: Color(0xFFFAA0A0),
                      label: '위험',
                      sizeUnit: GaugeSizeUnit.factor,
                      labelStyle:
                          GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                      startWidth: 0.65,
                      endWidth: 0.65),
                  GaugeRange(
                    startValue: 33,
                    endValue: 66,
                    color: Color(0xFFFFE9A0),
                    label: '양호',
                    labelStyle:
                        GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                    startWidth: 0.65,
                    endWidth: 0.65,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 66,
                    endValue: 99,
                    color: Color(0xFFC7F2A4),
                    label: '안전',
                    labelStyle:
                        GaugeTextStyle(fontFamily: 'Times', fontSize: 20),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.65,
                    endWidth: 0.65,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(value: percent.toDouble())
                ])
          ],
        )));
  }
}
