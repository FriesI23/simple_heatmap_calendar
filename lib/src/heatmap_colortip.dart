import 'package:flutter/material.dart';

import 'const.dart';
import 'heatmap_cell.dart';

class HeatmapColorTip<T extends Comparable<T>> extends StatelessWidget {
  final double cellSpaceBetween;
  final Size cellSize;
  final BorderRadius? cellRadius;
  final Widget? leftTip;
  final Widget? rigthtTip;
  final List<Color>? colors;

  const HeatmapColorTip({
    super.key,
    this.cellSpaceBetween = defualtCellSpaceBetween,
    this.cellSize = defaultCellSize,
    this.cellRadius,
    this.leftTip,
    this.rigthtTip,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (leftTip != null) children.add(leftTip!);
    if (colors != null) {
      for (var c in colors!) {
        children.add(HeatmapCell(size: cellSize, color: c, radius: cellRadius));
      }
    }
    if (rigthtTip != null) children.add(rigthtTip!);
    return Wrap(
      direction: Axis.horizontal,
      spacing: cellSpaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
