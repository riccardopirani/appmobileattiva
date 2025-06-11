import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'Controller/Verbale.dart';

class ArchivioVerbaliScreen extends StatefulWidget {
  final int idCantiere;

  const ArchivioVerbaliScreen({super.key, required this.idCantiere});

  @override
  State<ArchivioVerbaliScreen> createState() => _ArchivioVerbaliScreenState();
}

class _ArchivioVerbaliScreenState extends State<ArchivioVerbaliScreen> {
  List<dynamic> verbali = [];

  @override
  void initState() {
    super.initState();
    caricaVerbali();
  }

  Future<void> caricaVerbali() async {
    final List<dynamic> risultati =
        await VerbaleController.caricaVerbali(widget.idCantiere);
    setState(() {
      verbali = risultati;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color green = const Color(0xFF00B050); // tono verde Airbnb-like

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: green,
        title: const Text("Archivio Verbali",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: verbali.isEmpty
          ? const Center(
              child: Text("Nessun verbale presente",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: verbali.length,
              itemBuilder: (context, index) {
                final verbale = verbali[index];
                return GestureDetector(
                  onTap: () {
                    final base64 = verbale["Documento"];
                    if (base64 != null && base64 is String) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VisualizzaVerbaleScreen(base64Image: base64),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Errore: immagine verbale non disponibile")),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.description, color: Color(0xFF00B050)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Verbale ${index + 1}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text("Cantiere ID: ${widget.idCantiere}",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class VisualizzaVerbaleScreen extends StatefulWidget {
  final String base64Image;

  const VisualizzaVerbaleScreen({super.key, required this.base64Image});

  @override
  State<VisualizzaVerbaleScreen> createState() =>
      _VisualizzaVerbaleScreenState();
}

class _VisualizzaVerbaleScreenState extends State<VisualizzaVerbaleScreen> {
  final TransformationController _controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    final Uint8List imageBytes = base64Decode(widget.base64Image);
    final Color green = const Color(0xFF00B050);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: green,
        elevation: 0,
        title: const Text("Visualizza Verbale",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map),
            tooltip: "Reset zoom",
            onPressed: () => _controller.value = Matrix4.identity(),
          )
        ],
      ),
      body: InteractiveViewer(
        transformationController: _controller,
        panEnabled: true,
        scaleEnabled: true,
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: Image.memory(imageBytes),
        ),
      ),
    );
  }
}
