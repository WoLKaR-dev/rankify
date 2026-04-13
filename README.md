# Data Gather

Welcome to this new section. Here you will follow up step-to-step instructions to make this process easier. We will first see what files do we have here, and next we will execute our gathering script.

# How do these files work?

Here you will find 3 main files:

- `affinity.db`: Which is a database containing registers of brawlers matches in a specific map.
- `counter.db`: Contains different battles 1v1 direct match-ups (e.g. Shelly vs Frank)
- `matches.db`: Full data of all gathered matches

And last but not least: `data_gather.py` which gets data from Supercell's API

# What about other files?

Other files such as `requirements.txt` are necessary for the main execution: contains the required packages for GitHub Actions to load. You will need to import these requirements too to make the python script to work. Don't worry, you have detailed instructions on the next section.

Files called `matches.csv`, `affinity.csv` and `counter.csv` are files generated as the result of the correct execution of `data_gather.py`. These are the files you need to train our AI model. Once you got these files, you can go back to the `stable` branch and continue your `README.md` process.

# How can I run this on my PC?

## Configuring API Key

To gather data, you must use the [Brawl Stars API](https://developer.brawlstars.com/#/), for which you will need a [Developer Account](https://developer.brawlstars.com/#/register).

Once you have registered, follow these steps: `Log in > My Account > Create new API Key`.

Choose a name, write a description, and whitelist the IP address from which the data gathering will occur. If you are using your own computer, you can use [What is my IP](https://whatismyipaddress.com/) to find your IP address.

> Important: A personal computer's IP address might change between sessions or after rebooting the Wi-Fi router. Please check it every time.

Once you have your API key, create a file named `.env` and paste the following code:

```dotenv
BS_API_KEY=[API_KEY]
```

Where:

* `[BS_API_KEY]` is the key you obtained (without `[]`).

> Important: this `.env` file will not upload to git since is checked out in `.gitignore`. If you want this not to happen, you can delete the line `.env` on previous mentioned file.

## Execution

**Read this whole section fully before executing anything.**

First, you will need to create a virtual environment. This is necessary since the packages could modify system files. You can create a .venv folder like this:

**Windows**

```bash
python -m venv .venv
```

**Linux / Mac**

```bash
python3 -m venv .venv
```

And activate it:
**Windows**

```bash
.\.venv\Scripts\activate
```

**Linux / Mac**

```bash
source .venv/bin/activate
```

Now, import requirements:

```bash
pip install -r requirements.txt
```

**Important**: If you are gathering data from your own computer, uncomment the commented `dotenv` import at the upper part of `data_gather.py` and also the `load_dotenv()` line. Next, press `ctrl + f` in your code editor and replace `https://bsproxy.royaleapi.dev` with `https://api.brawlstars.com` instead. Leave the rest of the string "as is".

And now you will be able to gather data with:

**Windows**

```
python data_gather.py
```

**Linux / Mac**

```
python3 data_gather.py
```

> Once this scripts ends, you should have the required files: `matches.csv`, `affinity.csv` and `counter.csv`

Of course, this script is still optimizable but this basic version works, so we will keep this at least short-term. 

# Do I have to execute this by myself?

In fact, no! Me and GitHub already make this process for you. You can go to [releases](https://github.com/WoLKaR-dev/rankify/releases), where you will find the necessary files already exported. These files are updated every ~ 3 hours.

# Now I have the files, what follows next?

Now, you can go back to [train model section](https://github.com/WoLKaR-dev/rankify?tab=readme-ov-file#training-ai-model). There you will be able to train your model with our data files.

Thanks for reading!

