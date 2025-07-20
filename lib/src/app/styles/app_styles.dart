import '../../base/screens/exports.dart';

abstract final class AppStyles {
  static const _defaultFont = AppFonts.helvetica;

  static final headline1 = _defaultFont.withSize(FontSizes.headline1);
  static final headline2 = _defaultFont.withSize(FontSizes.headline2);
  static final headline3 = _defaultFont.withSize(FontSizes.headline3);
  static final headline4 = _defaultFont.withSize(FontSizes.headline4);
  static final title = _defaultFont.withSize(FontSizes.title);
  static final subtitle = _defaultFont.withSize(FontSizes.subtitle);
  static final indication = _defaultFont.withSize(FontSizes.indication);
  static final caption = _defaultFont.withSize(FontSizes.caption);
}

extension TextStyleExt on TextStyle {
  TextStyle thin() => copyWith(fontWeight: FontWeight.w100);
  TextStyle extraLight() => copyWith(fontWeight: FontWeight.w200);
  TextStyle light() => copyWith(fontWeight: FontWeight.w300);
  TextStyle regular() => copyWith(fontWeight: FontWeight.w400);
  TextStyle medium() => copyWith(fontWeight: FontWeight.w500);
  TextStyle semiBold() => copyWith(fontWeight: FontWeight.w600);
  TextStyle bold() => copyWith(fontWeight: FontWeight.w700);
  TextStyle extraBold() => copyWith(fontWeight: FontWeight.w800);
  TextStyle black() => copyWith(fontWeight: FontWeight.w900);

  TextStyle withSize(double fontSize) => copyWith(fontSize: fontSize);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle italic() => copyWith(fontStyle: FontStyle.italic);

  TextStyle white() => copyWith(color: Colors.white);
  TextStyle dark() => copyWith(color: AppColors.black);
  TextStyle primary() => copyWith(color: AppColors.primary);
  TextStyle secondary() => copyWith(color: AppColors.secondary);
  TextStyle accent() => copyWith(color: AppColors.accent);
}
