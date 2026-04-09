# Rankify
![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen?style=for-the-badge&logo=open-source-initiative)

Rankify helps Brawl Stars players climb faster by turning match data into smarter draft decisions. 

This content is not affiliated with, endorsed, sponsored, or specifically approved by Supercell and Supercell is not responsible for it. For more information, see [Supercell’s Fan Content Policy](https://supercell.com/fan-content-policy).

# Contributing

## Obtaining Data

### Configuring API Key
To gather data, you must use the [Brawl Stars API](https://developer.brawlstars.com/#/), for which you will need a [Developer Account](https://developer.brawlstars.com/#/register). 

Once you have registered, follow these steps: `Log in > My Account > Create new API Key`. 

Choose a name, write a description, and whitelist the IP address from which the data gathering will occur. If you are using your own computer, you can use [What is my IP](https://whatismyipaddress.com/) to find your IP address. 

> Important: A personal computer's IP address might change between sessions or after rebooting the Wi-Fi router. Please check it every time. 

Once you have your API key, create a file named `.env` in the `python/` directory and paste the following code: 

```env
API_KEY=[API_KEY]
```
Where: 
- `[API_KEY]` is the key you obtained (without `[]`). 

### Creating Data files
The model uses `.csv` files for training. Create a `data.csv` file in the `python/` directory using `data_template.csv` as a template. Copy the contents of the template into your new `data.csv` file. 

These are the headers used to store data: 
- `map`: Event `id`. 
- `result`: The result of the match, where `1` represents a `victory` and `0` a `defeat`. 
- `ally1, ..., enemy3`: The `id` of each brawler. 
- `timestamp`: Used to avoid duplicate matches. 

### Preparing Python
Run the following command to navigate to the `python/` directory: 
```bash
cd python
```

To keep the environment isolated, create a virtual environment by running: 
```bash
# Windows
python -m venv .venv

# Linux / Mac
python3 -m venv .venv
```

Then, activate it: 
```Bash
# In Windows
.venv\Scripts\activate

# In Mac or Linux
source .venv/bin/activate
```

You will know it is active if `(.venv)` appears in your terminal prompt. 

#### Installing dependencies
In this new terminal, run: 
```bash
pip install python-dotenv
```
### Ready to fetch data!
Now, you can run `data_gather.py` to collect data. 
```bash
# In windows
python data_gather.py

# In Mac/Linux
python3 data_gather.py
```

Data will be saved to `data.csv`. Once finished, ensure that the first line of `data.csv` only contains the headers as shown in `data_template.csv`. 

## Training AI Model
Now, you will hava your `data.csv` file with all the required information. You can now open [Google Collab](https://colab.research.google.com/drive/17v4WvOgDleoOywlKYAOZHBwc0xaIOfQo?usp=sharing) to train this model. 

Follow the instructions in that Colab Notebook. After finishing, you will get a total of 3 new files: `brawler_mapping.json`, `map_mapping.json` and `draft_model.tflite`. This last file is the trained AI model that you will use. 

Delete their equivalents in `assets/data/` and paste new `.json` files there. New AI model must be located at `assets/models/`. 

## Ready to go! 
Now, you have your model trained and ready to go. Check in-app code from `lib/components/ai_service.dart`, `lib/components/brawl_service.dart` and `lib/modules/pick/pick_code.dart` to understand how data is transformed. 

>Better data. Better decisions. Higher ranks.

᠆ Wolkar