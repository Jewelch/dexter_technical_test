import '../dependencies/dependencies.dart';
import 'exports.dart';

/// A base widget for injecting dependencies to its child widget tree without providing a Bloc.
/// This is useful when you need dependency injection but don't want to manage a Bloc lifecycle.
///
/// Example:
/// ```dart
/// class ShiftHandoverScreen extends DependencyInjectionWidget {
///   ShiftHandoverScreen({super.key})
///      : super(dependencies: ShiftHandoverDependencies());
///
///   @override
///   Widget build(BuildContext context) {
///     return BlocProvider(
///       create: (context) => get<ShiftHandoverBloc>()..add(GetShiftReport('current-user-id')),
///       child: Scaffold(
///         appBar: const ShiftHandoverAppBar(),
///         body: BlocConsumer<ShiftHandoverBloc, ShiftHandoverState>(
///           // Widget content...
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// Where:
/// - [dependencies] allows dependency injection without managing Bloc lifecycle
/// - The widget can manually create and manage BlocProviders as needed

abstract class DependencyInjectionWidget extends StatefulWidget {
  /// Creates a [DependencyInjectionWidget].
  ///
  /// - [dependencies]: Optional. A [Dependencies] instance for lazy or eager dependency injection.
  const DependencyInjectionWidget({super.key, this.dependencies});

  final Dependencies? dependencies;

  /// The route path for this screen. Override this in subclasses to provide a custom path.
  /// Defaults to an empty string if not overridden.
  static String get path => '';

  @override
  createState() => _DependencyInjectionState();

  /// Builds the widget's UI based on the current [BuildContext].
  /// You must implement this in subclasses to define the widget's content.
  @protected
  Widget build(BuildContext context);
}

class _DependencyInjectionState extends State<DependencyInjectionWidget> {
  @override
  @protected
  void initState() {
    super.initState();
    widget.dependencies?.inject();
  }

  @override
  @protected
  Widget build(BuildContext context) => widget.build(context);
}
