import 'package:cg_core_defs/cg_core_defs.dart' show CacheManager, ConnectivityMonitor;
import 'package:flutter/foundation.dart';
import 'package:lean_requester/lean_requester.dart';

import '../app/environment/app_environment.dart';

export 'package:cg_core_defs/cg_core_defs.dart' show CacheManager, ConnectivityMonitor;
export 'package:lean_requester/datasource_exp.dart'
    hide RestfulConsumer, FileDownloader, FileUploader;
export 'package:lean_requester/models_exp.dart';

part 'config/requester_config.dart';

abstract base class RestfulConsumerImpl extends RestfulConsumer {
  RestfulConsumerImpl(Dio dio, CacheManager cacheManager, ConnectivityMonitor connectivityMonitor)
    : super(_RequesterConfig(dio, cacheManager, connectivityMonitor));
}
