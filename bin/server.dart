import 'dart:io';
import 'package:angel_common/angel_common.dart';

main() async {
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
    404: (req, res) async {
      await res.render('not_found', {'layout': renderLayout});
    },
    403: (req, res) async {
      await res.render('forbidden', {'layout': renderLayout});
    },
    500: (req, res) async {
      await res.render('error', {'layout': renderLayout});
    }
  });
  await app.configure(errors);

  // Read configurations.
  InternetAddress host = new InternetAddress(app.properties['host']);
  int port = app.properties['port'];

  // Set routes.
  app.get('/', (RequestContext req, ResponseContext res) async {
    // Render index.mustache template file.
    await res.render('index', {'title': 'Hello World', 'layout': renderLayout});
  });

  // Catch all remaining requests, returning 404.
  app.all('*', (req, res) async {
    throw new AngelHttpException.notFound();
  });

  // Start a web server.
  var server = await app.startServer(host, port);
  print("Angel server listening on http://${server.address.address}:${server.port}");
}

// Render layout.
// Since mustache doesn't support template inheritance. It is a temporary dirty hack.
renderLayout(String content) {
    return """
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
      <title>Bootstrap 101 Template</title>

      <!-- Bootstrap -->
      <link href="/css/bootstrap.min.css" rel="stylesheet">

      <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
      <![endif]-->
    </head>
    <body>
      ${content}

      <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
      <!-- Include all compiled plugins (below), or include individual files as needed -->
      <script src="/js/bootstrap.min.js"></script>
    </body>
  </html>""";
}
