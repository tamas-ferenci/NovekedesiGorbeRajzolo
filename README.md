* [Motiváció](#motiváció)
* [Kitérő: én mégsem láttam még ilyet, mi az, hogy növekedési görbe meg percentilis és társaik?](#kitérő-én-mégsem-láttam-még-ilyet-mi-az-hogy-növekedési-görbe-meg-percentilis-és-társaik)
* [A program használata](#a-program-használata)
* [Technikai megjegyzések](#technikai-megjegyzések)
* [Köszönetnyilvánítás / Acknowledgement](#köszönetnyilvánítás--acknowledgement)
* [Verziótörténet](#verziótörténet)

A program címe: http://research.physcon.uni-obuda.hu/NovekedesiGorbeRajzolo/.

# Motiváció

A csecsemők, gyermekek fejlődésének követését lehetővé tevő standard növekedési görbék sok-sok évtizede használatban vannak. Valószínűleg a legtöbb szülő (és minden egészségügyis) látott már ilyet; klasszikus formájában egy papír, rajta az előrenyomtatott referencia percentilis-görbékkel, az ember bejelöli az egyes konkrét méréseket, esetleg szépen össze is köti őket, és így meg tudja ítélni a gyermek fejlődősét.

A program kifejlesztésének ötletét az adta, hogy 2018-ban kissé furcsán hatnak a nyomtatott papíron tollal berajzolgatott és vonalzóval összekötögetett növekedési görbék; minden bizonnyal sok szülő, vagy épp védőnő, orvos eleve nem (csak) egy papírfecnire írkálja a számokat, hanem számítógépen (is) rögzíti őket, vagy legalábbis könnyedén be tudja gépelni. De ha már így van, és ezek az adatok is megvannak elektronikusan - csakúgy mint a referencia-görbék - akkor miért ne gyártsunk belőle szép, számítógéppel rajzolt növekedési görbét?

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
  <img src="https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo/blob/master/01_testhossz_eletkoronkent_fiuk.jpg" alt="Növekedési görbe"/>
</p>

Erre a grafikonra, mint háttérre, rárajzolhatóak egy gyermek konkrét adatai (adott életkorban milyen magas volt), és így, a percentilis-görbék révén az egészséges gyerekek eloszlásához viszonyítva, megítélhetővé válik a növekedése.

Fontos hangsúlyozni, hogy ezek az értékek semmit nem mondanak arról, hogy egy adott testmagasság "normális"-e. Az 1. percentilis például elég extrém - de (definíció szerint!) épp azt jelenti, hogy a tökéletesen egészséges gyerekek közül is minden századik ilyen, vagy ennél alacsonyabb.

# A program használata

A program - a gyerek nemén túl - egy táblázatot kér be, mely a gyerek növekedési adatait tartalmazza, majd ez alapján kiszámolja belőlük a percentilis értékeket, és azokat a WHO referencia növekedési görbéjén ábrázolja. Az ábrázolás módja testreszabható, és a kapott eredmény képfájlként le is tölthető.

Hogy mi legyen az ábrázolandó jellemző (testmagasság, testtömeg vagy testtömegindex) az az `Ábrázolandó jellemző` nevű legördülő mezőből választható ki.

A `Haladó lehetőségek megjelenítése` opciót bepipálva néhány speciálisabb lehetőség nyílik meg:
* Beállítható, hogy a növekedés görbe pontjaira rakott feliratok pontosan hol jelenjenek meg (`Pontok feliratainak helye`).
* Beállítható, hogy e feliratok pontosan mit tartalmazzanak, _z_-score-t, percentilist, esetleg mindkettőt, és ez utóbbi esetben milyen formátumban (`Pontok feliratai`).
* Az ábra címmel látható el (`Az ábra címe`).
* A feldolgozott bemenő adatok le is tölthetőek, `csv` formátumban (`A feldolgozott adatok letöltése (CSV)`).

Fontos ismét hangsúlyozni, hogy a program pusztán a növekedési görbe ábrázolását segíti, nem helyettesíti annak kiértékelését, azt minden esetben egészségügyi szakszemélyzetre kell bízni. Különösen fontos, hogy a "magas" és "alacsony" értékek egyáltalán nem feltétlenül jelentenek bajt (ha már nagyon muszáj valamit mondani, akkor is inkább a változás az érdekes, tehát ha magasból egyszercsak alacsony lesz, vagy fordítva). Szó nincs tehát arról, hogy az 50. percentilis a "jó" érték, amit meg kell próbálni elérni, mint egy teszten a maximum pontot. A görbe - mint minden diagnosztikai eszköz - egyébként is csak a klinikai kép egészével együtt értékelhető.

A növekedési adatokat megadására két út van.

## Kézi begépelés

Ez esetben egyszerűen be kell vinni a megfelelő adatokat a weboldal jobb oldalán látható táblázatba. A számértékeket be kell gépelni, a mértékegységek pedig legördülő listából választhatóak ki. A táblázat aljára új sor az `Új sor hozzáadása` feliratú gombra kattintva adható, a legalsó sor pedig az `Utolsó sor törlése` gombbal törölhető.

Fontos, hogy a fájlból történő beolvasás felülírja az - esetleges - kézzel bevitt adatokat! (Viszont fájlból történő beolvasás után a kapott adatok minden további nélkül továbbszerkeszthetőek kézzel is.)

## Fájlból, illetve Google Docs-ról történő beolvasás

E lehetőség eléréséhez be kell pipálni az `Adatok betöltése fájlból/Google Docs-ról` pontot; ekkor megjelenik a részletes beállításokat lehetővé tevő panel. Két lehetőség van a fájlból történő beolvasásra. Az egyik a számítógépen tárolt állomány használata, ehhez a `A növekedési adatokat tartalmazó fájl helye` pont alatt a `Számítógép` opciót kell választani, majd a megjelenő, `A fájl helye` feliratú soron a `Tallózás` gombra kattintva válaszható ki a fájl; a formátuma lehet `.xls` vagy `.xlsx` (Microsoft Excel), illetve az univerzális `.csv` formátum. (A formátumot nem kell megadni, a program a kiterjesztés alapján automatikusan felismeri.) A másik lehetőség az áttöltés Google Docs-ról, ehhez a `Google Docs` opciót kell választani, majd a megjelenő, `URL` feliratú sorba bemásolni a fájl elérési útját. (A fájl nem kötelező, hogy a Google Docs 'Közzététel az interneten' opciójával közzé legyen téve, elég, ha megosztható linkje van.) A szükséges elérési út a Google Docs jobb felső sarkában lévő 'Megosztás' gombbal kérhető le.)

A most következő további lehetőségek már egységesen igazak mindkét esetben, tehát függetlenek attól, hogy honnan származik a beolvasott fájl.

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

Példaként letölthető egy demonstrációs állomány [életkort tartalmazó](PeldaEletkor.xlsx?raw=true) formátumban, és egy [mérési dátumokat tartalmazó](PeldaDatum.xlsx?raw=true) formátumban.

Fontos, hogy a fájlból történő beolvasás felülírja az - esetleges - kézzel bevitt adatokat! (Viszont fájlból történő beolvasás után a kapott adatok minden további nélkül továbbszerkeszthetőek kézzel is.)

# Technikai megjegyzések

* Noha igyekeztem a lehető legalaposabban eljárni, a programhoz természetesen nincs garancia. Különösen most, hogy még a kezdeti fázisban van; pontosan erre tekintettel viszont hálásan megköszönök minden tesztelést (kiemelten ugyanazon adatok más programokba való begépelését vagy papíron történő rögzítését, és ezek eredményének összevetését az én programom által szolgáltatottakkal), illetve visszajelzést, javítási ötletet!
* Az előbbi cél érdekében a teljes munkám transzparens: ebben a GitHub repozitóriumban nyilvánosan elérhető tettem a teljes programot, mely alapján bárki reprodukálhatja az egész munkafolyamatot. Letölthető az [R szkript](app.R), az [adatállomány](lmsdat.rds?raw=true) és a percentiliseket számító [segédszkript](lms3_macro_calcz_woload.R) is.
* A program a WHO referencia növekedési görbéit használja (<a href="https://scielosp.org/scielo.php?script=sci_arttext&pid=S0042-96862007000900010&lng=en&nrm=iso&tlng=en" target="_blank">de Onis, 2007</a>), Rodd és mtsai kiegészítésével (<a href="https://bmcpediatr.biomedcentral.com/articles/10.1186/1471-2431-14-32" target="_blank">Rodd, 2014</a>). A percentilis és _z_-score számításokat a Kanadai Gyermekendokrinológiai Munkacsoport (CPEG) `quickZ` [szkriptjével](https://cpeg-gcep.net/content/who-macro-files-cpeg-revision) végzi. Az adatfájlokat csak minimális mértékben módosítottam, hogy kompatibilis legyen a program hívásaival.
* Létezik ugyan specifikusan magyar növekedési referencia is (az <a href="http://www.demografia.hu/kiadvanyokonline/index.php/kutatasijelentesek/article/view/394" target="_blank">Országos Longitudinális Gyermeknövekedés-vizsgálat</a>), mely nagyon igényesen tervezett mintavételileg és nagy energiabefektetéssel készült, ám komoly módszertani aggályok <a href="http://www.lll.hu/gyakran-felmerulo-kerdesek/who-novekedesi-gorbek-milyen-a-szoptatott-csecsemok-atlagos-novekedesi-uteme/" target="_blank">merültek fel</a> a bevont gyerekek táplálásával kapcsolatban, ezért használtam inkább a WHO referenciát.
* Az eredeti WHO referencia 2 év alatt fekvő, 2 év felett álló helyzetben mért testmagasságot feltételez. A WHO [irányelve](http://www.who.int/childgrowth/training/module_b_measuring_growth.pdf) szerint a fekvő testmagasság 0,7 cm-rel nagyobb, mint az álló. Azért, hogy a növekedési görbe ne törjön meg 2 évnél, én ezt a különbséget eltüntettem azzal, hogy a 2 év alatti értékekből 0,7 cm-t levontam (így tehát már az összes egységesen álló helyzetben mért magasság). A dolognak valószínűleg a legtöbb esetben nincsen semmilyen gyakorlati jelentősége, de azért fontos rögzíteni, hogy a program álló helyzetben mért testmagasságot vár (tehát a fekvő helyzetben mért magasságokból elvileg 0,7 cm-t le kell vonni).

# Köszönetnyilvánítás / Acknowledgement

Köszönöm Dr. Atul Sharma-nak (Manitobai Egyetem, Gyermekgyógyászati és Gyermekegészségügyi Tanszék), hogy önzetlenül megosztotta velem a saját hasonló alkalmazásuk kifejlesztése során nyert tapasztalatait, és minden felmerült kérdésemben alapos segítséget nyújtott anélkül, hogy egyáltalán ismert volna. I am grateful to Dr. Atul Sharma (Department of Pediatrics and Child Health, University of Manitoba) for his selfless sharing of his experiences he accumulated during developing similar apps, and answering all my questions in detail without even knowing me.

Köszönöm a továbbfejlesztési javaslatokat és a tesztelést (alfabetikus sorrendben) Bársony Gábornak és Varga Máténak.

# Verziótörténet

Verzió|Dátum|Kommentár
------|-----|---------
v1.00|2018-02-22|Kiinduló változat.
v2.00|2018-02-24|Kézi adatbevitel lehetőségének megteremtése.
v2.01|2018-02-25|<ul><li>A felület ergonómiai fejlesztése.</li><li>Az egyes jellemzők külön-külön is ábrázolhatóak (nem kell mind testtömeget, mind testmagasságot kötelezően megadni).</li><li>Hiányzó értékek javított kezelése.</li><li>Dokumentáció javítása.</li></ul>
v2.02|2018-02-26|<ul><li>Hibajavítás: a sorok számozása nem mindig folytonos.</li><li>Egyetlen érték is ábrázolható.</li><li>Az ábra címmel látható el.</li><li>A feldolgozott adatok le is tölthetőek (`.csv` formátumban).</li><li>Dokumentáció javítása</li></ul>
v2.03|2018-02-27|Google Docs-ból történő importálás lehetőségének megteremtése.
v2.04|2018-02-28|<ul><li>Hibajavítás: adatok betöltése után nem lehet rögtön, megjelenítés nélkül képfájlként lementeni a növekedési görbét.</li><li>Esztétikai javítások a felületen.</li></ul>
v2.05|2018-03-07|<ul><li>Facebook megosztó gomb hozzáadása a felülethez.</li><li>Dokumentáció bővítése köszönetnyilvánítás ponttal.</li></ul>
v2.06|2023-03-28|Fejléc javítása.
