import 'package:agendacontatos/utils/constants.dart';

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;

  Contact();

  Contact.fromMap(Map map) {
    id = map[IDCOLUMN];
    name = map[NAMECOLUMN];
    email = map[EMAILCOLUMN];
    phone = map[PHONECOLUMN];
    image = map[IMAGECOLUMN];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      NAMECOLUMN: name,
      EMAILCOLUMN: email,
      PHONECOLUMN: phone,
      IMAGECOLUMN: image
    };
    if (id != null) {
      map[IDCOLUMN] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, " + 
    "phone: $phone, image: $image";
  }
}