import 'dart:async';

import 'package:appattiva/Controller/Note.dart';
import 'package:appattiva/Model/Impianto.dart';

class Note {
  Note(this.IdNoteimpianto, this.Testo, this.Data, this.Utente, this.imp);

  int IdNoteimpianto;
  String Testo, Data, Utente;
  Impianto imp;

  static Future<List<Note>> load(Impianto imp) async {
    return await NoteController.load(imp);
  }

  static Future<bool> insert(Impianto imp, String note) async {
    return await NoteController.insert(imp, note);
  }

  Future<bool> delete() async {
    return await NoteController.delete(this);
  }
}
