class Surveillance{
  final int id;
  final int superviseur_id;
  final String salle_id;
  final int evaluation_id;
  String superviseur;
  List<String> salle;
  String evaluation;
  Surveillance(this.id,this.superviseur_id,this.salle_id,this.evaluation_id,this.superviseur,this.salle, this.evaluation);
}