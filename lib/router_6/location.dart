import 'package:path/path.dart' as p;

abstract class RouterOutlet {
  RouterOutlet get parent;

  onActivate(String path, Route route);
  onDeactivate(String path);
}

class Location {
  final String base;
  final List<Entry> _entries = [];

  // Les entrées activés triée de la racine à la feuille
  final List<Entry> _activatedEntries = [];

  Location(this.base);

  String get url => _url;
  String _url;
  set url(String url) {
    url = p.url.normalize(url);

    if (_url != null) {
      // Désactiver tous les anciens chemin qui ne matchent plus
    }

    String urlWithoutBase;
    if (base != null) {
      if (!p.url.isWithin(base, url)) {
        return;
      }

      urlWithoutBase = p.url.relative(url, from: base);
    }



    // 1. Désactive l'ancienne url
    // 2. Activer les nouveaux dans l'ordre

    // Les muscles du moteur: basé sur la valeur de l'url, on parcours tous les
    // noeuds enregistrés (qui sont triés) et si leur Route est modifiée, on
    // appelle leur méthode d'activation/désactivation.
    // On tient compte de ne jamais ré-appeler plusieurs fois d'affilées avec les mêmes valeurs.
  }

  Iterable<Entry> _matches(String url) {
    _childrenOf(null);
  }

  Iterable<Entry> _childrenOf(RouterOutlet outlet) {

  }

  register(RouterOutlet outlet, String path) {
    _entries.add(new Entry(outlet, path));
  }
}

class Entry {
  final RouterOutlet outlet;
  final String path;

  Entry(this.outlet, this.path);
}

class Route {
  List<Route> ancestors;

  Map<String, String> parameters;

  //TODO(xha): remonte les ancestors et rempli une Map avec tous les paramètres
  Map<String, String> get allParameters => {};
}
