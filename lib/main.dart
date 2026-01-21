import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hesapmatik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        primaryColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: const MyHomePage(title: 'Hesapmatik'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _sapmaEkraniAcikMi = false;
  bool _ortEkraniAcikMi = false;

  void sapmaAc() {
    setState(() {
      _sapmaEkraniAcikMi = true;
      _ortEkraniAcikMi = false;
    });
  }

  void ortalamaAc() {
    setState(() {
      _ortEkraniAcikMi = true;
      _sapmaEkraniAcikMi = false;
    });
  }

  void anaMenuyeDon() {
    setState(() {
      _sapmaEkraniAcikMi = false;
      _ortEkraniAcikMi = false;
    });
  }

  final TextEditingController _controller = TextEditingController();
  String _sonucMetni = "Sonuç bekleniyor...";

  void hesapla() {
    String girilenMetin = _controller.text;
    if (girilenMetin.isEmpty) return;

    try {
      List<String> parcalar = girilenMetin.split(',');
      List<double> sayilar = parcalar
          .map((e) => double.parse(e.trim()))
          .toList();

      if (sayilar.length < 2) {
        setState(() {
          _sonucMetni = "En az 2 sayı giriniz.";
        });
        return;
      }

      double toplam = sayilar.reduce((a, b) => a + b);
      double ortalama = toplam / sayilar.length;

      double karelerToplami = 0;
      for (var sayi in sayilar) {
        karelerToplami += pow((sayi - ortalama), 2);
      }

      double varyans = karelerToplami / (sayilar.length - 1);
      double standartSapma = sqrt(varyans);

      double popVaryans = karelerToplami / sayilar.length;
      double popStandartSapma = sqrt(popVaryans);

      setState(() {
        _sonucMetni =
            " Standart Sapma: ${standartSapma.toStringAsFixed(2)} \n Varyans: ${varyans.toStringAsFixed(2)} \n Popülasyon Standart Sapma: ${popStandartSapma.toStringAsFixed(2)} \n Popülasyon Varyans: ${popVaryans.toStringAsFixed(2)}";
      });
    } catch (e) {
      setState(() {
        _sonucMetni = "Hatalı giriş! Sayı ve virgül kullanın.";
      });
    }
  }

  void hesapla2() {
    String girilenMetin = _controller.text;
    if (girilenMetin.isEmpty) return;

    try {
      List<String> parcalar = girilenMetin.split(',');
      List<double> sayilar = parcalar
          .map((e) => double.parse(e.trim()))
          .toList();

      if (sayilar.length < 2) {
        setState(() {
          _sonucMetni = "En az 2 sayı giriniz.";
        });
        return;
      }

      double toplam = sayilar.reduce((a, b) => a + b);
      double ortalama = toplam / sayilar.length;

      double medyan;
      int elemanSayisi = sayilar.length;
      sayilar.sort();
      if (elemanSayisi % 2 == 1) {
        medyan = sayilar[elemanSayisi ~/ 2];
      } else {
        int orta = elemanSayisi ~/ 2;
        medyan = (sayilar[orta - 1] + sayilar[orta]) / 2;
      }

      String modMetni = "";
      Map<double, int> frekanslar = {};

      for (var sayi in sayilar) {
        frekanslar[sayi] = (frekanslar[sayi] ?? 0) + 1;
      }

      int maxTekrar = 0;
      frekanslar.values.forEach((tekrar) {
        if (tekrar > maxTekrar) maxTekrar = tekrar;
      });

      if (maxTekrar == 1) {
        modMetni = "Mod Yok";
      }

      List<double> modlar = [];
      frekanslar.forEach((sayi, tekrar) {
        if (tekrar == maxTekrar) {
          modlar.add(sayi);
        }
      });

      modlar.sort();

      modMetni = modlar.join(", ");

      setState(() {
        _sonucMetni =
            " Ortalama: ${ortalama.toStringAsFixed(2)}\n Medyan: ${medyan.toStringAsFixed(2)} \n Mod: $modMetni";
      });
    } catch (e) {
      setState(() {
        _sonucMetni = "Hatalı giriş! Sayı ve virgül kullanın.";
      });
    }
  }

  Widget hangiEkran() {
    if (_sapmaEkraniAcikMi == true) {
      return sapmaHesapEkrani();
    } else if (_ortEkraniAcikMi == true) {
      return ortHesapEkrani();
    } else {
      return anaMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: hangiEkran()));
  }

  Widget anaMenu() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 200),
        const Text(
          "Ana Menü",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: sapmaAc,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
          child: const Text(
            "Standart Sapma Ve Varyans Hesapla",
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: ortalamaAc,
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
          child: const Text(
            "Ortalama, Medyan, Mod Hesapla",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget sapmaHesapEkrani() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Standart Sapma ve Varyans Hesaplama",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
          const Text(
            "Sayıları virgülle giriniz (Örn: 10, 20, 30)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '10, 25, 40...',
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: hesapla, child: const Text("HESAPLA")),

          const SizedBox(height: 30),

          Text(
            _sonucMetni,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          const SizedBox(height: 40),

          TextButton(
            onPressed: anaMenuyeDon,
            child: const Text("Ana Menüye Dön"),
          ),
        ],
      ),
    );
  }

  Widget ortHesapEkrani() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Ortalama, Medyan ve Mod Hesaplama",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          const Text(
            "Sayıları virgülle giriniz (Örn: 10, 20, 30)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 22),

          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '10, 25, 40...',
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: hesapla2,
            child: const Text(
              "HESAPLA",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 1, 1),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            _sonucMetni,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: anaMenuyeDon,
            child: const Text(
              "Ana Menüye Dön",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 1, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
