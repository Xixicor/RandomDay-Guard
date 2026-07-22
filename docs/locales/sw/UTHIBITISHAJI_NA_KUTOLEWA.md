<a id="validation-and-release"></a>
# Uthibitishaji na kutolewa

> **Chanzo cha Kiingereza cha Canonical:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Ukurasa huu ni wa wachangiaji na wasimamizi wa matoleo. Waendeshaji seva hawahitaji kutekeleza amri hizi ili kusakinisha RandomDayGuard.

<a id="user-visible-proof"></a>
## Uthibitisho unaoonekana na mtumiaji

Toleo linaeleweka wakati opereta mpya anaweza kuisakinisha, kupata ripoti ya kwanza ya hali ya seva, kutofautisha njia tano za ripoti, na kufuata kitendo kimoja wazi kutoka kwa mfano uliofanya kazi. Kazi za visomaji hazipaswi kuhitaji Git, PowerShell,Python, au maarifa ya checksum.

<a id="contributor-checks"></a>
## Kagua mchangiaji

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Wakati `luac` inapatikana:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Majaribio ya urekebishaji ya Lua yanashughulikia kipakiaji, kipanga ratiba, njia za ripoti na ya hiari Admin.ini andika muamala. Ratiba za utekelezaji hutumia faili za muda pekee na kuthibitisha utambulisho, kukataliwa kwa akaunti inayoaminika, viwango vya juu, kuhifadhi nakala, kukataa kwa mabadiliko ya wakati mmoja, kusoma na kurejesha nyuma.

<a id="package-proof"></a>
## Uthibitisho wa kifurushi

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Alamisho zote za matoleo zinalingana `VERSION`.
- Toleo la sasa pekee linapatikana chini ya `releases/`.
- The ZIP ina kanuni `RandomDayGuard/Scripts/main.lua` njia na hakuna kipakiaji kibadala cha herufi ndogo.
- Toleo la muda wa utekelezaji, usanidi wa faragha, vitambulisho, njia za ndani, akiba, na vizalia vya programu vya majaribio vimetengwa.
- Mipangilio ya umma inasalia kukaguliwa tu na utekelezaji umezimwa.
- Mifano mitano ya ripoti iliyofanyiwa kazi inasalia kuwa sawa na umiliki wa njia na toleo la majaribio ya toleo.
- ZIPbaiti zinabainisha na zinalingana `CHECKSUMS.sha256`.
- Viungo vyote vya hati za ndani na kurasa 27 za ingizo za lugha huidhinishwa.

<a id="avoid-validation-environment-pitfalls"></a>
## Epuka mitego ya mazingira ya uthibitishaji

- Endesha ukaguzi wa uandishi wa hazina mfululizo ili kuzuia ugomvi wa faili kwa muda.
- Kwenye Windows, kagua majina ya wanachama yaliyowekwa kwenye kumbukumbu au tahajia ya njia iliyoorodheshwa badala ya kuangalia faili isiyojali kesi unapotafuta vipakiaji nakala.
- Inakosekana `luac` amri au wakati wa utekelezaji wa Lua ni uwezo ambao haupatikani, si sintaksia au jaribio la wakati wa utekelezaji.
- Ratiba huthibitisha ingizo zake za kielelezo pekee. Haithibitishi kuwa seva ya moja kwa moja ilitoa ripoti ya sasa.
- Rekodi muda wa kuisha kwa amri na sehemu ya matokeo badala ya kudhani kuwa umekamilika.

<a id="repair-failed-repository-validation"></a>
## Urekebishaji umeshindwa uthibitishaji wa hazina

Anza na njia ya kwanza iliyoripotiwa au mkataba. Sahihisha kipengee hicho, fanya jaribio finyu, kisha urudishe mkusanyiko kamili. Usifiche uwezo unaokosekana kwa kuondoa jaribio linalohitaji.

<a id="known-limits-and-release-decision"></a>
## Vikomo vinavyojulikana na uamuzi wa kutolewa

Ukaguzi wa ndani unathibitisha mikataba ya chanzo, muundo, kifurushi na uhifadhi wa hati. Usakinishaji mahususi wa seva, dirisha la uthabiti la muda mrefu, au onyesho la mteja linahitaji matokeo tofauti ya ujumuishaji. Rekodi matokeo hayo kwa muundo wake, usanidi, muda na matokeo yaliyozingatiwa kabla ya kufanya dai linalolingana.
