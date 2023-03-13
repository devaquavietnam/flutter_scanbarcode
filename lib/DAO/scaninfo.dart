// ignore: camel_case_types
class scaninfo {
  final int? id;
  final String serialnum;
  final String matcode;
  final String dnno;
  final String? createdate;

  scaninfo(
      {this.id,
      required this.serialnum,
      required this.matcode,
      required this.dnno,
      this.createdate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serialnum': serialnum,
      'matcode': matcode,
      'dnno': dnno,
      'createdate': createdate
    };
  }
}
