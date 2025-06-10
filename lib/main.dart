import 'dart:io';
import 'dart:typed_data';
import 'dart:ui'
    as ui; // Necessario per ui.Image, ui.Canvas, ui.PictureRecorder

import 'package:appattiva/Controller/Attivita.dart';
import 'package:appattiva/Model/RisorseUmane.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Controller/RisorseUmane.dart';
import 'Model/Cantiere.dart';
import 'Model/Tipologia.dart';
import 'Model/Utente.dart';
import 'Utils/support.dart';

List<DateTime> getWeekDates() {
  final now = DateTime.now();
  final monday = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(7, (i) => monday.add(Duration(days: i)));
}

String formatDate(DateTime date) {
  final giorni = ["lun.", "mar.", "mer.", "gio.", "ven.", "sab.", "dom."];
  final mesi = [
    "gennaio",
    "febbraio",
    "marzo",
    "aprile",
    "maggio",
    "giugno",
    "luglio",
    "agosto",
    "settembre",
    "ottobre",
    "novembre",
    "dicembre"
  ];
  return "${giorni[date.weekday - 1]} ${date.day} ${mesi[date.month - 1]}";
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attiva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3), // colore sfondo chiaro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.attivacostruzioni.it/wp-content/uploads/2020/10/logo-footer-bianco.png',
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'E-mail',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.email, color: Colors.green),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  border: _inputBorder(),
                  enabledBorder: _inputBorder(),
                  focusedBorder: _inputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'info@attivacostruzioni.com',
                      query: Uri.encodeFull(
                          'subject=Recupero password&body=Salve, ho dimenticato la password del mio account.'),
                    );

                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    } else {
                      // Optional: mostra un messaggio di errore all'utente
                      print('Impossibile aprire il client email.');
                    }
                  },
                  child: const Text(
                    'Password dimenticata?',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B050),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text;

                    Utente u = new Utente.init(0, "", "");
                    bool valid = (await u.login(email, password));
                    if (valid == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeeklyOverviewScreen(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Accesso negato'),
                            content:
                                const Text('E-mail o password non validi.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Chiude il dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    'ACCEDI',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }
}

class WeeklyOverviewScreen extends StatefulWidget {
  const WeeklyOverviewScreen({super.key});

  @override
  State<WeeklyOverviewScreen> createState() => _WeeklyOverviewScreenState();
}

class _WeeklyOverviewScreenState extends State<WeeklyOverviewScreen> {
  String nomeCompleto = '';
  List<Cantiere> cantieriList = [];
  List<Cantiere> filteredCantieri = [];
  String? selectedCod;
  String? selectedCliente;
  String? idCantiere;
  String? selectedIndirizzo;
  bool isButtonEnabled = false;
  List<dynamic> attivitaSettimana = [];
  @override
  void initState() {
    super.initState();
    caricaDati();
  }

  Future<void> caricaDati() async {
    await Future.wait([
      caricaNome(),
      caricaCantieri(),
    ]);
  }

  Future<void> caricaNome() async {
    final nome = await Storage.leggi("Nome");
    final cognome = await Storage.leggi("Cognome");

    setState(() {
      nomeCompleto = '$nome $cognome';
    });
  }

  Future<void> caricaCantieri() async {
    final utente = Utente.init(0, "", "");
    final cantieri = await Cantiere.ricerca(utente, 0, '', '', true, 0);
    final idUtenteCorrente = await Storage.leggi("IdUtente");

    List<dynamic> tutteLeAttivita = await AttivitaController.caricaAttivita();
    List<dynamic> attivitaUtente = tutteLeAttivita.where((attivita) {
      return attivita["IdUtente"].toString() == idUtenteCorrente.toString();
    }).toList();

    // Associa il NomeCantiere a ciascuna attività utente
    for (var attivita in attivitaUtente) {
      int? idCantiereAttivita = attivita["IdCantiere"];
      var cantiereAssociato = cantieri.firstWhere(
        (c) => c.getIdCantiere() == idCantiereAttivita,
      );

      if (cantiereAssociato != null) {
        attivita["Descrizione"] = cantiereAssociato.getNomeCantiere();
      } else {
        attivita["Descrizione"] = "Cantiere sconosciuto";
      }
    }

    print("Attività utente con NomeCantiere:");
    print(attivitaUtente);

    setState(() {
      cantieriList = cantieri;
      filteredCantieri = cantieri;
      attivitaSettimana = attivitaUtente;
    });
  }

  void filterCantieri() {
    int idCantiereSelected = 0;
    setState(() {
      filteredCantieri = cantieriList.where((cantiere) {
        final matchCod = selectedCod == null ||
            cantiere.getNomeCantiere().toString() == selectedCod;
        final matchCliente = selectedCliente == null ||
            cantiere.getCliente()!.getRagioneSociale().toString() ==
                selectedCliente;
        final matchIndirizzo = selectedIndirizzo == null ||
            cantiere.getIndirizzo() == selectedIndirizzo;
        idCantiereSelected = cantiere.getIdCantiere()!;
        return matchCod && matchCliente && matchIndirizzo;
      }).toList();
      isButtonEnabled = selectedCod != null &&
          selectedCliente != null &&
          selectedIndirizzo != null;
      if (isButtonEnabled == true) {
        Storage.salva("IdCantiereSelected", idCantiereSelected.toString());
        Storage.salva("selectedCod", selectedCod!);
        Storage.salva("selectedIndirizzo", selectedIndirizzo!);
        Storage.salva("selectedCliente", selectedCliente!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Header utente
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              'https://www.attivacostruzioni.it/wp-content/uploads/2020/10/logo-footer-bianco.png'),
                        ),
                        const SizedBox(width: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Utente",
                                style: TextStyle(color: Colors.grey)),
                            Text(
                              nomeCompleto.isNotEmpty
                                  ? nomeCompleto
                                  : 'Caricamento...',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.home,
                              color: Colors.green, size: 32),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.network(
                      'https://www.attivacostruzioni.it/wp-content/uploads/2020/10/logo-footer-bianco.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // La mia settimana
                  Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        const Text("LA MIA SETTIMANA",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            border:
                                TableBorder.all(color: Colors.grey.shade400),
                            defaultColumnWidth: IntrinsicColumnWidth(),
                            children: [
                              TableRow(
                                children: getWeekDates()
                                    .map((d) => DayHeader(
                                          formatDate(d),
                                          highlight: d.weekday >=
                                              6, // sabato e domenica
                                        ))
                                    .toList(),
                              ),
                              TableRow(
                                children: getWeekDates().map((d) {
                                  final attivitaDelGiorno =
                                      attivitaSettimana.where((a) {
                                    final data = DateTime.tryParse(
                                        a['DataInizio'] ?? '');
                                    return data != null &&
                                        data.year == d.year &&
                                        data.month == d.month &&
                                        data.day == d.day;
                                  }).toList();

                                  final descrizione =
                                      attivitaDelGiorno.isNotEmpty
                                          ? (attivitaDelGiorno
                                                  .first['Descrizione'] ??
                                              'Attività')
                                          : '';

                                  return DayCell(
                                    descrizione.isNotEmpty
                                        ? "Cod. " + descrizione
                                        : 'Nessuna attività',
                                    isRed: d.weekday >= 6,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "SCEGLI IL CANTIERE!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dropdown per Cod
                  DropdownButton<String>(
                    value: selectedCod,
                    hint: Text("Cod."),
                    onChanged: (value) {
                      setState(() {
                        selectedCod = value;
                        filterCantieri();
                      });
                    },
                    items: cantieriList
                        .map((cantiere) => DropdownMenuItem<String>(
                              value: cantiere.getNomeCantiere().toString(),
                              child:
                                  Text(cantiere.getNomeCantiere().toString()),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Dropdown per Cliente
                  DropdownButton<String>(
                    value: selectedCliente,
                    hint: Text("Cliente"),
                    onChanged: (value) {
                      setState(() {
                        selectedCliente = value;
                        filterCantieri();
                      });
                    },
                    items: cantieriList
                        .map((cantiere) => DropdownMenuItem<String>(
                              value: cantiere.c.getRagioneSociale(),
                              child: Text(cantiere.c.getRagioneSociale() ?? ''),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),

                  // Dropdown per Indirizzo
                  DropdownButton<String>(
                    value: selectedIndirizzo,
                    hint: Text("Indirizzo"),
                    onChanged: (value) {
                      setState(() {
                        selectedIndirizzo = value;
                        filterCantieri();
                      });
                    },
                    items: cantieriList
                        .map((cantiere) => DropdownMenuItem<String>(
                              value: cantiere.getIndirizzo(),
                              child: Text(cantiere.getIndirizzo() ?? ''),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Bottone "ENTRA"
                  SizedBox(
                    width: MediaQuery.of(context).size.width < 400
                        ? double.infinity
                        : 150,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: isButtonEnabled
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SiteDetailScreen()),
                              );
                            }
                          : null,
                      child: const Text("ENTRA",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayHeader extends StatelessWidget {
  final String label;
  final bool highlight;

  const DayHeader(this.label, {super.key, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: highlight ? Colors.red.shade100 : Colors.white,
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: highlight ? Colors.red : Colors.black)),
      ),
    );
  }
}

class ArchivioRapportiniScreen extends StatefulWidget {
  final int idCantiere;

  const ArchivioRapportiniScreen({super.key, required this.idCantiere});

  @override
  State<ArchivioRapportiniScreen> createState() =>
      _ArchivioRapportiniScreenState();
}

class _ArchivioRapportiniScreenState extends State<ArchivioRapportiniScreen> {
  List<RisorseUmane> risorseInserite = [];

  @override
  void initState() {
    super.initState();
    caricaRisorseCantiere();
  }

  Future<void> caricaRisorseCantiere() async {
    final List<RisorseUmane> risultati =
        await RisorseUmane.caricarisorseumanecantiere(widget.idCantiere);
    print(risultati);
    setState(() {
      risorseInserite = risultati;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Archivio Rapportini"),
        backgroundColor: Colors.green,
      ),
      body: risorseInserite.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: risorseInserite.length,
              itemBuilder: (context, index) {
                final r = risorseInserite[index];
                return ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: Text("Data: ${r.getData()}"),
                  subtitle: Text("Risorsa: ${r.getNome()} ${r.getCognome()}"
                      "\nData: ${r.getData()}"
                      "\nDescrizione: ${r.getDescrizione()}"
                      "\nOre: ${r.getTotaleOre().substring(14, 16)}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
            ),
    );
  }
}

class DayCell extends StatelessWidget {
  final String content;
  final bool isRed;

  const DayCell(this.content, {super.key, this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: isRed ? Colors.red : Colors.white,
      child: Center(
        child: Text(content,
            textAlign: TextAlign.center,
            style: TextStyle(color: isRed ? Colors.white : Colors.black)),
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final IconData icon;
  final String label;

  const DropdownField({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      items: const [
        DropdownMenuItem(value: "1", child: Text("Seleziona")),
      ],
      onChanged: (value) {},
    );
  }
}

class SiteDetailScreen extends StatefulWidget {
  const SiteDetailScreen({super.key});

  @override
  _SiteDetailScreenState createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen> {
  String selectedCod = '';
  String selectedIndirizzo = '';
  String selectedCliente = '';
  String nome = '';
  String cognome = '';
  String userFullName = '';
  String addressString = '';

  double latitude = 37.42796133580664;
  double longitude =
      -122.085749655962; // Example coordinates (you can update it dynamically)
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    loadAddressData();
  }

  Future<void> loadAddressData() async {
    final cod = await Storage.leggi("selectedCod");
    final indirizzo = await Storage.leggi("selectedIndirizzo");
    final cliente = await Storage.leggi("selectedCliente");
    final userNome = await Storage.leggi("Nome");
    final userCognome = await Storage.leggi("Cognome");

    setState(() {
      selectedCod = cod ?? '';
      selectedIndirizzo = indirizzo ?? '';
      selectedCliente = cliente ?? '';
      nome = userNome ?? '';
      cognome = userCognome ?? '';
      userFullName = '$nome $cognome';
      addressString = '$selectedCod $selectedCliente $selectedIndirizzo';

      // Sovrascrivi lat/lng se necessario qui
      latitude = 37.42796133580664;
      longitude = -122.085749655962;
    });

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.google.com/maps?q=$latitude,$longitude'),
      );

    setState(() {}); // Triggera il rebuild con il controller pronto
  }

  // Function to pick an image using the camera
  Future<void> takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File photo = File(image.path);
      // Handle the captured photo here (e.g., store or display)
      print("Foto scattata: ${photo.path}");
    } else {
      print("Nessuna foto scattata.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFF3F3F3),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rapportino') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RapportinoScreen()),
                    );
                  } else if (value == 'verbale') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerbaleScreen()),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'rapportino',
                    child: Text('Rapportino'),
                  ),
                  const PopupMenuItem(
                    value: 'verbale',
                    child: Text('Verbale'),
                  ),
                ],
                child: TextButton.icon(
                  onPressed:
                      null, // Disabled because it's handled by PopupMenuButton
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  label: const Text(
                    "AGGIUNGI...",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: takePhoto, // Opens the camera
                icon: const Icon(Icons.photo_camera, color: Colors.green),
                label: const Text(
                  "SCATTA FOTO",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      'https://www.attivacostruzioni.it/wp-content/uploads/2020/10/logo-footer-bianco.png',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Utente",
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        userFullName, // Displaying the full name of the user
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.green, size: 32),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                addressString, // Display the concatenated address string
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _webViewController != null
                  ? WebViewWidget(controller: _webViewController)
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                children: [
                  GestureDetector(
                    onTap: () async {
                      final idCantiere =
                          await Storage.leggi("IdCantiereSelected");
                      if (idCantiere != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArchivioRapportiniScreen(
                                idCantiere: int.parse(idCantiere)),
                          ),
                        );
                      }
                    },
                    child: ArchiveButton(
                      icon: Icons.list_alt,
                      label: "Archivio rapportini",
                    ),
                  ),
                  SizedBox(height: 16),
                  ArchiveButton(icon: Icons.photo, label: "Galleria foto"),
                  SizedBox(height: 16),
                  ArchiveButton(
                      icon: Icons.description, label: "Archivio verbali"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerbaleScreen extends StatefulWidget {
  const VerbaleScreen({super.key});

  @override
  State<VerbaleScreen> createState() => _VerbaleScreenState();
}

class _VerbaleScreenState extends State<VerbaleScreen> {
  List<Widget> punti = [buildPunto(1)];
  final ScreenshotController screenshotController = ScreenshotController();
  static Widget buildPunto(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Punto $index:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 16)),
        SizedBox(height: 8),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: Colors.grey.shade100,
            filled: true,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void aggiungiPunto() {
    setState(() {
      punti.add(buildPunto(punti.length + 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VERBALE DI CANTIERE')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔽 Screenshot solo della parte che interessa
            Screenshot(
              controller: screenshotController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/uiweb.jpg"),
                  Row(children: [
                    Expanded(
                        child: TextField(
                            decoration:
                                InputDecoration(labelText: 'VERBALE N°'))),
                    SizedBox(width: 16),
                    Expanded(
                        child: TextField(
                            decoration: InputDecoration(labelText: 'Data')))
                  ]),
                  TextField(decoration: InputDecoration(labelText: 'Codice')),
                  TextField(
                      decoration:
                          InputDecoration(labelText: 'Indirizzo cantiere')),
                  TextField(
                      decoration: InputDecoration(labelText: 'Tipo appalto')),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Column(children: [
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'Committente Nome')),
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'Committente Mail'))
                      ])),
                      SizedBox(width: 16),
                      Expanded(
                          child: Column(children: [
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'D.L. Nome')),
                        TextField(
                            decoration: InputDecoration(labelText: 'D.L. Mail'))
                      ])),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(children: [
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'Progettista Nome')),
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'Progettista Mail'))
                      ])),
                      SizedBox(width: 16),
                      Expanded(
                          child: Column(children: [
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'C.S.E. Nome')),
                        TextField(
                            decoration:
                                InputDecoration(labelText: 'C.S.E. Mail'))
                      ])),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                      decoration:
                          InputDecoration(labelText: 'Presenti in cantiere')),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                      label: Text('AGGIUNGI PRESENTE'),
                    ),
                  ),
                  SizedBox(height: 16),
                  ...punti,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: aggiungiPunto,
                      icon: Icon(Icons.add, color: Colors.green),
                      label: Text('AGGIUNGI PUNTO',
                          style: TextStyle(color: Colors.green)),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),

            /// 🔽 Pulsante FIRMA fuori dallo Screenshot
            ElevatedButton(
              onPressed: () async {
                final image = await screenshotController.capture();
                if (image != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignatureScreen(backgroundImage: image),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('FIRMA'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchiveButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ArchiveButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(
              fontSize: 18, color: Colors.green, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class SignatureScreen extends StatefulWidget {
  final Uint8List backgroundImage;

  SignatureScreen({required this.backgroundImage});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller =
      SignatureController(penStrokeWidth: 3, penColor: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firma sull'immagine")),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.memory(
              widget.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Signature(
            controller: _controller,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ui.Image? signatureImage = await _controller.toImage();
          if (signatureImage != null) {
            final Uint8List merged =
                await mergeImages(widget.backgroundImage, signatureImage);
            final directory = await getApplicationDocumentsDirectory();
            final path = '${directory.path}/firma_salvata.png';
            final file = File(path);
            await file.writeAsBytes(merged);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Firma salvata in: $path')));
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<Uint8List> mergeImages(
      Uint8List bgBytes, ui.Image signatureImage) async {
    final ui.Image bgImage = await decodeImageFromList(bgBytes);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Disegna background
    canvas.drawImage(bgImage, Offset.zero, Paint());

    // Disegna firma
    canvas.drawImage(signatureImage, Offset.zero, Paint());

    // Converti a immagine
    final picture = recorder.endRecording();
    final ui.Image finalImage =
        await picture.toImage(bgImage.width, bgImage.height);
    final ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class RapportinoScreen extends StatefulWidget {
  const RapportinoScreen({super.key});

  @override
  State<RapportinoScreen> createState() => _RapportinoScreenState();
}

class _RapportinoScreenState extends State<RapportinoScreen> {
  String? selectedAttiva;
  String? selectedManodopera;
  String? selectedAzienda;
  String? selectedNoleggio;

  List<RisorseUmane> risorse = [];

  @override
  void initState() {
    super.initState();
    caricaRisorse();
  }

  Future<void> caricaRisorse() async {
    List<RisorseUmane> lista = await RisorseUmaneController.carica();
    setState(() {
      risorse = lista;
    });
  }

  final List<String> dropdownOptions = [
    'Operatore 1',
    'Operatore 2',
    'Operatore 3'
  ];

  List<String> buildDropdownNames() {
    return risorse.map((risorsa) {
      return "${risorsa.getNome()} ${risorsa.getCognome()}";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: const Text('SALVA',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          const Text("Rapportino del",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 3)
              ],
            ),
            child: const Text("Data del giorno preimpostata. Ma modificabile."),
          ),
          const SizedBox(height: 20),
          RapportinoSection(
            title: "Attiv.A",
            color: Colors.green,
            risorse: risorse,
            dropdownItems: buildDropdownNames(), // <-- dinamico
          ),
          RapportinoSection(
            title: "Manodopera",
            color: Colors.orange,
            risorse: risorse,
            dropdownItems: buildDropdownNames(), // <-- dinamico
          ),
          RapportinoSection(
            title: "Aziende",
            color: Colors.blue,
            risorse: risorse,
            dropdownItems: buildDropdownNames(), // <-- dinamico
          ),
          RapportinoSection(
            title: "Noleggio",
            color: Colors.purple,
            risorse: risorse,
            dropdownItems: buildDropdownNames(), // <-- dinamico
          ),
        ],
      ),
    );
  }
}

class RapportinoSection extends StatefulWidget {
  final String title;
  final Color color;
  final List<String> dropdownItems;
  final String? initialValue;
  final bool showHoursField;
  final List<RisorseUmane> risorse;

  const RapportinoSection({
    super.key,
    required this.title,
    required this.color,
    required this.dropdownItems,
    required this.risorse, // <-- aggiunto
    this.initialValue,
    this.showHoursField = true,
  });

  @override
  State<RapportinoSection> createState() => _RapportinoSectionState();
}

String formatToHHMM(String input) {
  // Rimuove caratteri non numerici
  String digits = input.replaceAll(RegExp(r'\D'), '');

  // Limita a 4 cifre
  if (digits.length > 4) {
    digits = digits.substring(0, 4);
  }

  // Aggiunge zeri a sinistra se necessario
  digits = digits.padLeft(4, '0');

  // Separa ore e minuti
  String hh = digits.substring(0, 2);
  String mm = digits.substring(2, 4);

  return '$hh:$mm';
}

String dataCorrenteSqlFormat(String ore) {
  final now = DateTime.now();

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String year = now.year.toString();
  String month = twoDigits(now.month);
  String day = twoDigits(now.day);
  String hour = ore;
  String minute = "00";
  String second = twoDigits(now.second);

  return "$year-$month-$day $hour:$minute:$second";
}

class _RapportinoSectionState extends State<RapportinoSection> {
  String? selectedValue;
  final TextEditingController oreController = TextEditingController();
  final TextEditingController descrizioneController = TextEditingController();

  @override
  void dispose() {
    oreController.dispose();
    descrizioneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etichetta operatore selezionato
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              (selectedValue ?? "Operatore").toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Selettore operatore + ore
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Da elenco'),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    items: widget.dropdownItems
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),

          // Riga descrizione
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                SizedBox(
                    width: 60,
                    child: TextField(
                        controller: oreController,
                        decoration: InputDecoration(labelText: "ORE"),
                        keyboardType: TextInputType.number)),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                        controller: descrizioneController,
                        decoration: InputDecoration(labelText: "DESCRIZIONE"))),
                SizedBox(width: 10),
                Icon(Icons.add),
              ],
            ),
          ),

          // Fotografa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.photo_camera, color: Colors.black54),
                const SizedBox(width: 8),
                Text(
                    widget.title == "Attiv.A"
                        ? "Fotografa DDT"
                        : "Fotografa documento",
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          // Bottone aggiungi
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: TextButton.icon(
                onPressed: () async {
                  List<Tipologia> tp = await Tipologia.caricaTipoligie();

                  Tipologia? tipSelezionata = tp.firstWhere(
                    (t) => t.getNomeTipologia() == widget.title,
                  );

                  RisorseUmane? user = widget.risorse.firstWhere(
                    (t) => "${t.getNome()} ${t.getCognome()}" == selectedValue,
                  );
                  print("idUtente: ${user.getIdUtente()}");

                  if (tipSelezionata != null && user.getIdUtente() != null) {
                    int idTipologia = tipSelezionata.getIdTipologia();
                    String utente =
                        selectedValue ?? "Nessun utente selezionato";
                    String ore = formatToHHMM(oreController.text.trim());
                    String descrizione = descrizioneController.text.trim();
                    print(
                        "IdTipologia: ${idTipologia}ore: $ore descizione: $descrizione utente: $utente");
                    print(
                        'Tipologia selezionata: ID = ${tipSelezionata.getIdTipologia()}, Nome = ${tipSelezionata.getNomeTipologia()}');
                    int idCantiere =
                        int.parse(await Storage.leggi("IdCantiereSelected"));

                    RisorseUmane.inserimentoCantiere(
                        idCantiere,
                        idTipologia.toString(),
                        user.getIdUtente().toString(),
                        idCantiere.toString(),
                        dataCorrenteSqlFormat(ore),
                        dataCorrenteSqlFormat(ore),
                        dataCorrenteSqlFormat(ore),
                        descrizione,
                        0);
                  } else {
                    print('⚠️ Nessuna tipologia trovata per "${widget.title}"');
                  }

                  print(widget.title);
                  if (widget.title == 'Attiv.A') {
                    print("sono in attiva");
                  } else if (widget.title == 'Manodopera') {
                    print("sono in mano");
                  } else if (widget.title == 'Aziende') {
                    print("sono in aziende");
                  } else {
                    print("sono in noleggio");
                  }
                }, // Aggiungi funzionalità se serve
                icon: const Icon(Icons.add_circle, color: Colors.black45),
                label: Text("AGGIUNGI ${widget.title.toUpperCase()}",
                    style: const TextStyle(color: Colors.black45)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
