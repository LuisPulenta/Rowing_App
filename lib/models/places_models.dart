class PlacesResponse {
  String? type;
  List<String>? query;
  List<Features>? features;
  String? attribution;

  PlacesResponse({this.type, this.query, this.features, this.attribution});

  PlacesResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    query = json['query'].cast<String>();
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    attribution = json['attribution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['query'] = query;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['attribution'] = attribution;
    return data;
  }
}

class Features {
  String? id;
  String? type;
  List<String>? placeType;
  //int? relevance;
  Properties? properties;
  String? textEs;
  String? languageEs;
  String? placeNameEs;
  String? text;
  String? language;
  String? placeName;
  List<double>? center;
  Geometry? geometry;
  List<Context>? context;

  Features(
      {this.id,
      this.type,
      this.placeType,
      //this.relevance,
      this.properties,
      this.textEs,
      this.languageEs,
      this.placeNameEs,
      this.text,
      this.language,
      this.placeName,
      this.center,
      this.geometry,
      this.context});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    placeType = json['place_type'].cast<String>();
    //relevance = json['relevance'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    textEs = json['text_es'];
    languageEs = json['language_es'];
    placeNameEs = json['place_name_es'];
    text = json['text'];
    language = json['language'];
    placeName = json['place_name'];
    center = json['center'].cast<double>();
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    if (json['context'] != null) {
      context = <Context>[];
      json['context'].forEach((v) {
        context!.add(Context.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['place_type'] = placeType;
    //data['relevance'] = relevance;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    data['text_es'] = textEs;
    data['language_es'] = languageEs;
    data['place_name_es'] = placeNameEs;
    data['text'] = text;
    data['language'] = language;
    data['place_name'] = placeName;
    data['center'] = center;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    if (context != null) {
      data['context'] = context!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Feature: $text - $placeName';
  }
}

class Properties {
  String? foursquare;
  bool? landmark;
  String? wikidata;
  String? address;
  String? category;
  String? maki;

  Properties(
      {this.foursquare,
      this.landmark,
      this.wikidata,
      this.address,
      this.category,
      this.maki});

  Properties.fromJson(Map<String, dynamic> json) {
    foursquare = json['foursquare'];
    landmark = json['landmark'];
    wikidata = json['wikidata'];
    address = json['address'];
    category = json['category'];
    maki = json['maki'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['foursquare'] = foursquare;
    data['landmark'] = landmark;
    data['wikidata'] = wikidata;
    data['address'] = address;
    data['category'] = category;
    data['maki'] = maki;
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class Context {
  String? id;
  String? textEs;
  String? text;
  String? wikidata;
  String? languageEs;
  String? language;
  String? shortCode;

  Context(
      {this.id,
      this.textEs,
      this.text,
      this.wikidata,
      this.languageEs,
      this.language,
      this.shortCode});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    textEs = json['text_es'];
    text = json['text'];
    wikidata = json['wikidata'];
    languageEs = json['language_es'];
    language = json['language'];
    shortCode = json['short_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text_es'] = textEs;
    data['text'] = text;
    data['wikidata'] = wikidata;
    data['language_es'] = languageEs;
    data['language'] = language;
    data['short_code'] = shortCode;
    return data;
  }
}
