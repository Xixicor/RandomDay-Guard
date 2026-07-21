# RandomDayGuard हिन्दी मार्गदर्शिका

**v0.4.12-alpha**

RandomDayGuard, Abiotic Factor के dedicated server से सीमित प्रमाण लेकर उन्हें
साफ़ operator reports में बदलता है। Server status, daily summary, player
activity, case review और critical failures अलग-अलग रहते हैं।

## स्थापना

[Installation guide](../../../INSTALL.md) का पालन करें। Mod का स्थान
`ue4ss/Mods/RandomDayGuard` होना चाहिए और `mods.txt` में
`RandomDayGuard : 1` होना चाहिए। Nested install और दोहरे `Scripts` folder से
बचें।

## पहली रिपोर्ट की जाँच

पहले `runtime/current/startup_status.json`, फिर
`runtime/final_logs/latest_dossier.json` और
`runtime/final_logs/route_proof.json` देखें। हर route का परिणाम `full`,
`limited_expected_empty` या `missing` होगा। Summary और उसका cited source एक ही
cycle के होने चाहिए।

## Configuration और संचालन

Public defaults हैं: `review_only_mode = true`, `auto_ban = false` और
`write_admin_ini = false`। [Start](../../START_HERE.md),
[Operations](../../OPERATIONS_PLAYBOOK.md), [Configuration](../../CONFIG_PROFILES.md)
और [Troubleshooting](../../TROUBLESHOOTING.md) पढ़ें। Structured evidence तकनीकी
record है; translation उसे पढ़ने योग्य बनाती है।

Commands, paths, keys और states वास्तविक files से मेल रखने के लिए English में
ही रखे गए हैं।

## अल्फ़ा रिलीज़ और प्रमाण के दो रास्ते

यह अल्फ़ा रिलीज़ है। लिखित संग्रह, रिपोर्ट और रिकवरी रास्तों का परीक्षण हुआ है; संगतता, पुराने रिकॉर्ड की कवरेज और रिपोर्ट की गुणवत्ता पर काम जारी है।

वर्तमान रास्ता सक्रिय लॉग, मौजूदा स्टार्टअप व शेड्यूलर स्थिति और चल रहे सत्रों से तुरंत वर्तमान रिपोर्ट लिख सकता है। ऐतिहासिक रास्ता सुरक्षित लॉग, PlayerData फ़ाइल नाम, पुराने प्रमाण और केस सीमित चरणों में जाँचता है।

`runtime/current/report_worker_status.json`

कई चक्रों में `runtime/current/report_worker_status.json` के `scan_cursor` और `last_progress_ts` की तुलना करें। वे बढ़ें तो स्कैन चल रहा है। वर्तमान रिपोर्ट बढ़ने पर भी वे न बदलें तो ऐतिहासिक स्कैन रुका है; वर्तमान तथ्य उपयोगी रहते हैं, पर पुराने इतिहास पर निर्भर निष्कर्ष सीमित रहते हैं।

[Troubleshooting](../../TROUBLESHOOTING.md)
