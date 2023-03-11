// ignore: camel_case_types
class scaninfo {
  final int id;
  final String serialnum;
  final String matcode;
  final String dnno;

  scaninfo(
      {required this.id,
      required this.serialnum,
      required this.matcode,
      required this.dnno});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serialnum': serialnum,
      'matcode': matcode,
      'dnno': dnno,
    };
  }
}
