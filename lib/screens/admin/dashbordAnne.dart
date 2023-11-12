import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pfe_front_flutter/bar/masterpageadmin2.dart';
import '../../bar/masterpageadmin.dart';
import '../../models/departement.dart';
import '../lists/listetudiant.dart';
import '../lists/listeuser2.dart';
import '../lists/listexamun.dart';
import '../lists/listmatiere.dart';
import '../lists/listpv.dart';
import '../lists/listsalle.dart';
import '../lists/listsemestre.dart';
import '../lists/listsurveillant.dart';
import '../lists/listuser.dart';
import 'dashbord2.dart';
import 'package:http/http.dart' as http;
import '../../consturl.dart';
import 'dashbordSurveillance.dart';
import 'dashord.dart';
const double _kItemExtent = 32.0;



class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.white;
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
    paint.color = Colors.blueAccent!;
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashBoardAnnee extends StatefulWidget {
  String accessToken;
  String nomfil;
  String nom_user;
  String photo_user;
   DashBoardAnnee({required this.accessToken,required this.nomfil,required this.nom_user,required this.photo_user});

  @override
  State<DashBoardAnnee> createState() => _DashBoardAnneeState();
}

class _DashBoardAnneeState extends State<DashBoardAnnee> {
  late Size size;
  List<List<String>> anneesList = [];
  List<String> departementsList = [];
  List<String> formationsList = [];
  List<String> niveausList = [];
  List<String> semestresList = [];
  List<String> filieresList = [];
  List<String> choixList = [
    "Scolarité",
    "Surveillance",
  ];
  List<String> scolariteList = [
    "Etudiants",
    "Matieres",
  ];
  List<String> suveillanceList = [
    "Superviseurs",
    "Surveillants",
    "Surveillances",
    "Evaluations",
    "Procès verbals",
    "Salles",
  ];
  DateTime date1 = DateTime.now(); // Initialisation par défaut à la date actuelle
  DateTime date2 = DateTime.now();
  int _selectedAnnee = 0;
  int _selectedDepartement = 0;
  int _selectedFormation = 0;
  bool _isAnneeSelected = false;
  int _selectedNiveau = 0;
  int _selectedSemestre = 0;
  int _selectedFiliere = 0;
  int _selectedChoix = 0;
  int _selectedScolarite = 0;
  int _selectedSurveillance = 0;
  int id_annee=0;
  bool _isSelectDepartement=false;
  bool isSelectFormation=false;
  bool isSelectNiveau=false;
  bool isSelectSemestre=false;
  bool isSelectFiliere=false;
  bool isSelectScolarite=false;
  bool isSelectSurveillance=false;
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    // print('Date 1 sélectionnée : ${date1.toString()}');
    // print('Date 2 sélectionnée : ${date2.toString()}');
    // print(departementsList[_selectedDepartement]);
    // print(formationsList[_selectedFormation]);
    // print(niveausList[_selectedNiveau]);
    if (scolariteList[_selectedScolarite] == 'Etudiants' && choixList[_selectedChoix]=='Scolarité') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,accessToken: widget.accessToken,nomfil:  widget.nomfil, nom_user: widget.nom_user,photo_user: widget.photo_user,
              child:
              EtudiantHome(  accessToken:  widget.accessToken, nomfil: widget.nomfil,                nom_user: widget.nom_user,
                photo_user: widget.photo_user,),
        ),
        ));
    }
    if (scolariteList[_selectedScolarite] == 'Matieres' && choixList[_selectedChoix]=='Scolarité') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: MatiereHome(  accessToken: widget.accessToken,  nomfil: widget.nomfil,                nom_user: widget.nom_user,
                  photo_user: widget.photo_user,),),
        ),
      );
    }
    if (suveillanceList[_selectedSurveillance] == 'Superviseurs' && choixList[_selectedChoix]=='Surveillance') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: ListUser(  accessToken: widget.accessToken,  nomfil: widget.nomfil,                nom_user: widget.nom_user,
                  photo_user: widget.photo_user,),),
        ),
      );
    }
    if (suveillanceList[_selectedSurveillance] == 'Surveillants' && choixList[_selectedChoix]=='Surveillance') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: ListUser2(accessToken: widget.accessToken,  nomfil: widget.nomfil,                nom_user: widget.nom_user,
                  photo_user: widget.photo_user,),),
        ),
      );
    }
    if (suveillanceList[_selectedSurveillance] == 'Surveillances' && choixList[_selectedChoix]=='Surveillance') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: ListSurveillance(accessToken: widget.accessToken,  nomfil: widget.nomfil,                nom_user: widget.nom_user,
                  photo_user: widget.photo_user,),),
        ),
      );
    }
    if (suveillanceList[_selectedSurveillance] == 'Evaluations' && choixList[_selectedChoix]=='Surveillance') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: ListExamun(accessToken: widget.accessToken,  nomfil: widget.nomfil,                nom_user: widget.nom_user,
                  photo_user: widget.photo_user,),),
        ),
      );
    }
    if (suveillanceList[_selectedSurveillance] == 'Procès verbals' && choixList[_selectedChoix]=='Surveillance') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: PvHome(accessToken: widget.accessToken,  nomfil: widget.nomfil,),),
        ),
      );
    }
    if (suveillanceList[_selectedSurveillance] == 'Salles' && choixList[_selectedChoix]=='Surveillance') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MasterPage2(index: 0,
                accessToken:widget.accessToken,
                nomfil: widget.nomfil,
                nom_user: widget.nom_user,
                photo_user: widget.photo_user,
                child: ListSalle(accessToken: widget.accessToken,  nomfil: widget.nomfil,                nom_user: widget.nom_user,
                  photo_user: widget.photo_user,),),
        ),
      );
    }
  }
  Future<List<List<String>>> fetchAnnees() async {
    var response = await http.get(Uri.parse(baseUrl+'annees/annee_universitaire'));
    var annees = <List<String>>[];
    for (var u in jsonDecode(response.body)) {
      annees.add([u['annee_debut'], u['annee_fin']]);
    }// print(annees);
    return annees;
  }
  Future<List<String>> fetchDepartements(String id) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/departements/' + id));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> departements = [];
        for (var u in data) {
          var nomDepartement = u;
          if (nomDepartement is String) {
            departements.add(nomDepartement);
          }
        }
        return departements;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchFormations(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/formations/$nom' ));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> formations = [];
        for (var u in data) {
          var nomFormation = u;
          if (nomFormation is String) {
            formations.add(nomFormation);
          }
        }
        return formations;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchNiveaus(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/niveaus/$nom'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> niveaus = [];
        for (var u in data) {
          var nomNiveau = u;
          if (nomNiveau is String) {
            niveaus.add(nomNiveau);
          }
        }
        return niveaus;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchSemestres(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/semestres/$nom'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> semestres = [];
        for (var u in data) {
          var nomSemestre = u;
          if (nomSemestre is String) {
            semestres.add(nomSemestre);
          }
        }
        return semestres;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<List<String>> fetchFilieres(String nom) async {
    try {
      var response = await http.get(Uri.parse(baseUrl + 'annees/filieres/$nom'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> filieres = [];
        for (var u in data) {
          var nomFiliere = u;
          if (nomFiliere is String) {
            filieres.add(nomFiliere);
          }
        }
        return filieres;
      } else {
        throw Exception('Erreur lors de la requête à l\'API');
      }
    } catch (e) {
      print('Erreur: $e');
      throw e;
    }
  }
  Future<int?> fetchAnnees_by_id(String annee1,String annee2) async {
    var response = await http.get(Uri.parse(baseUrl+'annees/annee_universitaire_by_id/$annee1/$annee2'));
    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      return jsonData;
    }
    return null;
  }
  void initState() {
    super.initState();
    fetchAnnees().then((annees) {
      setState(() {
       anneesList = annees;
       date1 = DateTime(int.parse(anneesList[0][0]));
       date2 = DateTime(int.parse(anneesList[1][0]));
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: CustomPaint(
              painter: ShapesPainter(),
              child: Container(
                height: size.height / 2,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: 450,
                    height: 640,
                    child: createGridItem(0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createGridItem(int position) {
    Color? color = Colors.white;
    late Widget icondata;
    late Widget select;

    String label = 'Années Scolaire';

    switch (position) {
      case 0:
        color = Colors.white;
        icondata = CircleAvatar(radius: 40, backgroundColor: Colors.transparent, backgroundImage: AssetImage('images/years.png'),);
        select = CupertinoPageScaffold(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: _kItemExtent,
                                scrollController: FixedExtentScrollController(
                                  initialItem: _selectedAnnee,
                                ),
                                onSelectedItemChanged: (
                                    int selectedItem) {
                                  setState(() {
                                    _selectedAnnee = selectedItem;
                                    _isAnneeSelected = true;
                                  });
                                  fetchAnnees_by_id('${anneesList[_selectedAnnee][0]}', '${anneesList[_selectedAnnee][1]}').then((id_annee) {
                                    if (id_annee != null) {
                                      // Faites quelque chose avec id_annee ici
                                      fetchDepartements(id_annee.toString()).then((nom) {
                                        setState(() {
                                          departementsList = nom;
                                          print(departementsList);
                                        });
                                      });
                                    } else {
                                      print('La requête n\'a pas abouti.');
                                    }
                                  });
                                },
                                children: List<Widget>.generate(
                                  anneesList.length,
                                      (int index) {
                                    return Center(
                                      child: Text(
                                        '${anneesList[index][0]} -- ${anneesList[index][1]}',
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    );
                                  },
                                ),

                              ),
                            ),
                        child: Text(
                          _selectedAnnee < anneesList.length
                              ? '${anneesList[_selectedAnnee][0]} -- ${anneesList[_selectedAnnee][1]}'
                              : '',
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),

                      ),
                      // ),

                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_isAnneeSelected == true)
                        Row(
                          children: [
                            const Text(
                              'Departement: ',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedDepartement,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {

                                        setState(() {
                                          _selectedDepartement = selectedItem;
                                          if (_selectedDepartement < departementsList.length) {
                                            fetchFormations(
                                                departementsList[_selectedDepartement])
                                                .then((nom) {
                                              setState(() {
                                                formationsList = nom;
                                                print(formationsList);
                                              });
                                            });

                                          }
                                          _isSelectDepartement=true;
                                        });

                                      },
                                      children: List<Widget>.generate(
                                        departementsList.length,  // Corrected variable name
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  departementsList[index]));  // Corrected variable name
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedDepartement < departementsList.length  // Corrected variable name
                                    ? departementsList[_selectedDepartement]  // Corrected variable name
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                      Visibility(
                          visible: _isSelectDepartement==true,
                          child: Row(
                            children: [
                              const Text(
                                'Formation: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    _showDialog(
                                      CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        scrollController: FixedExtentScrollController(
                                          initialItem: _selectedFormation,
                                        ),
                                        onSelectedItemChanged: (
                                            int selectedItem) {
                                          setState(() {
                                            _selectedFormation = selectedItem;
                                            isSelectFormation=true;
                                            if (_selectedFormation < formationsList.length) {
                                              fetchNiveaus(
                                                  formationsList[_selectedFormation])
                                                  .then((nom) {
                                                setState(() {
                                                  niveausList = nom;
                                                  print(niveausList);
                                                });
                                              });
                                            }

                                          });

                                        },
                                        children: List<Widget>.generate(
                                          formationsList.length,
                                              (int index) {
                                            return Center(
                                                child: Text(
                                                    formationsList[index]));
                                          },
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  _selectedFormation < formationsList.length
                                      ? formationsList[_selectedFormation]
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible:isSelectFormation==true,
                          child: Row(
                            children: [
                              const Text(
                                'Niveau: ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    _showDialog(
                                      CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        scrollController: FixedExtentScrollController(
                                          initialItem: _selectedNiveau,
                                        ),
                                        onSelectedItemChanged: (
                                            int selectedItem) {
                                          setState(() {
                                            _selectedNiveau = selectedItem;
                                            isSelectNiveau=true;
                                            if (_selectedNiveau < niveausList.length) {
                                              fetchSemestres(
                                                  niveausList[_selectedNiveau])
                                                  .then((nom) {
                                                setState(() {
                                                  semestresList = nom;
                                                });
                                              });
                                            }
                                          });
                                        },
                                        children: List<Widget>.generate(
                                          niveausList.length,
                                              (int index) {
                                            return Center(
                                                child: Text(
                                                    niveausList[index]));
                                          },
                                        ),
                                      ),
                                    ),
                                child: Text(
                                  _selectedNiveau < niveausList.length
                                      ? niveausList[_selectedNiveau]
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Visibility(
                        visible:isSelectNiveau==true,
                        child: Row(
                          children: [
                            const Text(
                              'Semestre: ',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedSemestre,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {
                                        setState(() {
                                          _selectedSemestre = selectedItem;
                                          isSelectSemestre=true;
                                          if (_selectedSemestre < semestresList.length) {
                                            fetchFilieres(
                                                semestresList[_selectedSemestre])
                                                .then((nom) {
                                              setState(() {
                                                filieresList = nom;
                                              });
                                            });
                                          }
                                        });
                                      },
                                      children: List<Widget>.generate(
                                        semestresList.length,
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  semestresList[index]));
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedSemestre < semestresList.length
                                    ? semestresList[_selectedSemestre]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:isSelectSemestre==true,
                        child: Row(
                          children: [
                            const Text(
                              'Filiere: ',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedFiliere,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {
                                        setState(() {
                                          _selectedFiliere = selectedItem;
                                          widget.nomfil=filieresList[_selectedFiliere];
                                          print('-----------------------------------');
                                          print(widget.nomfil);
                                          print('-----------------------------------');
                                          isSelectFiliere=true;
                                          // if (_selectedSemestre < semestresList.length) {
                                          //   fetchFilieres(
                                          //       semestresList[_selectedSemestre])
                                          //       .then((nom) {
                                          //     setState(() {
                                          //       filieresList = nom;
                                          //     });
                                          //   });
                                          // }
                                        });
                                      },
                                      children: List<Widget>.generate(
                                        filieresList.length,
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  filieresList[index]));
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedFiliere < filieresList.length
                                    ? filieresList[_selectedFiliere]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:isSelectFiliere==true,
                        child: Row(
                          children: [
                            const Text(
                              'Choix: ',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedChoix,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {
                                        setState(() {
                                          _selectedChoix = selectedItem;
                                          isSelectScolarite=true;

                                        });
                                      },
                                      children: List<Widget>.generate(
                                        choixList.length,
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  choixList[index]));
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedChoix < choixList.length
                                    ? choixList[_selectedChoix]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:choixList[_selectedChoix] == 'Scolarité' && isSelectScolarite==true,
                        child: Row(
                          children: [
                            const Text(
                              'Scolarité:',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedScolarite,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {
                                        setState(() {
                                          _selectedScolarite = selectedItem;
                                        });
                                      },
                                      children: List<Widget>.generate(
                                        scolariteList.length,
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  scolariteList[index]));
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedScolarite < scolariteList.length
                                    ? scolariteList[_selectedScolarite]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:choixList[_selectedChoix] == 'Surveillance' && isSelectScolarite==true,
                        child: Row(
                          children: [
                            const Text(
                              'Surveillance:',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () =>
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      scrollController: FixedExtentScrollController(
                                        initialItem: _selectedSurveillance,
                                      ),
                                      onSelectedItemChanged: (
                                          int selectedItem) {
                                        setState(() {
                                          _selectedSurveillance = selectedItem;
                                        });
                                      },
                                      children: List<Widget>.generate(
                                        suveillanceList.length,
                                            (int index) {
                                          return Center(
                                              child: Text(
                                                  suveillanceList[index]));
                                        },
                                      ),
                                    ),
                                  ),
                              child: Text(
                                _selectedSurveillance < suveillanceList.length
                                    ? suveillanceList[_selectedSurveillance]
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                          child: Text(
                            'Suivant',
                            style: TextStyle(fontSize: 22.0),
                          ),
                          onPressed: () => _onSubmit(context),
                        ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        break;
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 5),
          child: Card(
            elevation: 10,
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.white),
            ),
            child: InkWell(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => child_widget,
                //   ),
                // );
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icondata,

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    select,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
