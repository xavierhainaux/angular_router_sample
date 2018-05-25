import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:my_angular_project/router_6/path.dart';
import 'package:path/path.dart' as p;

export 'path.dart' show Peek;

abstract class RouterOutlet {
  RouterOutlet get parent;
  String get currentPath;
  void activate(Peek peek, Route route);
  void deactivate(String path);
}

class Location {
  PathPattern _base;
  final Set<OutletHolder> _allOutlets = new Set();
  final List<MatchedEntry> _activatedEntries = [];

  // Retourne le chemin complet en rajoutant la base.
  String getFullUrl(String link, RouterOutlet parent) {
    List<String> segments = [];
    if (_base != null) {
      segments.addAll(_base.segments);
    }

    if (link.startsWith('/')) {
      link = link.substring(1);
      segments.add(link);
      return '/${p.url.joinAll(segments)}';
    }

    List<String> outletsPath = [];
    while (parent != null) {
      outletsPath.add(parent.currentPath);
      parent = parent.parent;
    }
    segments.addAll(outletsPath.reversed);
    segments.add(link);

    return '/' + p.url.normalize(p.url.joinAll(segments));
  }

  set base(String base) {
    _base = new PathPattern(base);
  }

  String get url => _url;
  String _url = '';
  set url(String url) {
    url ??= '';
    url = trimSlashes(p.url.normalize(url));
    url = '/$url';

    _url = url;

    List<MatchedEntry> newEntries = getMatchedEntries(url);

    if (_activatedEntries.isNotEmpty) {
      List<MatchedEntry> entriesToRemove = [];

      // On regarde dans les entrées activées celles qui ne sont plus dans le nouveau chemin
      for (MatchedEntry oldEntry in _activatedEntries.reversed) {
        if (newEntries.every((e) => !e.isSameEntry(oldEntry))) {
          entriesToRemove.add(oldEntry);
        }
      }

      for (MatchedEntry entryToRemove in entriesToRemove) {
        entryToRemove.outlet.outlet
            .deactivate(entryToRemove.peek.pattern.original);

        _activatedEntries.remove(entryToRemove);
      }
    }

    for (MatchedEntry newEntry in newEntries) {
      // On ne réactive pas une entrée déjà présente dans les activées
      if (_activatedEntries.every((e) => !e.isSameEntry(newEntry))) {
        newEntry.outlet.outlet
            .activate(newEntry.peek, new Route(newEntry.peek.parameters));
      }
    }

    _activatedEntries.clear();
    _activatedEntries.addAll(newEntries);
  }

  _forceRefresh() {
    url = url;
  }

  void register(RouterOutlet outlet, Iterable<String> paths) {
    OutletHolder holder =
        new OutletHolder(outlet, paths.map((p) => new PathPattern(p)).toList());
    _allOutlets.add(holder);

    _forceRefresh();
  }

  void unRegister(RouterOutlet outlet) {
    _allOutlets.removeWhere((o) => o.outlet == outlet);

    _forceRefresh();
  }

  List<MatchedEntry> getMatchedEntries(String url) {
    List<MatchedEntry> entries = [];

    Path path = new Path(url);

    if (path.peek(_base) == null) {
      return entries;
    }

    Iterable<OutletHolder> possibleEntries =
        _allOutlets.where((o) => o.outlet.parent == null);
    while (true) {
      MatchedEntry match = _matchedEntry(possibleEntries, path);
      if (match != null) {
        entries.add(match);
        possibleEntries =
            _allOutlets.where((o) => o.outlet.parent == match.outlet.outlet);
      } else {
        break;
      }
    }

    return entries;
  }

  MatchedEntry _matchedEntry(Iterable<OutletHolder> possibles, Path path) {
    for (OutletHolder entryToTest in possibles) {
      for (PathPattern pathToTest in entryToTest.paths) {
        Peek peek = path.peek(pathToTest);
        if (peek != null) {
          return new MatchedEntry(entryToTest, peek);
        }
      }
    }
    return null;
  }
}

class OutletHolder {
  final RouterOutlet outlet;
  final List<PathPattern> paths;

  OutletHolder(this.outlet, Iterable<PathPattern> paths)
      : paths = sortPaths(paths);

  static List<PathPattern> sortPaths(Iterable<PathPattern> paths) {
    List<PathPattern> sorted = paths.toList();
    mergeSort(sorted, compare: (PathPattern p1, PathPattern p2) {
      if (p1.original == '' && p2.original != '') return 1;
      if (p2.original == '' && p1.original != '') return -1;
      return 0;
    });
    return sorted;
  }
}

class MatchedEntry {
  final OutletHolder outlet;
  final Peek peek;

  MatchedEntry(this.outlet, this.peek) {
    assert(peek != null);
  }

  String toString() {
    String pattern = p.url.joinAll(peek.pattern.segments);

    for (String parameter in peek.parameters.keys) {
      String parameterValue = peek.parameters[parameter];
      pattern =
          pattern.replaceAll(':$parameter', '{"$parameter":"$parameterValue"}');
    }
    return pattern;
  }

  Map<String, String> get parameters => peek.parameters;

  bool isSameEntry(MatchedEntry other) =>
      outlet.outlet == other.outlet.outlet &&
      peek.joinedSegments == other.peek.joinedSegments;
}

class Route {
  final Map<String, String> parameters;

  Route(this.parameters);

//  List<Route> ancestors;

  //TODO(xha): remonte les ancestors et rempli une Map avec tous les paramètres
//  Map<String, String> get allParameters => {};
}
