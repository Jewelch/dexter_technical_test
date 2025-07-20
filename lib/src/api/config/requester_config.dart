part of '../data_source.dart';

class _RequesterConfig extends RequesterConfiguration {
  _RequesterConfig(super.dio, super.cacheManager, super.connectivityMonitor)
    : super(
        baseOptions: BaseOptions(
          baseUrl: AppEnvironment.current.baseUrl,
          connectTimeout: Duration(milliseconds: AppEnvironment.current.connectTimeout),
          sendTimeout: kIsWeb ? null : Duration(milliseconds: AppEnvironment.current.sendTimeout),
          receiveTimeout: Duration(milliseconds: AppEnvironment.current.receiveTimeout),
          contentType: ContentType.json.mimeType,
        ),
        queuedInterceptorsWrapper: QueuedInterceptorsWrapper(
          onRequest: (options, handler) => handler.next(options),
          onResponse: (response, handler) => handler.next(response),
          onError: (error, handler) => handler.next(error),
        ),
        debuggingEnabled: true,
        logRequestHeaders: true,
        maxRetriesPerRequest: 2,
        mockAwaitDurationMs: 2000,
      );
}
