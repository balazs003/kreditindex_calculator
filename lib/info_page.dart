import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Információ"),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Az alkalmazás használata',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),
              ),
              Divider(color: Colors.black,),
              SizedBox(height: 20,),
              Text(
                'Kreditek száma',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Az oldal tetején a felvett kreditek összege látszik, alatta pedig a teljesítetteké. A teljesített kreditek száma alapvetően megegyezik a felvett kreditek számával, kivéve, ha egy tárgyra kapott jegy elégtelen.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Statisztikai kártyák',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Az oldal tetején látható színes kártyák közül a beállításokban kiválaszthatjuk, hogy melyiket szeretnénk megjeleníteni. Ha a kártyákra kattintunk, megjelenik egy ablak, amiben láthatjuk az adott érték számításának módját.',
                style: TextStyle(
                    fontSize: 17,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Új tárgy felvétele',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'A tantárgyak szöveg alatt található Új tárgy felvétele gomb megnyomása után egy párbeszédablak jelenik meg, amiben megadhatjuk a tárgy nevét és hogy hány kreditet ér (a tárgyra kapott jegyet később szerkeszthetjük). Sikeres hozzáadás esetén a Tantárgyak szekcióban a hozzáadás gomb felett jelennek meg a tárgyak kártyák formájában. Ha a gomb nem látszik, ne ijedjünkk meg, az oldal tartalma görgethető.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Jegyek módosítása',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'A tárgyak kártyáin lévő csúszka használatával módosíthatjuk az adott tárgyra kapott vagy elvárt jegyet. Ezzel egyidejűleg frissülnek a statisztikai kártyák adatai.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Tárgy megjelölése',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'A tárgyak kártyáin bal oldalon lévő könyvjelző ikonra bökve megjelölhetjük a tárgyat aszerint, hogy biztosak vagyunk-e az eredményben, vagy még várjuk a végkifejletet. Ilyenkor a tárgyhoz tartozó kártya elemei zöldből sárga, vagy sárgából zöld színre váltanak. Ezzel elkülöníthetjük azokat a tárgyakat, amik eredményében már biztosak vagyunk. Ezt bármikor megváltoztathatjuk.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Tárgy(ak) törlése',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'Ha egy tárgyat törölni szeretnénk, akkor tartsuk nyomva a kártyáját kis ideig, majd megejelnik egy ablak, ahol megerősíthetjük a törlést. Ha sok tárgyat szeretnénk törölni, ezek együttes törlését elvégezhetjük a beállítások menüből.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Osztó értéke',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(
                'A beállítások menüben megadhatjuk, hogy kreditérték számításnál mennyivel osszon a program, például kollégiumba bekerüléshez, vagy ösztöndíjhez szükséges átlag számításakor ez hasznos lehet.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
