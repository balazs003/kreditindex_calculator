import 'package:flutter/material.dart';

Text headerText(String data, Color color) {
  return Text(
    data,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
  );
}

Text descriptionText(String data) {
  return Text(
    data,
    style: const TextStyle(
      fontSize: 17,
    ),
  );
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Információ"),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Az alkalmazás használata',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 20,
              ),
              headerText('Megjelenítendő félév kiválasztása',
                  Theme.of(context).colorScheme.primary),
              descriptionText(
                  'A bal felső sarokban lévő gombra kattintva megjelenik egy menü, ahonnan kiválaszthatjuk, hogy melyik félévünknek az adatait akarjuk látni a kezdőlapon. A lista görgethető.'),
              const SizedBox(
                height: 20,
              ),
              headerText('Összesített adatok megtekintése',
                  Theme.of(context).colorScheme.primary),
              descriptionText(
                  'Lehetőségünk van megtekinteni az egész egyetemi pályafutásunk alatt szerzett eredményeinket összesítve. Ehhez kattintsunk az oldal tetején a fogaskeréktől balra található kis sávokat tartalmazó ikonra.'),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Kreditek száma', Theme.of(context).colorScheme.primary),
              descriptionText(
                  'Az oldal tetején a felvett kreditek összege látszik, alatta pedig a teljesítetteké. A teljesített kreditek száma alapvetően megegyezik a felvett kreditek számával, kivéve, ha egy tárgyra kapott jegy elégtelen.'),
              const SizedBox(
                height: 20,
              ),
              headerText('Statisztikai kártyák',
                  Theme.of(context).colorScheme.primary),
              descriptionText(
                  'Az oldal tetején látható színes kártyák közül a beállításokban kiválaszthatjuk, hogy melyiket szeretnénk megjeleníteni.'),
              const SizedBox(
                height: 20,
              ),
              headerText('Kreditindex a korábbi félévvel együtt',
                  Theme.of(context).colorScheme.primary),
              descriptionText(
                  'Ez a kártya azt mutatja, hogy a kollégiumba kerüléshez számított átlag mennyi lesz a korábbi félévben megszerzett átlaggal együtt. Ez az információ a BME VIK-re járó kollégistáknak lehet releváns.'),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Új tárgy felvétele', Theme.of(context).colorScheme.primary),
              descriptionText(
                'A tantárgyak szöveg alatt található Új tárgy felvétele gomb megnyomása után egy párbeszédablak jelenik meg, amiben megadhatjuk a tárgy nevét és hogy hány kreditet ér (a tárgyra kapott jegyet később szerkeszthetjük). Sikeres hozzáadás esetén a Tantárgyak szekcióban a hozzáadás gomb felett jelennek meg a tárgyak kártyák formájában. Ha a gomb nem látszik, ne ijedjünk meg, az oldal tartalma görgethető.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Jegyek módosítása', Theme.of(context).colorScheme.primary),
              descriptionText(
                'A tárgyak kártyáin lévő csúszka használatával módosíthatjuk az adott tárgyra kapott vagy elvárt jegyet. Ezzel egyidejűleg frissülnek a statisztikai kártyák adatai.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Tárgy megjelölése', Theme.of(context).colorScheme.primary),
              descriptionText(
                'A tárgyak kártyáin bal oldalon lévő könyvjelző ikonra bökve megjelölhetjük a tárgyat aszerint, hogy biztosak vagyunk-e az eredményben, vagy még várjuk a végkifejletet. Ilyenkor a tárgyhoz tartozó kártya elemei zöldből sárga, vagy sárgából zöld színre váltanak. Ezzel elkülöníthetjük azokat a tárgyakat, amik eredményében már biztosak vagyunk. Ezt bármikor megváltoztathatjuk.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Tárgy szerkesztése', Theme.of(context).colorScheme.primary),
              descriptionText(
                'Ha egy tárgyat szerkeszteni szeretnénk, akkor húzzuk jobbra a kártyáját, majd a kék mezőre nyomva megjelenik egy ablak, ahol szerkeszthetjük a tárgy adatait.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Tárgy(ak) törlése', Theme.of(context).colorScheme.primary),
              descriptionText(
                'Ha egy tárgyat törölni szeretnénk, akkor húzzuk balra a kártyáját, majd a piros mezőre nyomva megjelenik egy ablak, ahol megerősíthetjük a törlést. Ha sok tárgyat szeretnénk törölni, ezek együttes törlését elvégezhetjük a beállítások menüből.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Tárgyak átrendezése', Theme.of(context).colorScheme.primary),
              descriptionText(
                'Tartsuk nyomva egy tárgy kártyáját, és húzzuk a kívánt pozícióba, így átrendezhetjük a tárgyaink sorrendjét.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText('Osztó értéke', Theme.of(context).colorScheme.primary),
              descriptionText(
                'A beállítások menüben megadhatjuk, hogy kreditérték számításnál mennyivel osszon a program, például kollégiumba bekerüléshez, vagy ösztöndíjhez szükséges átlag számításakor ez hasznos lehet.',
              ),
              const SizedBox(
                height: 20,
              ),
              headerText(
                  'Alkalmazás verziója', Theme.of(context).colorScheme.primary),
              descriptionText(
                '2.1.0.0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
