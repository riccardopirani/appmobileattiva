import 'dart:io';

import 'package:appattiva/Controller/Utente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';

import 'Model/Utente.dart';
import 'Utils/support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

              // Password dimenticata
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Password dimenticata?',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ACCEDI
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

                    Utente u=new Utente.init(0,"","");
                    bool valid=(await u.login(email, password));
                    if (valid==true) {
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

  // Input border con ombra
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

  @override
  void initState() {
    super.initState();
    caricaNome();
  }

  Future<void> caricaNome() async {
    final nome = await Storage.leggi("Nome");
    final cognome = await Storage.leggi("Cognome");
    print(nome);
    print(cognome);

    setState(() {
      nomeCompleto = '$nome $cognome';
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
                            const Text("Utente", style: TextStyle(color: Colors.grey)),
                            Text(
                              nomeCompleto.isNotEmpty ? nomeCompleto : 'Caricamento...',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.home, color: Colors.green, size: 32),
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
                                children: [
                                  DayHeader("lun. 26 maggio"),
                                  DayHeader("mar. 27 maggio"),
                                  DayHeader("mer. 28 maggio"),
                                  DayHeader("gio. 29 maggio"),
                                  DayHeader("ven. 30 maggio"),
                                  DayHeader("sab. 31 maggio", highlight: true),
                                  DayHeader("dom. 1 giugno", highlight: true),
                                ],
                              ),
                              const TableRow(
                                children: [
                                  DayCell("Cod. 361\nBunge"),
                                  DayCell("Cod. 362\nPir"),
                                  DayCell("Cod. 361\nBunge"),
                                  DayCell("Cod. 362\nPir"),
                                  DayCell("Cod. 362\nPir"),
                                  DayCell("", isRed: true),
                                  DayCell("", isRed: true),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sezione scelta cantiere
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

                  const DropdownField(icon: Icons.qr_code, label: "Cod."),
                  const SizedBox(height: 10),
                  const DropdownField(icon: Icons.person, label: "Cliente"),
                  const SizedBox(height: 10),
                  const DropdownField(
                      icon: Icons.location_searching, label: "Indirizzo"),
                  const SizedBox(height: 16),

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SiteDetailScreen()),
                        );
                      },
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

class SiteDetailScreen extends StatelessWidget {
  const SiteDetailScreen({super.key});

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
                    // eventualmente aggiungi logica per verbale
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Azione per Verbale non ancora implementata")),
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
                      null, // disattivato perché gestito da PopupMenuButton
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  label: const Text(
                    "AGGIUNGI...",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);

                  if (image != null) {
                    File photo = File(image.path);
                    // Qui puoi gestire l'immagine scattata (es. salvarla, mostrarla, ecc.)
                    print("Foto scattata: ${photo.path}");
                  } else {
                    print("Nessuna foto scattata.");
                  }
                },
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
            // Header Utente
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
                    children: const [
                      Text("Utente", style: TextStyle(color: Colors.grey)),
                      Text("Paolo Alberti Pezzoli",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.home, color: Colors.green, size: 32),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Cod. 365 Bunge S.p.a. Via Baiona 237 «Silo»",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            // Mappa
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FlutterMap(
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.yourapp',
                      ),
                    ],
                  )),
            ),

            const SizedBox(height: 30),

            // Pulsanti Archivio
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                children: const [
                  ArchiveButton(
                      icon: Icons.list_alt, label: "Archivio rapportini"),
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

  final List<String> dropdownOptions = [
    'Operatore 1',
    'Operatore 2',
    'Operatore 3'
  ];

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
            onPressed: () {},
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
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Rapportino del",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const SizedBox(height: 10),
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

          // Sezioni
          RapportinoSection(
            title: "Attiv.A",
            color: Colors.green,
            operatorLabel: "OPERATORE 1",
            selectedValue: selectedAttiva,
            onChanged: (val) => setState(() => selectedAttiva = val),
            dropdownItems: dropdownOptions,
          ),
          RapportinoSection(
            title: "Manodopera",
            color: Colors.orange,
            operatorLabel: "OPERATORE 1",
            selectedValue: selectedManodopera,
            onChanged: (val) => setState(() => selectedManodopera = val),
            dropdownItems: dropdownOptions,
          ),
          RapportinoSection(
            title: "Aziende",
            color: Colors.blue,
            operatorLabel: "AZIENDA 1",
            selectedValue: selectedAzienda,
            onChanged: (val) => setState(() => selectedAzienda = val),
            dropdownItems: dropdownOptions,
          ),
          RapportinoSection(
            title: "Noleggio",
            color: Colors.purple,
            operatorLabel: "NOLEGGIATORE 1",
            selectedValue: selectedNoleggio,
            onChanged: (val) => setState(() => selectedNoleggio = val),
            dropdownItems: dropdownOptions,
            showHoursField: false,
          ),
        ],
      ),
    );
  }
}

class RapportinoSection extends StatelessWidget {
  final String title;
  final Color color;
  final String operatorLabel;
  final bool showHoursField;
  final List<String> dropdownItems;
  final String? selectedValue;
  final void Function(String?) onChanged;

  const RapportinoSection({
    super.key,
    required this.title,
    required this.color,
    required this.operatorLabel,
    required this.dropdownItems,
    required this.selectedValue,
    required this.onChanged,
    this.showHoursField = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etichetta
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(operatorLabel.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    onChanged: onChanged,
                    items: dropdownItems
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 10),
                if (showHoursField)
                  const SizedBox(
                    width: 120,
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Ore lavorate'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
              ],
            ),
          ),

          // Riga descrizione
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: const [
                SizedBox(
                    width: 60,
                    child: TextField(
                        decoration: InputDecoration(labelText: "ORE"),
                        keyboardType: TextInputType.number)),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
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
                    title == "Attiv.A"
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
                onPressed: () {}, // Potresti aprire un altro dropdown qui
                icon: const Icon(Icons.add_circle, color: Colors.black45),
                label: Text("AGGIUNGI ${title.toUpperCase()}",
                    style: const TextStyle(color: Colors.black45)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
