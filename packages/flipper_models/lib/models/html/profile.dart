library flipper_models;

class Profile {
  Profile({
    this.id = 0,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.city,
    this.state,
    required this.country,
    this.pincode,
    this.profilePic,
    this.coverPic,
    this.about,
    required this.vaccinationCode,
    required this.livingAt,
    required this.cell,
    required this.district,
    required this.businessId,
    required this.nationalId,
  });

  int id;
  String name;
  String email;
  String phone;
  String? address;
  String? city;
  String? state;
  String country;
  String? pincode;
  String? profilePic;
  String? coverPic;
  String? about;
  String vaccinationCode;
  String livingAt;
  String cell;
  String district;
  int businessId;
  String nationalId;

  factory Profile.fromJson(Map<dynamic, dynamic> json) => Profile(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pincode: json["pincode"],
        profilePic: json["profilePic"],
        coverPic: json["coverPic"],
        about: json["about"],
        vaccinationCode: json["vaccinationCode"],
        livingAt: json["livingAt"],
        cell: json["cell"],
        district: json["district"],
        businessId: json["businessId"],
        nationalId: json["nationalId"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
        "profilePic": profilePic,
        "coverPic": coverPic,
        "about": about,
        "vaccinationCode": vaccinationCode,
        "livingAt": livingAt,
        "cell": cell,
        "district": district,
        "businessId": businessId,
        "nationalId": nationalId,
      };
}
