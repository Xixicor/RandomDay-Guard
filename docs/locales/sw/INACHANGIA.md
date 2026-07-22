<a id="contributing"></a>
# Inachangia

> **Chanzo cha Kiingereza cha Canonical:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


RandomDayGuard inakubali uboreshaji unaolenga, unaoweza kutolewa tena kwa vichanganuzi, uwekaji hati, majaribio na uthibitishaji salama wa umma. Weka kila mabadiliko kwenye mkataba wa mradi wa umma na uhifadhi tabia ya kukagua kwanza: Mlinzi lazima aondoke `Admin.ini` haijabadilishwa wakati ukaguzi wa usalama unaohitajika hauwezi kuthibitishwa.

<a id="prepare-a-safe-workspace"></a>
## Andaa nafasi ya kazi salama

1. Fanya au tengeneza hazina na uunde tawi linalolenga.
2. Sakinisha mkalimani wa Python 3 anayetumika. Sakinisha kikusanyaji cha Lua unapobadilisha Lua hivyo `luac -p` inaweza kuangalia sintaksia.
3. Soma [nyumba ya hati](HATI.md), [usanifu](USANIFU.md), na [mpaka wa ushahidi](MPAKA_WA_USHAHIDI.md) kwa eneo utakalobadilisha.
4. Kagua `git status` kabla ya kuhariri na kuhifadhi kazi isiyohusiana.
5. Tumia viunzi vya sanisi au vilivyosafishwa pekee.

Usiwahi kuwasilisha kumbukumbu za seva binafsi, folda zilizohifadhiwa, vitambulisho vya kichezaji, `Admin.ini`, sehemu za mwisho za arifa za kibinafsi, kitambulisho, njia za faragha, utoaji wa programu, au ushahidi wa moja kwa moja ulionakiliwa.

<a id="make-a-focused-change"></a>
## Fanya mabadiliko yaliyolenga

- Fuata majina yaliyopo, uumbizaji, ukaguzi wa usalama na umiliki wa sehemu.
- Weka mmiliki mmoja wa hati za kisheria kwa kila utaratibu au ukweli halisi.
- Sasisha hati za mtumiaji na mifano wakati tabia au matokeo ya umma yanabadilika.
- Ongeza jaribio la urejeshi kwa urekebishaji wa hitilafu inapowezekana.
- Usidhoofishe uthibitishaji wa akaunti, ulinzi wa akaunti inayoaminika, uthibitishaji nakala rudufu, utambuzi wa mabadiliko ya nje, kulinganisha faili zilizohifadhiwa, urejeshaji, au chaguomsingi za ukaguzi pekee ili kufanya jaribio kupita.

<a id="run-the-relevant-checks"></a>
## Tekeleza ukaguzi unaofaa

Kwa mabadiliko ya hati pekee, endesha:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Kwa chanzo, usanidi, ufungaji, au mabadiliko ya majaribio, endesha pia ukaguzi unaotumika kutoka [Uthibitishaji na uchapishaji wa ukaguzi](UTHIBITISHAJI_NA_KUTOLEWA.md), ikijumuisha ukaguzi wa sintaksia ya Lua, uthibitishaji wa hazina, majaribio ya bomba la umma, na kitengo kamili cha majaribio. Ripoti kila hundi iliyorukwa au isiyopatikana; usiielezee kama imepitishwa.

<a id="submit-the-change-for-review"></a>
## Wasilisha mabadiliko kwa ukaguzi

Fungua ombi lililolengwa la kuvuta tu baada ya kukagua tofauti kamili. Jumuisha:

- tatizo na tabia inayokusudiwa;
- faili halisi na mikataba ya umma imebadilishwa;
- amri huendeshwa na matokeo yake;
- madhara ya faragha, uoanifu na utekelezaji; na
- vikwazo vilivyosalia au kazi ya ufuatiliaji.

Usijumuishe ushahidi wa wakati wa utekelezaji uliozalishwa au toa kumbukumbu isipokuwa kama mabadiliko yanahitaji na kuyathibitisha. Mchango hauidhinishi uchapishaji, utumaji, jaribio la seva moja kwa moja, hatua ya kutekeleza au uchapishaji kwenye tovuti ya watu wengine.

Ripoti udhaifu kupitia [njia ya faragha ya usalama](USALAMA.md), si suala la umma au ombi la kawaida la kuvuta.
