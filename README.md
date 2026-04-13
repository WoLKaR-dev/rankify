# Rankify

![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen?style=for-the-badge&logo=open-source-initiative)

Rankify helps Brawl Stars players climb faster by turning match data into smarter draft decisions.

This content is not affiliated with, endorsed, sponsored, or specifically approved by Supercell and Supercell is not responsible for it. For more information, see [Supercell’s Fan Content Policy](https://supercell.com/fan-content-policy).

# Contributing

## Obtaining Data

This section was updated and moved to [gather branch](https://github.com/WoLKaR-dev/rankify/tree/gather#data-gather). You can now take a look at the new branch and follow its `README.md` instructions.

## Training AI Model

Now, you will have your `matches.csv` file with all the required information. You can now open [Google Collab](https://colab.research.google.com/drive/17v4WvOgDleoOywlKYAOZHBwc0xaIOfQo?usp=sharing) to train this model.

Follow the instructions in that Colab Notebook. After finishing, you will get a total of 3 new files: `brawler_mapping.json`, `map_mapping.json` and `draft_model.tflite`. This last file is the trained AI model that you will use.

Delete their equivalents in `assets/data/` and paste new `.json` files there. New AI model must be located at `assets/models/`.

## Ready to go!

Now, you have your model trained and ready to go. Check in-app code from `lib/components/ai_service.dart`, `lib/components/brawl_service.dart` and `lib/modules/pick/pick_code.dart` to understand how data is transformed.

> Better data. Better decisions. Higher ranks.

᠆ Wolkar

