const String tableNote = 'tbl_note';
const String tableNoteColId = 'id';
const String tableNoteColNote = 'note';

class NoteModel {
  int? id;
  String note;

  NoteModel({
    this.id,
    required this.note
  });

  Map<String, dynamic> toMap(){
    final map = <String, dynamic>{
      tableNoteColNote : note
    };
    if(id != null){
      map[tableNoteColId] = id;
    }
    return map;
  }

  factory NoteModel.fromMap(Map<String, dynamic> map)=>
      NoteModel(
          id: map[tableNoteColId],
          note: map[tableNoteColNote]
      );
}
