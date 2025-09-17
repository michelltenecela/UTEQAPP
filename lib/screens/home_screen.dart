import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// 🔹 Modelo de datos
class ItemData {
  final int id;
  final String name;
  final String image;
  final String description;
  final String url;

  const ItemData({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.url,
  });
}

// 🔹 Listas de datos (apps, software y redes sociales)
const appsData = [
  ItemData(
    id: 1,
    name: 'ComuniKids',
    image: 'assets/images/qr_comunikids.png',
    description: 'Aplicación educativa para comunicación infantil',
    url: 'https://play.google.com/store/apps/details?id=com.appvinculacion',
  ),
  ItemData(
    id: 2,
    name: 'MoneyGame',
    image: 'assets/images/qr_moneygame.png',
    description: 'Juego educativo sobre manejo financiero',
    url: 'https://play.google.com/store/apps/details?id=com.DefaultCompany.MoneyGame&pli=1',
  ),
  ItemData(
    id: 3,
    name: 'PetFriend',
    image: 'assets/images/qr_petfriend.png',
    description: 'Aplicación para el cuidado de mascotas virtuales',
    url: 'https://play.google.com/store/apps/details?id=com.UTEQ.PetFriend21',
  ),
];

const softwData = [
  ItemData(
    id: 1,
    name: 'Ingeniería en Software',
    image: 'assets/images/qr_info_softw.png',
    description: 'Información sobre desarrollo de software en UTEQ',
    url: 'https://www.uteq.edu.ec/es/grado/carrera/software',
  ),
];

const socialData = [
  ItemData(
    id: 1,
    name: 'Facebook UTEQ',
    image: 'assets/images/qr_facebook.png',
    description: 'Síguenos en Facebook',
    url: 'https://facebook.com/fccdduteq',
  ),
  ItemData(
    id: 2,
    name: 'Instagram UTEQ',
    image: 'assets/images/qr_instagram.png',
    description: 'Síguenos en Instagram',
    url: 'https://instagram.com/fccdd_uteq?igsh=dGhpcG53aWZmb2xx',
  ),
  ItemData(
    id: 3,
    name: 'TikTok UTEQ',
    image: 'assets/images/qr_tiktok.png',
    description: 'Síguenos en TikTok',
    url: 'https://tiktok.com/@carrerasoftwareuteq?_t=ZM-8zatsbwYIv0&_r=1',
  ),
  ItemData(
    id: 4,
    name: 'YouTube UTEQ',
    image: 'assets/images/qr_youtube.png',
    description: 'Suscríbete a nuestro canal',
    url: 'https://youtube.com/@orlandoerazo?si=AAaU4GGqjBE9QQgz',
  ),
];

// 🔹 Widget del Carrusel
class Carousel extends StatefulWidget {
  final List<ItemData> data;
  final String title;

  const Carousel({super.key, required this.data, required this.title});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final PageController _controller = PageController();

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  final item = widget.data[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _openUrl(item.url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            item.image,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Pantalla principal
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Carousel(data: appsData, title: "Aplicaciones UTEQ"),
          Carousel(data: softwData, title: "Información de Carreras"),
          Carousel(data: socialData, title: "Redes Sociales UTEQ"),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTEQ App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}