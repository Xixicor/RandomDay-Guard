# RandomDayGuard বাংলা নির্দেশিকা

**v0.4.12-alpha**

RandomDayGuard একটি Abiotic Factor dedicated server থেকে সীমাবদ্ধ প্রমাণ সংগ্রহ
করে এবং তা সহজে পড়ার মতো operator report-এ সাজায়। Server status, daily
summary, player activity, case review এবং critical failure আলাদা route-এ থাকে।

## ইনস্টল

[Installation guide](../../../INSTALL.md) অনুসরণ করুন। Mod-এর সঠিক স্থান
`ue4ss/Mods/RandomDayGuard` এবং `mods.txt`-এ `RandomDayGuard : 1` থাকতে হবে।
Nested install বা duplicate `Scripts` folder রাখবেন না।

## প্রথম report যাচাই

`runtime/current/startup_status.json`, তারপর
`runtime/final_logs/latest_dossier.json` এবং
`runtime/final_logs/route_proof.json` দেখুন। প্রতিটি route-এর অবস্থা `full`,
`limited_expected_empty` অথবা `missing` হবে। Summary এবং cited source একই
processing cycle-এর হতে হবে।

## Configuration ও operation

Public defaults হলো `review_only_mode = true`, `auto_ban = false` এবং
`write_admin_ini = false`। [Start](../../START_HERE.md),
[Operations](../../OPERATIONS_PLAYBOOK.md), [Configuration](../../CONFIG_PROFILES.md)
এবং [Troubleshooting](../../TROUBLESHOOTING.md) ব্যবহার করুন। Structured evidence
হলো technical record; translation সেটি পড়তে সাহায্য করে।

Commands, paths, keys এবং states আসল file-এর সঙ্গে মিল রাখতে English-এ থাকে।

## আলফা রিলিজ ও প্রমাণের দুই পথ

এটি একটি আলফা রিলিজ। নথিভুক্ত সংগ্রহ, রিপোর্ট ও পুনরুদ্ধার পথ পরীক্ষা করা হয়েছে; সামঞ্জস্য, ঐতিহাসিক কভারেজ ও রিপোর্টের মান আরও উন্নত হচ্ছে।

বর্তমান পথ সক্রিয় লগ, বর্তমান স্টার্টআপ ও শিডিউলার অবস্থা এবং চলতি সেশন ব্যবহার করে, তাই এখনকার রিপোর্ট দ্রুত লিখতে পারে। ঐতিহাসিক পথ সংরক্ষিত লগ, PlayerData ফাইলনাম, আগের প্রমাণ ও কেস সীমিত ধাপে পরীক্ষা করে।

`runtime/current/report_worker_status.json`

একাধিক চক্রে `runtime/current/report_worker_status.json`-এর `scan_cursor` ও `last_progress_ts` তুলনা করুন। এগোলে স্ক্যান চলছে। বর্তমান রিপোর্ট এগোলেও এগুলো স্থির থাকলে ঐতিহাসিক স্ক্যান থেমে গেছে; বর্তমান তথ্য ব্যবহারযোগ্য থাকে, কিন্তু পুরোনো ইতিহাস-নির্ভর সিদ্ধান্ত সীমিত থাকে।

[Troubleshooting](../../TROUBLESHOOTING.md)
