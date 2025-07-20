import '../bloc/base_bloc.dart';
import '../dependencies/dependencies.dart';
import 'exports.dart';

/// A base widget for providing a Bloc to its child widget tree. It allows you to inject
/// dependencies and manage the lifecycle of the provided Bloc.
///
/// Example:
/// ```dart
/// class LoginScreen extends BlocProviderWidget<LoginBloc> {
///   ProductDetailsScreenEnum({super.key})
///      :  super(
///           dependencies: ProductScreenDependencies(),
///         );
///
///   @override
///   Widget build(BuildContext context) {
///     return BlocBuilder<LoginBloc, LoginState>(
///       builder: (context, state) {
///         return switch (state) {
///           Idle() => const IdleWidget(),
///           Loading() => const LoadingWidget(),
///           Error(message: final String message) => ErrorWidget(message: message),
///           Empty() => const EmptyWidget(),
///           Success() => SuccessWidget(),
///         };
///       },
///     );
///   }
/// }
/// ```
///
/// Where:
/// - `IdleWidget`: A widget displayed when the state is idle.
/// - `LoadingWidget`: A widget displayed when the state is loading.
/// - `ErrorWidget`: A widget displayed when an error occurs. It takes a message as a parameter.
/// - `EmptyWidget`: A widget displayed when the state is empty.
/// - `SuccessWidget`: A widget displayed when the state is successful, typically containing a list of products.
/// - [dependencies] allows dependency injection

abstract class BlocProviderWidget<B extends BaseBloc> extends StatefulWidget {
  /// Creates a [BlocProviderWidget].
  ///
  /// - [dependencies]: Optional. A [Dependencies] instance for lazy or eager dependency injection.
  /// - [lazy]: Whether to create the [Bloc] lazily or eagerly. Defaults to `true` (lazy).
  /// - [buildWhen]: Optional. A function that decides when to rebuild the widget based on the previous
  /// and current state of the [Bloc].
  BlocProviderWidget({
    super.key,
    this.dependencies,
    this.lazy = true,
    this.listenWhen,
    this.onUpdate,
    this.fullRebuildWhen,
  });

  final Dependencies? dependencies;

  /// Whether to create the [Bloc] lazily or eagerly. Defaults to `true`.
  final bool lazy;

  /// A function that determines when to rebuild the widget based on the previous and current state.
  /// If `null`, the widget will rebuild on every state change.
  final BlocBuilderCondition<dynamic>? listenWhen;

  final void Function(BuildContext, dynamic)? onUpdate;
  final bool Function(BuildContext, dynamic)? fullRebuildWhen;

  /// The route path for this screen. Override this in subclasses to provide a custom path.
  /// Defaults to an empty string if not overridden.
  static String get path => '';

  /// The [Bloc] provided to the widget.
  B get bloc => _state!.bloc;

  _State<BlocProviderWidget, B>? _state;

  @override
  createState() => _State<BlocProviderWidget, B>();

  /// Builds the widget's UI based on the current [BuildContext].
  /// You must implement this in subclasses to define the widget's content.
  @protected
  Widget build(BuildContext context);
}

class _State<T extends BlocProviderWidget, B extends BaseBloc> extends State<T> {
  late final B bloc; // Ensures bloc persists

  @override
  @protected
  void initState() {
    super.initState();
    widget._state = this;
    widget.dependencies?.inject();
    bloc = get<B>(); // Initialize bloc only once
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._state = this;
  }

  @override
  void dispose() {
    bloc.onDispose();
    widget._state = null;
    super.dispose();
  }

  @override
  @protected
  Widget build(BuildContext context) => BlocProvider<B>(
    create: (_) => bloc,
    lazy: widget.lazy,
    child: BlocListener<B, dynamic>(
      listenWhen: widget.listenWhen,
      listener: (context, state) {
        setState.execute(
          () => () {
            Debugger.white('${widget.runtimeType} rebuilt');
          },
          when: widget.fullRebuildWhen?.call(context, state),
        );
        widget.onUpdate != null
            ? widget.onUpdate!.call(context, state)
            : Debugger.cyan('${widget.runtimeType} state: ${state.toString().split('(').first}');
      },
      child: widget.build(context),
    ),
  );
}
