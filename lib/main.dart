import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo Virtual',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}

/// Pantalla de Inicio
class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido a mi catálogo virtual",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Ingresar"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CatalogoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Pantalla de Catálogo
class CatalogoPage extends StatelessWidget {
  const CatalogoPage({super.key});

  Future<String> _cargarDescripcion(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Catálogo"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Damas"),
              Tab(text: "Caballeros"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab("assets/descripcion_damas.txt"),
            _buildTab("assets/descripcion_caballeros.txt"),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Regresar al inicio"),
            ),
          ),
        ),
      ),
    );
  }

  /// Construye cada pestaña mostrando solo la descripción desde el archivo .txt
  Widget _buildTab(String textPath) {
    return FutureBuilder<String>(
      future: _cargarDescripcion(textPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final descripcion = snapshot.data ?? "Descripción no disponible.";
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Descripción cargada desde archivo .txt"),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(descripcion, style: const TextStyle(fontSize: 16)),
            ),
          ),
        );
      },
    );
  }
}
