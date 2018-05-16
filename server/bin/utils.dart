import 'dart:io';
import 'package:http_parser/src/http_date.dart';
import 'package:mime/mime.dart' as mime;
import 'package:shelf/shelf.dart';

Handler fileHandler(File file, {bool allowCache: true}) {
  return (Request request) =>
      createFileResponse(request, file, allowCache: allowCache);
}

Response createFileResponse(Request request, File file,
    {bool allowCache: true}) {
  var fileStat = file.statSync();

  if (fileStat.changed == null) {
    return new Response.notFound('404 $file not found');
  }

  var headers = <String, String>{
    HttpHeaders.CONTENT_LENGTH: fileStat.size.toString(),
    HttpHeaders.LAST_MODIFIED: formatHttpDate(fileStat.changed)
  };

  String contentType = mime.lookupMimeType(file.path);

  if (contentType != null) {
    headers[HttpHeaders.CONTENT_TYPE] = contentType;
  }

  if (!allowCache) {
    headers[HttpHeaders.CACHE_CONTROL] = 'no-cache';
  }

  return new Response.ok(file.openRead(), headers: headers);
}

Handler corsAdapter(Handler handler) {
  return (Request request) async {
    Response response = await handler(request);

    response = response.change(headers: {'Access-Control-Allow-Origin': '*'});
    return response;
  };
}

// Handle preflight (OPTIONS) requests by just adding headers and an empty
// response.
Response corsOptionsHandler(Request request) {
  return new Response.ok(null, headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token'
  });
}
