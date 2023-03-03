import 'package:flutter/widgets.dart';

class HeatmapCell<T> extends StatelessWidget {
  final Size? size;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? radius;
  final T? value;
  final double? valueSize;
  final Color? valueColor;
  final Alignment? valueAlignment;
  final Widget? Function(BuildContext context, T? value)? valueBuilder;

  const HeatmapCell({
    super.key,
    this.size,
    this.color,
    this.padding,
    this.radius,
    this.value,
    this.valueSize,
    this.valueColor,
    this.valueAlignment,
    this.valueBuilder,
  });

  Widget? _getValue(BuildContext context) {
    if (value == null) return valueBuilder?.call(context, value);
    var child = valueBuilder == null
        ? Text(value.toString())
        : valueBuilder!(context, value);
    if (child == null) return null;
    return DefaultTextStyle(
      style: TextStyle(fontSize: valueSize, color: valueColor),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: valueAlignment ?? Alignment.center,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.zero,
        color: color,
      ),
      height: size?.height,
      width: size?.width,
      child: _getValue(context),
    );
  }
}
