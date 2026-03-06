import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class UiCard extends StatelessWidget {
  const UiCard({
    super.key,
    this.margin,
    this.padding,
    this.borderRadius,
    this.onPressed,
    this.prefixIcon,
    this.child,
    this.suffixIcon,
    this.title,
    this.titleWidget,
    this.text,
    this.textColor,
    this.image,
    this.boxShadow,
    this.useShadow = false,
    this.suffixPadding,
    this.border,
    this.color,
  });

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final BorderRadius? borderRadius;

  final VoidCallback? onPressed;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? suffixPadding;
  final Widget? child;
  final Widget? image;

  final String? title;
  final Widget? titleWidget;
  final String? text;

  final Color? textColor;

  final Color? color;

  final bool useShadow;

  final List<BoxShadow>? boxShadow;

  final BoxBorder? border;

  EdgeInsetsGeometry get _margin =>
      margin ?? const EdgeInsets.only(bottom: Insets.l);

  EdgeInsetsGeometry get _padding => padding ?? const EdgeInsets.all(Insets.l);

  BorderRadius get _borderRadius =>
      borderRadius ?? BorderRadius.circular(Insets.s);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? context.colors.white100,
        border: border,
        boxShadow:
            useShadow
                ? boxShadow ??
                    <BoxShadow>[
                      BoxShadow(
                        color:
                            Theme.of(context).cardTheme.shadowColor ??
                            const Color.fromRGBO(115, 145, 166, 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                : <BoxShadow>[],
        borderRadius: _borderRadius,
      ),
      margin: _margin,
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        color: color ?? context.colors.white100,
        child: InkWell(
          splashColor: Theme.of(
            context,
          ).cardTheme.shadowColor?.withOpacity(0.1),
          highlightColor: Theme.of(
            context,
          ).cardTheme.shadowColor?.withOpacity(0.1),
          borderRadius: _borderRadius,
          onTap: onPressed,
          child: Padding(
            padding: _padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Insets.l),
                    child: image,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (prefixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: prefixIcon ?? Container(),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (title != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: Insets.l / 2,
                              ),
                              child: Text(title!, style: context.texts.title),
                            ),
                          if (titleWidget != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: Insets.l / 2,
                              ),
                              child: titleWidget,
                            ),
                          if (text != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                text!,
                                style: context.texts.body.copyWith(
                                  color: textColor,
                                ),
                              ),
                            ),
                          if (child != null) child!,
                        ],
                      ),
                    ),
                    if (suffixIcon != null)
                      Padding(
                        padding:
                            suffixPadding ??
                            const EdgeInsets.only(left: Insets.l),
                        child: suffixIcon ?? Container(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
