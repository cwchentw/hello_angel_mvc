import 'dart:io';
import 'package:angel_common/angel_common.dart';

import 'src/controller/index.dart';
import 'src/controller/404.dart';
import 'src/controller/403.dart';
import 'src/controller/500.dart';

runServer() async {
  // Create a new Angel app.
  Angel app = new Angel();

  // Set this app.
  // Load configuration files from config directory.
  await app.configure(loadConfigurationFile());
  // Set template directory.
  await app.configure(mustache(new Directory('views')));
  // Set static directory. Send Cache-Control, ETag, etc. as well
  await app.configure(new CachingVirtualDirectory(source: new Directory('public')));
  // Logging to console.
  await app.configure(logRequests());

  // Error handling.
  final errors = new ErrorHandler(handlers: {
    404: notFound,
    403: forbidden,
    500: internalError
  });
  await app.configure(errors);

  // Read configurations.
  InternetAddress host = new InternetAddress(app.properties['host']);
  int port = app.properties['port'];

  // Set routes.
  await app.get('/', index);

  // Catch all remaining requests, returning 404.
  app.all('*', (req, res) async {
    throw new AngelHttpException.notFound();
  });

  // Start a web server.
  var server = await app.startServer(host, port);
  print("Angel server listening on http://${server.address.address}:${server.port}");
}
