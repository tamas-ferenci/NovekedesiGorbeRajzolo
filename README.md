# Motiváció
A csecsemők, gyermekek fejlődésének követését lehetővé tevő standard növekedési görbék sok-sok évtizede használatban vannak. Valószínűleg a legtöbb szülő látott már ilyet; klasszikus formájában egy papír, rajta az előrenyomtatott percentilis-görbékkel, a szülő bejelöli az egyes méréseket, esetleg szépen össze is köti őket, és így meg tudja ítélni a gyermek fejlődősét.

A program kifejlesztésének ötletét az adta, hogy 2018-ban kissé furcsán hatnak a nyomtatott papíron tollal berajzolgatott és vonalzóval összekötögetett növekedési görbék; minden bizonnyal sok szülő eleve nem (csak) egy papírfecnire írkálja a számokat, hanem számítógépen (is) rögzíti őket. De ha már így van, és ezek az adatok is megvannak elektronikusan - csakúgy mint a referencia-görbék - akkor miért ne gyártsunk belőle szép, számítógéppel rajzolt növekedési görbét?

# Kitérő: én mégsem láttam még ilyet, mi az, hogy növekedési görbe meg percentilis és társaik?
A növekedési görbe egész egyszerűen a gyermek valamely antropometriai adata - leggyakrabban a testmagassága és testtömege - az életkorának függvényében ábrázolva.

Ez persze önmagában még nem túl informatív: ha egy 23 hónapos fiú 91 cm, az most sok? Vagy kevés? Vagy átlagos? Ezt nehéz ránézésre megmondani, gyakorlott szülőknek esetleg lehet benyomásuk, de azért jó lenne a dolgot tudományos alapokra helyezni. A megoldás ugyanis nagyon egyszerű: viszonyítani kell valamihez! Célszerűen az azonos nemű és azonos életkorú - és egészséges - többi gyermekhez. Ha ugyanis elég sokat lemérünk, akkor meg tudjuk határozni, hogy az egészséges 23 hónapos fiúk testmagasságának milyen az eloszlása, majd a 91 cm-t ehhez tudjuk viszonyítani. (Csak eloszlásban érdemes gondolkozni, hiszen a testmagasság szóródik: még a tökéletesen egészségesek között is lesznek alacsonyabbak és magasabbak.)

Az eloszlások alakjának egyik lehetséges leírása a percentilisek megadása. A percentilis nem más, mint egyfajta osztópont: 32. percentilis az a testmagasság, melyre igaz, hogy a gyermekek 32%-a kisebb testmagasságú ennél (és így 68%-a nagyobb). Hasonlóan a 10. percentilis az az - alacsony - testmagasság, melynél mindössze a gyermekek 10%-a alacsonyabb, a 95. percentilis az a - magas - testmagasság, aminél mindössze a gyermekek 5%-a magassabb és így tovább. Az 50. percentilis a "felezőpont" (az a testmagasság, aminél a gyerekek fele alacsonyabb, fele magasabb), ezt szokás mediánnak nevezni. Grafikusan szemléltetve mindezt, íme az egészséges 23 hónapos fiúk testmagasságának eloszlása:

A görbén az 

Az tehát, hogy mennyi a testtömegek például 50. percentilise, adott életkorban egy szám. Ha most ezt különböző életkorokban kiszámoljuk, és egy grafikonon ábrázoljuk, vízszintes

Fontos hangsúlyozni, hogy ezek az értékek semmit nem mondanak arról, hogy egy adott testmagasság "normális"-e. Az 1. percentilis például elég extrém - de (definíció szerint!) épp azt jelenti, hogy a tökéletesen egészséges gyerekek közül is minden századik van ilyen alacsony!

# A program használata

A program egy 
