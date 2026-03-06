import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ui_kit/ui_kit.dart';

class UiIcon extends StatelessWidget {
  const UiIcon(
    this.icon, {
    super.key,
    this.color,
    this.useColor = true,
    this.width,
    this.height,
    this.padding,
  }) : _onPressed = null;

  const UiIcon.button(
    this.icon, {
    required VoidCallback? onPressed,
    super.key,
    this.color,
    this.useColor = true,
    this.width,
    this.height,
    this.padding,
  }) : _onPressed = onPressed;

  final String icon;
  final Color? color;
  final bool useColor;
  final VoidCallback? _onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (_onPressed != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(Insets.xxxl),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onPressed,
            child: Container(
              padding: padding ?? const EdgeInsets.all(Insets.l),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child:
                  !icon.contains('.svg')
                      ? Image.asset(
                        icon,
                        package: 'ui_kit',
                        width: width,
                        height: height,
                      )
                      : SvgPicture.asset(
                        icon,
                        package: 'ui_kit',
                        width: width,
                        height: height,
                        color:
                            useColor
                                ? color ?? Theme.of(context).iconTheme.color
                                : null,
                      ),
            ),
          ),
        ),
      );
    }

    return !icon.contains('.svg')
        ? Image.asset(icon, package: 'ui_kit', width: width, height: height)
        : SvgPicture.asset(
          icon,
          width: width,
          height: height,
          package: 'ui_kit',
          color: useColor ? color ?? Theme.of(context).iconTheme.color : null,
        );
  }
}
