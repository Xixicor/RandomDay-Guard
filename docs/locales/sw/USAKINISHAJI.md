<a id="install-randomdayguard"></a>
# Sakinisha RandomDayGuard

> **Chanzo cha Kiingereza cha Canonical:** [INSTALL.md](../../../INSTALL.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Mwongozo huu husakinisha `v0.4.12-alpha` kwenye seva maalum ya Abiotic Factor ambayo tayari inatumia UE4SS. Mfumo haufungamani na kampuni moja ya upangishaji au paneli dhibiti.

<a id="before-you-begin"></a>
## Kabla ya kuanza

Unahitaji:

- ufikiaji wa kusimamisha na kuanzisha seva maalum;
- ya seva UE4SS `Mods` folda;
- nakala ya RandomDayGuard folda ikiwa unasasisha;
- chelezo cha data ya seva ambayo kwa kawaida huilinda kabla ya kubadilisha mod.

The **Folda ya Mods** ndio `ue4ss/Mods/`saraka ndani ya usakinishaji wa seva iliyojitolea.RandomDayGuard inamilikiwa moja kwa moja ndani ya folda hiyo.

<a id="new-installation"></a>
## Usakinishaji mpya

1. Simamisha seva maalum.
2. Nyoa RandomDayGuard ZIP kwenye folda mpya tupu.
3. Nakili iliyotolewa `RandomDayGuard` folda kwenye UE4SS `Mods` folda. Matokeo yanapaswa kuwa moja `Mods/RandomDayGuard/` folda, sio sekunde RandomDayGuard folda iliyowekwa ndani yake.
4. Fungua UE4SS `mods.txt` na uwashe:

   ```text
   RandomDayGuard : 1
   ```

5. Anzisha seva kwa kawaida.
6. Subiri UE4SS na seva ya mchezo kumaliza kuanza, kisha fuata [Soma ripoti ya kwanza](ANZIA_HAPA.md).

Usinakili toleo jipya katika usakinishaji unaoendelea. Hifadhi nakala hadi usakinishaji uliosasishwa utoe ripoti ya sasa ya hali ya seva.

<a id="update-an-existing-installation"></a>
## Sasisha usakinishaji uliopo

1. Simamisha seva.
2. Nakili iliyosakinishwa kamili RandomDayGuard folda hadi mahali salama pa kuhifadhi nakala.
3. Hamisha folda ya zamani ya programu kutoka UE4SS `Mods` badala ya kuweka toleo jipya juu yake.
4. Nakili mpya RandomDayGuard folda ndani ya `Mods`.
5. Rejesha usanidi wako wa ndani uliohakikiwa pekee na ushahidi uliohifadhiwa. Ikiwa mwongozo wa usanidi utaorodhesha sehemu mpya, ziunganishe kwenye nakala iliyohakikiwa badala ya kubadilisha mipangilio yote kwa upofu.
6. Thibitisha `RandomDayGuard : 1` inasalia kuwashwa.
7. Anzisha seva na usome ripoti ya sasa ya hali ya seva.

Sasisho hili la folda safi pia huondoa faili zilizopitwa na wakati kutoka kwa matoleo ya zamani bila kuuliza opereta kukagua majina ya faili za programu.

<a id="help-guard-find-the-server-records"></a>
## Mlinzi wa Usaidizi kupata rekodi za seva

Mlinzi kwa kawaida hupata Kipengele cha Abiotic `Saved` saraka kiotomatiki. Ikiwa haiwezi, weka njia kamili ya hiyo `Saved` saraka katika `SavedRoot.txt` ndani ya RandomDayGuard folda. Elekeza kwa `Saved`, si kwa ulimwengu mmoja mmoja chini yake.

Ripoti ya kwanza ya hali ya seva inasema kama eneo la rekodi lilipatikana na ni vikundi vipi vya chanzo vilipatikana. Tumia [Utatuzi wa matatizo](UTATUZI_WA_MATATIZO.md) wakati haiwezi kusoma eneo.

<a id="first-run-behavior"></a>
## Tabia ya uendeshaji wa kwanza

Usakinishaji chaguo-msingi hutazama rekodi zinazopatikana na huandika ripoti. Haibadiliki `Admin.ini` au ongeza marufuku. Hii inakuruhusu kuthibitisha mkusanyiko, tafsiri na ubora wa ripoti kabla ya kuamua ikiwa utawasha kitendo chochote cha hiari.

[Soma ripoti ya kwanza](ANZIA_HAPA.md)

<a id="disable-or-remove-randomdayguard"></a>
## Zima au ondoa RandomDayGuard

1. Simamisha seva.
2. Nakili kamili RandomDayGuard folda hadi kwenye kumbukumbu salama.
3. Ili kulemaza mod, weka `RandomDayGuard : 0` katika UE4SS `mods.txt`.
4. Ili kuiondoa, sogeza kamili RandomDayGuard folda nje ya `Mods` baada ya kuthibitisha kumbukumbu inaweza kufunguliwa.
5. Anzisha seva na uthibitishe kwamba Ulinzi hauanzishi tena.

Kuzima au kuondoa Walinzi kutasimamisha mkusanyiko wa siku zijazo. Haifuti data ya mchezo, haifuti ripoti zilizohifadhiwa kwenye kumbukumbu, au kutengua kitendo tofauti cha opereta.

<a id="roll-back-an-update"></a>
## Rejesha sasisho

Ikiwa usakinishaji mpya haupakii au hauwezi kutoa ripoti ya sasa:

1. Simamisha seva.
2. Sogeza usakinishaji ambao haujafaulu kando bila kufuta rekodi zake.
3. Rejesha sasisho kamili la awali RandomDayGuardfolda.
4. Rejesha usanidi uliopitiwa na ushahidi uliohifadhiwa kutoka kwa chelezo sawa.
5. Thibitisha kuwa mod imewashwa na uanzishe seva.
6. Soma ripoti ya hali ya seva iliyorejeshwa kabla ya kufanya mabadiliko mengine.

<a id="more-help"></a>
## Usaidizi zaidi

- [Soma ripoti ya kwanza](ANZIA_HAPA.md)
- [Kitabu cha kucheza cha uendeshaji](KITABU_CHA_UENDESHAJI_CHA_UENDESHAJI.md)
- [Utatuzi wa matatizo](UTATUZI_WA_MATATIZO.md)
- [Wasifu wa usanidi](SANIDI_WASIFU.md)
- [Admin.ini utekelezaji](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md)

Watunzaji matoleo wanaweza kupata ukaguzi wa chanzo, kifurushi na faragha katika [Uthibitishaji na kutolewa](UTHIBITISHAJI_NA_KUTOLEWA.md). Hazihitajiki kwa usakinishaji wa kawaida.
