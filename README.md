* [Motiváció](#motiváció)
* [Kitérő: én mégsem láttam még ilyet, mi az, hogy növekedési görbe meg percentilis és társaik?](#kitérő-én-mégsem-láttam-még-ilyet-mi-az-hogy-növekedési-görbe-meg-percentilis-és-társaik)
* [A program használata](#a-program-használata)
* [Technikai megjegyzések](#technikai-megjegyzések)

# Motiváció

A csecsemők, gyermekek fejlődésének követését lehetővé tevő standard növekedési görbék sok-sok évtizede használatban vannak. Valószínűleg a legtöbb szülő látott már ilyet; klasszikus formájában egy papír, rajta az előrenyomtatott percentilis-görbékkel, a szülő bejelöli az egyes méréseket, esetleg szépen össze is köti őket, és így meg tudja ítélni a gyermek fejlődősét.

A program kifejlesztésének ötletét az adta, hogy 2018-ban kissé furcsán hatnak a nyomtatott papíron tollal berajzolgatott és vonalzóval összekötögetett növekedési görbék; minden bizonnyal sok szülő eleve nem (csak) egy papírfecnire írkálja a számokat, hanem számítógépen (is) rögzíti őket. De ha már így van, és ezek az adatok is megvannak elektronikusan - csakúgy mint a referencia-görbék - akkor miért ne gyártsunk belőle szép, számítógéppel rajzolt növekedési görbét?

# Kitérő: én mégsem láttam még ilyet, mi az, hogy növekedési görbe meg percentilis és társaik?

A növekedési görbe egész egyszerűen a gyermek valamely antropometriai adata - leggyakrabban a testmagassága és testtömege - az életkorának függvényében ábrázolva.

Ez persze önmagában még nem túl informatív: ha egy 23 hónapos fiú 91 cm, az most sok? Vagy kevés? Vagy átlagos? Ezt nehéz ránézésre megmondani, gyakorlott szülőknek esetleg lehet benyomásuk, de azért jó lenne a dolgot tudományos alapokra helyezni. A megoldás ugyanis nagyon egyszerű: viszonyítani kell valamihez! Célszerűen az azonos nemű és azonos életkorú - és egészséges - többi gyermekhez. Ha ugyanis elég sokat lemérünk, akkor meg tudjuk határozni, hogy az egészséges 23 hónapos fiúk testmagasságának milyen az eloszlása, majd a 91 cm-t ehhez tudjuk viszonyítani. (Csak eloszlásban érdemes gondolkozni, hiszen a testmagasság szóródik: még a tökéletesen egészségesek között is lesznek alacsonyabbak és magasabbak.)

Az eloszlások alakjának egyik lehetséges leírása a percentilisek megadása. A percentilis nem más, mint egyfajta osztópont: 32. percentilis az a testmagasság, melyre igaz, hogy a gyermekek 32%-a kisebb testmagasságú ennél (és így 68%-a nagyobb). Hasonlóan a 10. percentilis az az - alacsony - testmagasság, melynél mindössze a gyermekek 10%-a alacsonyabb, a 95. percentilis az a - magas - testmagasság, aminél mindössze a gyermekek 5%-a magassabb és így tovább. Az 50. percentilis a "felezőpont" (az a testmagasság, aminél a gyerekek fele alacsonyabb, fele magasabb), ezt szokás mediánnak nevezni. Grafikusan szemléltetve mindezt, íme az egészséges 23 hónapos fiúk testmagasságának eloszlása, rajta az előbb említett percentilisekkel:

<p align="center">
  <img src="https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo/blob/master/PercentilisIllusztracio.png" alt="Percentilis illusztráció"/>
</p>

Az tehát, hogy mennyi a testmagasság - például - 50. percentilise, adott életkorban egy szám. Ha most ezt különböző életkorokban kiszámoljuk, és egy grafikonon ábrázoljuk, vízszintes tengelyen feltüntetve az életkort, függőlegesen pedig azt, hogy az adott életkorban hány centiméter az 50. percentilis (tehát az adott életkorban mekkora az a testmagasság, melynél épp a gyerekek fele alacsonyabb), akkor kapjuk a referencia növekedési görbét:

<p align="center">
  <img src="https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo/blob/master/NovekedesigorbeIllusztracio.png" alt="Növekedési görbe illusztráció"/>
</p>

Ha pedig ezt több nevezetes percentilisre kirajzoljuk, akkor el is jutunk a növekedési görbék megszokott formátumához; íme a WHO-é:

<p align="center">
  <img src="https://www.lll.hu/files/01_testhossz_eletkoronkent_fiuk.jpg" alt="Növekedési görbe"/>
</p>

Erre a grafikonra, mint háttérre, rárajzolhatóak egy gyermek konkrét adatai (adott életkorban milyen magas volt), és így, a percentilis-görbék révén az egészséges gyerekek eloszlásához viszonyítva, megítélhetővé válik a növekedése.

Fontos hangsúlyozni, hogy ezek az értékek semmit nem mondanak arról, hogy egy adott testmagasság "normális"-e. Az 1. percentilis például elég extrém - de (definíció szerint!) épp azt jelenti, hogy a tökéletesen egészséges gyerekek közül is minden századik van ilyen alacsony.

# A program használata

A program - a gyerek nemén túl - egy táblázatot kér be, mely a gyerek növekedési adatait tartalmazza, majd ez alapján kiszámolja belőlük a percentilis értékeket, és azokat a WHO referencia növekedési görbéjén ábrázolja. Az ábrázolás módja testreszabható, és a kapott eredmény képfájlként le is tölthető.

A növekedési adatokat tartalmazó fájl a Tallózás gombra kattintva válaszható ki; formátuma lehet `.xls` vagy `.xlsx` (Microsoft Excel), illetve az univerzális `.csv` formátum. (A formátumot nem kell megadni, a program a kiterjesztés alapján automatikusan felismeri.)

Fontos, hogy a fájl beolvasása a 2. sortól kezdődik, az 1. sorban tehát nem szerepelhet mérés, mert a program azt a sort eldobja. (Feltételezi, hogy ott egy fejléc szerepel. Mivel ezt be sem olvassa, így a konkrét tartalma érdektelen.)

Az életkor megadása kétféleképp is lehetséges. Az egyik megoldás, ha magában a fájlban szerepelnek a mérések időpontjai, ez esetben az első oszlop az időpontot tartalmazza (csak mint szám, mértékegység nélkül), a második oszlop pedig a mértékegységet, mely a "hét", "hónap" vagy "év" kifejezések valamelyike kell legyen (idézőjelek nélkül):

<p align="center">
  <img src="https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo/blob/master/FormatumEletkorPelda.png" alt="Példa a fájl formátumára, ha az életkor van megadva"/>
</p>

(Amint látható, a különböző mértékegységek vegyesen is használhatóak, a program automatikusan átszámolja őket.)

A másik lehetőség, hogy a fájlban csak a mérések dátumai szerepelnek:

<p align="center">
  <img src="https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo/blob/master/FormatumDatumPelda.png" alt="Példa a fájl formátumára, ha a mérés dátuma van megadva"/>
</p>

Ez esetben természetesen a gyermek születési dátumát is meg kell adni (ezt a lehetőséget választva a formátumnál automatikusan meg is jelenik a dátum megadására szolgáló mező).

Ezt az - egy vagy két - oszlopot követő oszlopokban kell megadni előbb a testmagasság méréseit, aztán a testtömegét. Mindkét esetben előbb a mérés számértéke szerepeljen, majd a következő oszlopban a mértékegysége (az előbbinél ez "cm" vagy "m", az utóbbinál "g" vagy "kg" lehet, természetesen idézőjelek nélkül):

<p align="center">
  <img src="https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo/blob/master/MeresekPelda.png" alt="Példa a fájl formátumára, ha a mérés dátuma van megadva"/>
</p>

Mint látható, a különböző mértékegységek itt is vegyíthetőek, a program mindent automatikusan átvált.

Példa fájl


# Technikai megjegyzések

A
