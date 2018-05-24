import 'package:path/path.dart' as p;

// Une mini librairie pour gérer les paths.
// Plus tard, on l'améliorera pour gérer des paramètres optionnel etc...

//TODO(xha): gérer des paramètres optionnel dans les pattern. Ex:
// games/list/filtered(:query,:tag)
// qui serait encodé
// games/list/filtered;query=myQuery,tag=myTag
// ==> Peut-être qu'ils ne sont pas obligé d'être présent dans le pattern?
class PathPattern {
  final String _original;
  List<String> _segments;

  PathPattern(String path): _original = path {
    path = trimSlashes(path);

    _segments = p.url.split(path);
  }

  List<String> get segments => _segments;

  String get original => _original;

  String toString() => 'PathPattern(${_segments.join('/')})';
}

final RegExp _findParameters = new RegExp(r':([a-zA-Z0-9_]+)');

String trimSlashes(String url) {
  if (url.endsWith('/')) {
    url = url.substring(0, url.length - 1);
  }
  if (url.startsWith('/')) {
    url = url.substring(1);
  }

  return url;
}

class Path {
  final String _fullUrl;
  List<String> _remainingSegments;

  Path(String fullUrl) : _fullUrl = trimSlashes(fullUrl) {
    _remainingSegments = p.url.split(_fullUrl);
  }

  Peek peek(PathPattern pattern) {
    if (_remainingSegments.length < pattern.segments.length) return null;

    List<String> matchedSegments = [];
    Map<String, String> parameters = {};
    int index = 0;
    for (String segmentPattern in pattern.segments) {
      String actualSegment = _remainingSegments[index];

      if (segmentPattern.contains(':')) {
        RegExp matcher = new RegExp(r'^' +
            segmentPattern.replaceAll(_findParameters,
                r"((?:[\w'\.\-~!\$&\(\)\*\+,;=:@]|%[0-9a-fA-F]{2})+)") +
            r'$');
        Match match = matcher.firstMatch(actualSegment);
        if (match == null) {
          return null;
        } else {
          matchedSegments.add(actualSegment);

          Iterable<String> parameterNames =
              _findParameters.allMatches(segmentPattern).map((m) => m.group(1));
          int i = 0;
          for (String parameterName in parameterNames) {
            parameters[parameterName] = match.group(i + 1);
            ++i;
          }
        }
      } else if (segmentPattern != actualSegment) {
        return null;
      } else {
        matchedSegments.add(actualSegment);
      }

      ++index;
    }

    _remainingSegments.removeRange(0, matchedSegments.length);

    return new Peek(this, pattern, matchedSegments, parameters);
  }

  String toString() => 'Path(full: $_fullUrl, remaining: ${_remainingSegments.join('/')})';
}

class Peek {
  final Path path;
  final PathPattern pattern;
  final Map<String, String> parameters;
  final List<String> segments;

  Peek(this.path, this.pattern, this.segments, this.parameters);

  String get joinedSegments => segments.join('/');

  String toString() => 'Peek(${segments.join('/')}, parameters: $parameters)';
}
