const String tableZikir = 'tbl_zikir';
const String tableZikirColId = 'id';
const String tableZikirColDate = 'date';
const String tableZikirColName = 'name';
const String tableZikirColCount = 'count';

class ZikirModel {
  int? id;
  String date;
  String name;
  int count;

  ZikirModel({
    this.id,
    required this.date,
    required this.name,
    required this.count
});

  Map<String, dynamic> toMap(){
    final map = <String, dynamic>{
      tableZikirColDate : date,
      tableZikirColName : name,
      tableZikirColCount : count
    };
    if(id != null){
      map[tableZikirColId] = id;
    }
    return map;
  }

  factory ZikirModel.fromMap(Map<String, dynamic> map)=>
      ZikirModel(
          id: map[tableZikirColId],
          date: map[tableZikirColDate],
          name: map[tableZikirColName],
          count : map[tableZikirColCount]
      );

  ZikirModel copyWith({
    int? id,
    String? date,
    String? name,
    int? count,
  }) {
    return ZikirModel(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }
}