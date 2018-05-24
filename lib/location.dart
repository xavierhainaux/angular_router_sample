
typedef _OnActivate(Route route);
typedef _OnDeactivate();

class Location {

  String get url => _url;
  String _url;
  set url(String url) {
    // Les muscles du moteur: basé sur la valeur de l'url, on parcours tous les
    // noeuds enregistrés (qui sont triés) et si leur Route est modifiée, on
    // appelle leur méthode d'activation/désactivation.
    // On tient compte de ne jamais ré-appeler plusieurs fois d'affilées avec les mêmes valeurs.
  }

  register(LocationDelegate delegate) {
    // Quand nouveau s'enregistre, on fait comme si on raffraichissait l'url
    this.url = url;
  }
}

abstract class LocationDelegate {
  void onActivate(Route route);
  void onDeactivate();
}

class Route {
  List<Route> ancestors;

  Map<String, String> parameters;

  //TODO(xha): remonte les ancestors et rempli une Map avec tous les paramètres
  Map<String, String> get allParameters => {};
}
