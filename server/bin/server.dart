import 'dart:io';

import 'package:shelf_route/shelf_route.dart' as shelf;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_proxy/shelf_proxy.dart';
import 'utils.dart';

main() {
  final shelf.Router router = shelf.router();

  var extranetHandler =
      fileHandler(new File('web/main.html'), allowCache: false);
  router.get('/extranet', extranetHandler);
  router.get('/extranet/{+rest}', extranetHandler);

  router.add('/', ['GET'], proxyHandler('http://localhost:8080'),
      exactMatch: false);

  _startServer(router.handler);
}

_startServer(Handler handler,
    {InternetAddress address, int port: 60000}) async {
  address ??= InternetAddress.anyIPv6;

  HttpServer server = await HttpServer.bind(address, port, shared: true);

  server.defaultResponseHeaders.remove('x-frame-options', 'SAMEORIGIN');
  io.serveRequests(server, handler);
  print('Serving at https://${server.address.host}:${server.port}');
}
