// To parse this JSON data, do
//
//     final creditsResponse = creditsResponseFromJson(jsonString);

import 'dart:convert';

class CreditsResponse {
    int id;
    List<Cast> cast;
    List<Cast> crew;

    CreditsResponse({
        required this.id,
        required this.cast,
        required this.crew,
    });

    factory CreditsResponse.fromRawJson(String str) => CreditsResponse.fromJson(json.decode(str));

    //String toRawJson() => json.encode(toJson());

    factory CreditsResponse.fromJson(Map<String, dynamic> json) => CreditsResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
    );

    // Map<String, dynamic> toJson() => {
    //     "id": id,
    //     "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
    //     "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
    // };
}

class Cast {
    Cast({
        required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        this.profilePath,
        required this.castId,
        required this.character,
        required this.creditId,
        required this.order,
        required this.department,
        this.job,
    });

    bool adult;
    int gender;
    int id;
    Department knownForDepartment;
    String name;
    String originalName;
    double popularity;
    String? profilePath;
    int? castId;
    String? character;
    String creditId;
    int? order;
    Department department;
    String? job;

    get fullProfilePath {
      
      if(this.profilePath != null)
        return 'https://image.tmdb.org/t/p/w500${this.profilePath}';
      
      return 'https://i.stack.imgur.com/GNhx0.png';
    }

    factory Cast.fromRawJson(String str) => Cast.fromJson(json.decode(str));

    //String toRawJson() => json.encode(toJson());

    factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        knownForDepartment: departmentValues.map[json["known_for_department"]] ?? Department.ACTING,
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
        castId: json["cast_id"],
        character: json["character"],
        creditId: json["credit_id"],
        order: json["order"],
        department: departmentValues.map[json["department"]] ?? Department.ACTING,
        job: json["job"],
    );

    // Map<String, dynamic> toJson() => {
    //     "adult": adult,
    //     "gender": gender,
    //     "id": id,
    //     "known_for_department": departmentValues.reverse[knownForDepartment],
    //     "name": name,
    //     "original_name": originalName,
    //     "popularity": popularity,
    //     "profile_path": profilePath,
    //     "cast_id": castId,
    //     "character": character,
    //     "credit_id": creditId,
    //     "order": order,
    //     "department": departmentValues.reverse[department],
    //     "job": job,
    // };
}

enum Department { ACTING, CREW, PRODUCTION, COSTUME_MAKE_UP, SOUND, WRITING, EDITING, CAMERA, DIRECTING, ART, VISUAL_EFFECTS, LIGHTING }

final departmentValues = EnumValues({
    "Acting": Department.ACTING,
    "Art": Department.ART,
    "Camera": Department.CAMERA,
    "Costume & Make-Up": Department.COSTUME_MAKE_UP,
    "Crew": Department.CREW,
    "Directing": Department.DIRECTING,
    "Editing": Department.EDITING,
    "Lighting": Department.LIGHTING,
    "Production": Department.PRODUCTION,
    "Sound": Department.SOUND,
    "Visual Effects": Department.VISUAL_EFFECTS,
    "Writing": Department.WRITING
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
