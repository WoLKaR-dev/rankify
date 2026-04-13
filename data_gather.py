import os
import requests
import asyncio
import time
import aiohttp
import sqlite3
import hashlib
import pandas as pd

class Metronome:
    """Acts as a metronome to add api call rate limit."""

    def __init__(self, interval):
        self.interval = interval
        self.nextCall = time.perf_counter()

    async def wait(self):
        now = time.perf_counter()

        if self.nextCall < now:
            self.nextCall = now

        waitTime = self.nextCall - now

        self.nextCall += self.interval

        if waitTime > 0:
            await asyncio.sleep(waitTime)


# Required data
token = os.getenv("BS_API_KEY")  # gets api key
header = {  # define header
    "Authorization": f"Bearer {token}",
    "Accept": "application/json",
}

# Limiters
sem = asyncio.Semaphore(10)  # creates async sem
rithm = Metronome(0.11)  # ~ 9 per second

# Database related
conn = sqlite3.connect("matches.db")  # gets database
csv_path = "matches.csv"  # just matches csv
writer = conn.cursor()  # creates cursor


# Runtime data
gatheredData = []  # here we add each battle data


def initDataBase():
    writer.execute("""
    CREATE TABLE IF NOT EXISTS matches(
    map INTEGER,
    result INTEGER,
    ally1 INTEGER,
    ally2 INTEGER,
    ally3 INTEGER,
    enemy1 INTEGER,
    enemy2 INTEGER,
    enemy3 INTEGER,
    id TEXT PRIMARY KEY,
    order_index INTEGER
    )
    """)

def getBattleData(battleData, playerId):
    """Gets formatted battle data from a player

    Args:
        battleData : Player data to format
        playerId : Player ID to organize teams as if local

    Returns:
        tuple | list: Formatted battle data, or empty list on error.
    """
    try:
        battleMap = int(battleData["event"]["id"])  # gets battle map id (...)
        battleResult = (
            1 if battleData["battle"]["result"] == "victory" else 0
        )  # gets result (1 or 0)
        battleTime = battleData["battleTime"]  # gets battle time
        teams = battleData["battle"]["teams"]  # gets teams

        teamsData = []  # variable in which save teams

        for team in teams:
            teamData = {"brawlers": [], "localTeam": False}  # generates template data
            for player in team:
                if player["tag"] == playerId:
                    teamData["localTeam"] = (
                        True  # if the player has te host id, then the team is the hoster
                    )

                teamData["brawlers"].append(
                    int(player["brawler"]["id"])
                )  # append the player brawler into team brawlers

            teamsData.append(teamData)  # appends data

        teamsData.sort(
            key=lambda x: x["localTeam"], reverse=True
        )  # sorts teams so host team goes first

        brawlers = []
        for team in teamsData:
            for brawler in team["brawlers"]:
                brawlers.append(brawler)  # append team brawlers in order

        key = f"{battleMap}_{battleResult}_{battleTime}"  # here we generate unique id
        newHash = hashlib.md5(key.encode()).hexdigest()  # unique id

        dataList = [battleMap, battleResult]
        dataList.extend(brawlers)
        dataList.append(newHash)
        dataList.append(None)  # order_index placeholder, assigned after INSERT

        return tuple(dataList)  # now we get tuple
    except Exception:
        print("error")
        return []

def saveMatches():
    """Adds new matches to the DB and exports a CSV."""
    writer.executemany("""
    INSERT OR IGNORE INTO matches
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, gatheredData)  # add data; duplicates are silently ignored

    # assign order_index only to rows that have none (i.e. newly inserted rows).
    writer.execute("""
    UPDATE matches
    SET order_index = (
        SELECT COUNT(*) - 1
        FROM matches AS m2
        WHERE m2.rowid <= matches.rowid
          AND m2.order_index IS NULL
    ) + COALESCE((SELECT MAX(order_index) FROM matches WHERE order_index IS NOT NULL), -1) + 1
    WHERE order_index IS NULL
    """)

    # keep only the 300,000 most recent matches
    writer.execute("""
    DELETE FROM matches
    WHERE id NOT IN (
        SELECT id FROM matches
        ORDER BY order_index DESC
        LIMIT 300000
    );
    """)

    # Re-normalize order_index so it always starts from 0 and is contiguous.
    # This prevents the index from growing indefinitely.
    writer.execute("""
    UPDATE matches
    SET order_index = (
        SELECT COUNT(*) - 1
        FROM matches AS m2
        WHERE m2.order_index <= matches.order_index
    )
    """)

    conn.commit()  # persist changes

    if os.path.exists(csv_path):  # remove previous csv
        os.remove(csv_path)

    df = pd.read_sql_query("SELECT * FROM matches ORDER BY order_index ASC", conn)  # get all data

    df.to_csv(csv_path, index=False)  # export csv

    writer.close()  # close connection

def getRankingPlayers():
    """Gets ranking players data"""
    players = []  # all players
    countryCodes = [
        "global",
        "es",
        "jp",
        "it",
        "de",
        "fr",
        "ru",
        "us",
        "kr",
        "gb",
        "mx",
        "pe",
        "tr",
        "ua",
        "pl",
        "ro",
        "ca",
        "nl",
    ]  # country codes to study
    for code in countryCodes:
        result = requests.get(
            f"https://bsproxy.royaleapi.dev/v1/rankings/{code}/players", headers=header
        )  # result of the call
        if result.status_code == 200:
            players.extend(result.json().get("items", []))
    return players

async def getPlayerBattleLog_async(session, tag):
    """Gets matches from player

    Args:
        session ():
        tag (string): Player tag

    Returns:
        list[...]: Gets player matches
    """
    tag_url = tag.replace("#", "%23")  # replaces tag

    url = f"https://bsproxy.royaleapi.dev/v1/players/{tag_url}/battlelog"  # creates url

    async with session.get(url, headers=header) as response:  # waits for the response
        if response.status == 200:
            data = await response.json()
            await asyncio.sleep(0.1)
            return data.get("items", [])  # gets the item list or empty.
            return []

async def process_player(session, player, index):
    tag = player["tag"]  # player tag
    name = player["name"]  # get player name (visual only)
    new_matches = 0  # create new matches counter

    await rithm.wait()

    async with sem:  # 10 concurrent battles
        log = await getPlayerBattleLog_async(session, tag)  # gets log
        print(f"Gathering from: n{index} - {name}")

    for battle in log:
        try:
            if battle.get("battle", {}).get("type") == "soloRanked":
                processed = getBattleData(battle, tag)
                if processed :
                    gatheredData.append(processed) # add data to global data
                    new_matches += 1
        except Exception:
            continue
    return new_matches

async def main():
    ranking = getRankingPlayers()  # get ranking players
    initDataBase() # and also init matches.db
    print(f"Obtained {len(ranking)} players. Starting async logs...")

    writtenMatchCounter = 0

    async with aiohttp.ClientSession() as session:
        tasks = []
        for i, player in enumerate(ranking):
            tasks.append(process_player(session, player, i + 1))

        results = await asyncio.gather(*tasks)
        writtenMatchCounter = sum(results)

    saveMatches() # add data to db

    print(f"Data gather ended. {writtenMatchCounter} new matches added.")

if __name__ == "__main__":
    asyncio.run(main())
