import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Flippertext extends StatelessWidget {
  final String text;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final Color? color;
  final TextDecoration? decoration;
  final bool selectable;
  final String? fontFamily;
  final List<String>? fallbackFontFamily;
  final bool withTooltip;
  final StrutStyle? strutStyle;
  final bool isEmoji;
  final double? lineHeight;
  final double? figmaLineHeight;
  final bool optimizeEmojiAlign;

  const Flippertext(
    this.text, {
    super.key,
    this.overflow = TextOverflow.clip,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.color,
    this.maxLines = 1,
    this.decoration,
    this.selectable = false,
    this.fontFamily,
    this.fallbackFontFamily,
    this.lineHeight,
    this.figmaLineHeight,
    this.withTooltip = false,
    this.isEmoji = false,
    this.strutStyle,
    this.optimizeEmojiAlign = false,
  });

  Flippertext.small(
    this.text, {
    super.key,
    this.overflow,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.decoration,
    this.selectable = false,
    this.fontFamily,
    this.fallbackFontFamily,
    this.lineHeight,
    this.withTooltip = false,
    this.isEmoji = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.optimizeEmojiAlign = false,
  })  : fontWeight = FontWeight.w400,
        fontSize = (Platform.isIOS || Platform.isAndroid) ? 14 : 12;

  const Flippertext.regular(
    this.text, {
    super.key,
    this.fontSize,
    this.overflow,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.decoration,
    this.selectable = false,
    this.fontFamily,
    this.fallbackFontFamily,
    this.lineHeight,
    this.withTooltip = false,
    this.isEmoji = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.optimizeEmojiAlign = false,
  }) : fontWeight = FontWeight.w400;

  const Flippertext.medium(
    this.text, {
    super.key,
    this.fontSize,
    this.overflow,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.decoration,
    this.selectable = false,
    this.fontFamily,
    this.fallbackFontFamily,
    this.lineHeight,
    this.withTooltip = false,
    this.isEmoji = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.optimizeEmojiAlign = false,
  }) : fontWeight = FontWeight.w500;

  const Flippertext.semibold(
    this.text, {
    super.key,
    this.fontSize,
    this.overflow,
    this.color,
    this.textAlign,
    this.maxLines = 1,
    this.decoration,
    this.selectable = false,
    this.fontFamily,
    this.fallbackFontFamily,
    this.lineHeight,
    this.withTooltip = false,
    this.isEmoji = false,
    this.strutStyle,
    this.figmaLineHeight,
    this.optimizeEmojiAlign = false,
  }) : fontWeight = FontWeight.w600;

  const Flippertext.emoji(
    this.text, {
    super.key,
    this.fontSize,
    this.overflow,
    this.color,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
    this.decoration,
    this.selectable = false,
    this.lineHeight,
    this.withTooltip = false,
    this.strutStyle = const StrutStyle(forceStrutHeight: true),
    this.isEmoji = true,
    this.fontFamily,
    this.figmaLineHeight,
    this.optimizeEmojiAlign = false,
  })  : fontWeight = FontWeight.w400,
        fallbackFontFamily = null;

  @override
  Widget build(BuildContext context) {
    Widget child;

    var fontFamily = this.fontFamily;
    var fallbackFontFamily = this.fallbackFontFamily;
    var resolvedFontSize =
        fontSize ?? Theme.of(context).textTheme.bodyMedium!.fontSize!;

    if (isEmoji && _useNotoColorEmoji) {
      fontFamily = _loadEmojiFontFamilyIfNeeded();
      if (fontFamily != null && fallbackFontFamily == null) {
        fallbackFontFamily = [fontFamily];
      }
    }

    double? resolvedLineHeight;
    if (figmaLineHeight != null) {
      resolvedLineHeight = figmaLineHeight! / resolvedFontSize;
    } else if (lineHeight != null) {
      resolvedLineHeight = lineHeight;
    }

    if (isEmoji && (_useNotoColorEmoji || Platform.isWindows)) {
      const scaleFactor = 0.9;
      resolvedFontSize *= scaleFactor;
      if (resolvedLineHeight != null) {
        resolvedLineHeight /= scaleFactor;
      }
    }

    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: resolvedFontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
          fontFamily: fontFamily,
          fontFamilyFallback: fallbackFontFamily,
          height: resolvedLineHeight,
          leadingDistribution: isEmoji && optimizeEmojiAlign
              ? TextLeadingDistribution.even
              : null,
        );

    if (selectable) {
      child = IntrinsicHeight(
        child: SelectableText(
          text,
          maxLines: maxLines,
          textAlign: textAlign,
          style: textStyle,
        ),
      );
    } else {
      child = Text(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow ?? TextOverflow.clip,
        style: textStyle,
        strutStyle: !isEmoji || (isEmoji && optimizeEmojiAlign)
            ? StrutStyle.fromTextStyle(
                textStyle,
                forceStrutHeight: true,
                leadingDistribution: TextLeadingDistribution.even,
                height: resolvedLineHeight,
              )
            : null,
      );
    }

    if (withTooltip) {
      child = Tooltip(message: text, child: child);
    }

    return child;
  }

  String? _loadEmojiFontFamilyIfNeeded() {
    if (_useNotoColorEmoji) {
      return GoogleFonts.notoColorEmoji().fontFamily;
    }
    return null;
  }

  bool get _useNotoColorEmoji => Platform.isLinux || Platform.isAndroid;
}
