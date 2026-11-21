/// A user's saved birth date and time. [birthDateTime] is null until saved.
class BirthInfoEntity {
  final DateTime? birthDateTime;
  final DateTime? updatedAt;

  const BirthInfoEntity({this.birthDateTime, this.updatedAt});

  bool get isSet => birthDateTime != null;
}
