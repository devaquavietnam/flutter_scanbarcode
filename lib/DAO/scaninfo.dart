// ignore: camel_case_types
class scaninfo {
  final int? id;
  final String serialnum;
  final String whcode;
  final String matcode;
  final String dnno;
  final String? createdate;
  final String? inout;
  int isshow;

  scaninfo({
    this.id,
    required this.serialnum,
    required this.whcode,
    required this.matcode,
    required this.dnno,
    this.createdate,
    this.inout,
    required this.isshow,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serialnum': serialnum,
      'whcode': whcode,
      'matcode': matcode,
      'dnno': dnno,
      'createdate': createdate,
      'inout': inout,
      'isshow': isshow
    };
  }
}
