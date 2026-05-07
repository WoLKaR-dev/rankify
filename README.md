# Rankify

![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen?style=for-the-badge&logo=open-source-initiative)

Rankify helps Brawl Stars players climb faster by turning match data into smarter draft decisions.

This content is not affiliated with, endorsed, sponsored, or specifically approved by Supercell and Supercell is not responsible for it. For more information, see [Supercell’s Fan Content Policy](https://supercell.com/fan-content-policy).

# Usage

Rankify was designed to be intuitive. First of all, start the web app at [Rankify](https://wolkar-dev.github.io/rankifu) and head up to the "Settings" section located at the left part of the screen.

Once there, you will find a "Model" section, in which you will find different versions of the same AI model.

Each version does different mathematical calculations and gives a determinated prediction. You can read the model version description by clicking the model version. It is located under the **Strategy** label.

![models_image](/readme_images/models.png)

Once you have your desired model, you can now start picking. Head up to the "Ranked" section in the left part of the screen. It should have a two arrow up icon.

Now, you will see a screen full of game maps.
![maps](/readme_images/maps.png)

Select the map you want. If you are not able to find your desired map, you can search for it in the upper part of the screen. Let's try with _Dry Season_:
![picked map](/readme_images/picked_map.png)
Click the map to select it.

Now a new screen will open, where you will able to pick brawlers and see AI prediction. You should have two rows of 3 slots each. Blue row belongs to your own team and red one to the enemy team.

You should pick your **allies from left to right** and your **enemies from right to left** (as in Competitive) in order to get better recommendations.
![simulation pick](/readme_images/simulated_pick1.png)

Below, you will find a section called _Runtime Predictions_. This is the model making its predictions based on the match situation. Depending on the AI model version that you picked, this prediction will be instant or last a little bit more (and depending on your device).
![prediction](/readme_images/prediction1.png)

Of course, these predictions will get updated when you change your match status (for instance, when removing an enemy brawler). In order to see the full table of brawler prediction, you can press _See All_.

This will open a fully new screen. There you will see al probabilities.
![full_predictions](/readme_images/full_predictions.png)

Once you finished picking, you can press _Next Match!_ in the lower part of your screen to start a new game pick.
![next](/readme_images/next.png)

Next, you will find information about how to contribute to _Rankify_.

# Contributing

Thanks for contribute mantaining Rankify. Here you will find detailed steps to help Rankify community.

### Organization

This project is orginized like this:

```plaintext
root 
|
|---- assets (main assets for app)
|     |-- data (here we will add some important data)
|     |-- fonts (project fonts)
|     |-- icons 
|     |-- images
|     |-- models (here is where we add our AI model)
|     |-- sounds (some future app sounds)
|
|---- lib (the main code)
|     |-- components (general, singleton services)
|     |-- core (general, important code. Must be accessible in all app)
|     |-- modules (each feature of the app with its own pages and services)
|     |-- main.dart (main running file)

```

Firstly, ensure you have installed the following:

- Flutter SDK
- Git
- Python

Now, you can fork Rankify by clicking _Fork_ in this project. This will create a copy of this project into your account. Now run:

```bash
git clone https://github.com/your_user/rankify.git
```

This will clone _Rankify_ files into your computer. Now, open the project:

```bash
cd rankify
```

Install dependencies with `flutter pub get` and create a new branch:

```bash
git checkout -b rankify-update
```

Now make your changes, and add it using `git add .`. Commit changes with: `git commit -m "Changes (or message)"`.

You can push now changes to your GitHub with `git push origin rankify-update`, and press _Compare & Pull Request_ button. If accepted, you will successfully contributed to _Rankify_. Thanks!

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

##### Credits

Credits to [Brawlify](https://brawlify.com), which provides a free and open API with map icons and brawlers. Thanks!.

# 🗺️ Roadmap

This is the current roadmap for Rankify:

```plaintext
🟢 Fixed-size brawler portraits
🟠 Ability to filter to LvL11 brawlers only
🟠 Add ban screen
```
