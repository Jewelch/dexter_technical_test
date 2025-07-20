import '../../base/screens/exports.dart';

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing(this.width, {super.key, this.visible = true});

  final double width;
  final bool visible;

  @override
  Widget build(BuildContext context) => SizedBox(width: width).visibleWhen(visible);
}
