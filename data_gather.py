#    Rankify is an Open Source AI app made to help brawl stars players reach higher ranks.
#    Copyright (C) 2026 WoLKaR-dev
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see https://www.gnu.org/licenses/

import os
import requests
import asyncio
import time
import aiohttp
import sqlite3
import hashlib
import pandas as pd

#NOTE: Remember to comment if using on a server or uncomment if working locally. Both lines
# from dotenv import load_dotenv #
# load_dotenv() # 


# SETTINGS:
matches_limit = 300000
counter_limit = 200000
affinity_limit = 100000


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
matches_conn = sqlite3.connect("matches.db")  # gets matches database
affinity_conn = sqlite3.connect("affinity.db")  # gets affinity database
counter_conn = sqlite3.connect("counter.db")  # gets counter database
matches_csv_path = "matches.csv"  # just matches csv
affinity_csv_path = "affinity.csv"  # affinity csv file
counter_csv_path = "counter.csv"  # counter csv file
matches_writer = matches_conn.cursor()  # creates matches cursor
affinity_writer = affinity_conn.cursor()  # creates affinity cursor
counter_writer = counter_conn.cursor()  # creates counter cursor


# Runtime data
matches_data = []  # here we add each battle data
affinity_data = []  # add here affinity data
counter_data = []  # and here counter data

# =====
# Main Workflow
# =====


def initDataBases():
    # init matches database
    matches_writer.execute("""
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

    # init affinity database
    affinity_writer.execute("""
    CREATE TABLE IF NOT EXISTS affinity (
    map INTEGER,
    result INTEGER,
    host INTEGER, 
    id TEXT PRIMARY KEY,
    order_index INTEGER   
    )
    """)

    # init counter database
    counter_writer.execute("""
    CREATE TABLE IF NOT EXISTS counter (
    map INTEGER, 
    result INTEGER, 
    host INTEGER, 
    no_host INTEGER, 
    id TEXT PRIMARY KEY, 
    order_index INTEGER
    )
    """)

def getRankingPlayers():
    """Gets ranking players data"""
    players = []  # all players
    country_codes = [
        "global",
        "es",  # Spain
        "jp",  # Japan
        "it",  # Italy
        "de",  # Germany
        "fr",  # France
        "us",  # United States
        "kr",  # South Korea
        "gb",  # Great Britain
        "mx",  # Mexico
        "pe",  # Peru
        "tr",  # Turkey
        "ua",  # Ukraine
        "pl",  # Poland
        "ro",  # Romania
        "ca",  # Canada
        "nl",  # Netherlands
    ]  # country codes to study
    for code in country_codes:
        result = requests.get(
            f"https://bsproxy.royaleapi.dev/v1/rankings/{code}/players", headers=header
        )  # result of the call
        if result.status_code == 200:  # status_code == 200 means success
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
                if processed:
                    processAffinity(processed)
                    processCounter(processed)
                    processMatch(processed)
                    new_matches += 1
        except Exception:
            continue
    return new_matches

async def main():
    ranking = getRankingPlayers()  # get ranking players

    initDataBases()  # and also init databases

    print(f"Obtained {len(ranking)} players. Starting async logs...")

    async with aiohttp.ClientSession() as session:
        tasks = []
        for i, player in enumerate(ranking):
            tasks.append(process_player(session, player, i + 1))

        await asyncio.gather(*tasks)

    saveMatches()  # add data to db
    saveAffinity()
    saveCounter()

    print("Data gather ended.")


# =====
# Data Transformation
# =====


def getBattleData(battleData, playerId):
    """Gets formatted battle data from a player

    Args:
        battleData : Player data to format
        playerId : Player ID to organize teams as if local

    Returns:
        list: Formatted battle data, or empty list on error.
    """
    try:
        battle_map = int(battleData["event"]["id"])  # gets battle map id (...)
        battle_result = (
            1 if battleData["battle"]["result"] == "victory" else 0
        )  # gets result (1 or 0)
        battle_time = battleData["battleTime"]  # gets battle time
        teams = battleData["battle"]["teams"]  # gets teams

        teams_data = []  # variable in which save teams

        for team in teams:
            team_data = {"brawlers": [], "localTeam": False}  # generates template data
            for player in team:
                if player["tag"] == playerId:
                    team_data["localTeam"] = (
                        True  # if the player has te host id, then the team is the hoster
                    )

                team_data["brawlers"].append(
                    int(player["brawler"]["id"])
                )  # append the player brawler into team brawlers

            teams_data.append(team_data)  # appends data

        teams_data.sort(
            key=lambda x: x["localTeam"], reverse=True
        )  # sorts teams so host team goes first

        brawlers = []
        for team in teams_data:
            for brawler in team["brawlers"]:
                brawlers.append(brawler)  # append team brawlers in order

        data_list = [battle_map, battle_result]
        data_list.extend(brawlers)
        data_list.append(battle_time)

        return data_list
    except Exception:
        print("error")
        return []


def processMatch(battle_log: list):
    """Processes a battle log

    Args:
        battleLog : Is the battle log to add, a tuple with this format: [
        map: int,
        result: int,
        ally1:  int,
        ally2: int,
        ally3: int,
        enemy1: int,
        enemy2: int,
        enemy3: int,
        timestamp: str
        ]
    """

    # get the id key
    key_id = f"{'_'.join(map(str, battle_log))}"

    # build the new hash
    created_hash = hashlib.md5(key_id.encode()).hexdigest()

    # remove timestamp
    battle_log.pop()

    # add hash
    battle_log.append(created_hash)

    # add none order_index
    battle_log.append(None)

    # transform to tuple
    battle_log = tuple(battle_log)

    # append changes
    matches_data.append(battle_log)


def processAffinity(battle_log):
    """Processes a battle log to create an affinity entry
    Args:
        battleLog : Is the battle log to add, a tuple with this format: [
        map: int,
        result: int,
        ally1:  int,
        ally2: int,
        ally3: int,
        enemy1: int,
        enemy2: int,
        enemy3: int,
        timestamp: str
        ]
    """

    for number in range(len(battle_log)):
        # if brawler hosts match
        if number > 1 and number < 5:  # if brawler hosts match
            # get the brawler
            brawler = battle_log[number]

            # generate id
            key_id = f"{str(battle_log[0])}_{str(battle_log[1])}_{str(brawler)}_{str(battle_log[8])}"

            # build hash
            created_hash = hashlib.md5(key_id.encode()).hexdigest()

            # append data
            affinity_data.append((battle_log[0], battle_log[1], brawler, created_hash, None))

        # if brawler does not host match
        elif number > 4 and number < 8:
            # get the brawler
            brawler = battle_log[number]

            # invert the result
            result = 0 if battle_log[1] == 1 else 1

            # generate id
            key_id = f"{str(battle_log[0])}_{str(result)}_{str(brawler)}_{str(battle_log[8])}"

            # build hash
            created_hash = hashlib.md5(key_id.encode()).hexdigest()

            # append data
            affinity_data.append((battle_log[0], result, brawler, created_hash, None))


def processCounter(battle_log):
    """Processes a battle log to create a counter entry
    Args:
        battleLog : Is the battle log to add, a tuple with this format: [
        map: int,
        result: int,
        ally1:  int,
        ally2: int,
        ally3: int,
        enemy1: int,
        enemy2: int,
        enemy3: int,
        timestamp: str
        ]
    """

    for number in range(len(battle_log)):
        # if brawler is hoster
        if number > 1 and number < 5:
            # get host brawler
            host_brawler = battle_log[number]

            # for each no host brawler
            for no_host_number in range(5, 8):
                # get no host brawler (enemy)
                no_host_brawler = battle_log[no_host_number]

                # generate key id
                key_id = f"{str(battle_log[0])}_{str(battle_log[1])}_{str(host_brawler)}_{str(no_host_brawler)}_{str(battle_log[8])}"

                # build hash
                created_hash = hashlib.md5(key_id.encode()).hexdigest()

                # append data
                counter_data.append(
                    (
                        battle_log[0],
                        battle_log[1],
                        host_brawler,
                        no_host_brawler,
                        created_hash,
                        None,
                    )
                )

        # if brawler is not hoster (enemy team POV)
        elif number > 4 and number < 8:
            # invert the result
            result = 0 if battle_log[1] == 1 else 1

            # get no host brawler
            no_host_brawler = battle_log[number]

            # for each host brawler
            for host_number in range(2, 5):
                # host brawler
                host_brawler = battle_log[host_number]

                # generate key id
                key_id = f"{str(battle_log[0])}_{str(result)}_{str(no_host_brawler)}_{str(host_brawler)}_{str(battle_log[8])}"

                # build hash
                created_hash = hashlib.md5(key_id.encode()).hexdigest()

                # append counter data
                counter_data.append(
                    (
                        battle_log[0],
                        result,
                        no_host_brawler,
                        host_brawler,
                        created_hash,
                        None,
                    )
                )


# =====
# Data Saving
# =====


def saveAffinity():
    # adding all data into affinity.db
    affinity_writer.executemany(
        """
    INSERT OR IGNORE INTO affinity 
    VALUES (?, ?, ?, ?, ?)
    """,
        affinity_data,
    )

    # does clean up using COALESCE
    affinity_writer.execute(f"""
    DELETE FROM affinity
    WHERE id NOT IN (
        SELECT id FROM affinity
        ORDER BY COALESCE(order_index, 1000000000) DESC, rowid DESC
        LIMIT {str(affinity_limit)}                  
    ); 
    """)

    try:
        affinity_writer.execute("DROP TABLE IF EXISTS affinity_tmp")
        affinity_writer.execute("""
        CREATE TABLE affinity_tmp(
            map INTEGER,
            result INTEGER,
            host INTEGER, 
            id TEXT PRIMARY KEY,
            order_index INTEGER             
        )
        """)

        # move data while generating a perfect contiguous index
        affinity_writer.execute("""
        INSERT INTO affinity_tmp
        SELECT map, result, host, id,
               (ROW_NUMBER() OVER (ORDER BY COALESCE(order_index, 1000000000) ASC, rowid ASC) - 1)
        FROM affinity
        """)

        # swap tables
        affinity_writer.execute("DROP TABLE affinity")
        affinity_writer.execute("ALTER TABLE affinity_tmp RENAME TO affinity")
        affinity_conn.commit()

    except Exception as e:
        affinity_conn.rollback()
        print(f"Re-indexing failed (affinity): {e}")

    if os.path.exists(affinity_csv_path):
        os.remove(affinity_csv_path)

    # export final sorted CSV
    df = pd.read_sql_query(
        "SELECT * FROM affinity ORDER BY order_index ASC", affinity_conn
    )

    # save as csv
    df.to_csv(affinity_csv_path, index=False)

    # close connection
    affinity_writer.close()


def saveCounter():
    # adding all data into counter.db
    counter_writer.executemany(
        """
    INSERT OR IGNORE INTO counter 
    VALUES (?, ?, ?, ?, ?, ?)
    """,
        counter_data,
    )

    # does clean up using COALESCE
    counter_writer.execute(f"""
    DELETE FROM counter
    WHERE id NOT IN (
        SELECT id FROM counter
        ORDER BY COALESCE(order_index, 1000000000) DESC, rowid DESC
        LIMIT {str(counter_limit)}                  
    ); 
    """)

    try:
        counter_writer.execute("DROP TABLE IF EXISTS counter_tmp")
        counter_writer.execute("""
        CREATE TABLE counter_tmp(
            map INTEGER,
            result INTEGER,
            host INTEGER, 
            no_host INTEGER,
            id TEXT PRIMARY KEY,
            order_index INTEGER             
        )
        """)

        # move data while generating a perfect contiguous index
        counter_writer.execute("""
        INSERT INTO counter_tmp
        SELECT map, result, host, no_host, id,
               (ROW_NUMBER() OVER (ORDER BY COALESCE(order_index, 1000000000) ASC, rowid ASC) - 1)
        FROM counter
        """)

        # swap tables
        counter_writer.execute("DROP TABLE counter")
        counter_writer.execute("ALTER TABLE counter_tmp RENAME TO counter")
        counter_conn.commit()

    except Exception as e:
        counter_conn.rollback()
        print(f"Re-indexing failed (counter): {e}")

    if os.path.exists(counter_csv_path):
        os.remove(counter_csv_path)

    # export final sorted CSV
    df = pd.read_sql_query(
        "SELECT * FROM counter ORDER BY order_index ASC", counter_conn
    )

    # save as csv
    df.to_csv(counter_csv_path, index=False)

    # close connection
    counter_writer.close()


def saveMatches():

    # adds all data into the .db ignores if id already exists
    matches_writer.executemany(
        """
    INSERT OR IGNORE INTO matches
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """,
        matches_data,
    )

    # does cleanup using COALESCE to treat NULLs as "newest" (very high order_index)
    matches_writer.execute(f"""
    DELETE FROM matches
    WHERE id NOT IN (
        SELECT id FROM matches
        ORDER BY COALESCE(order_index, 1000000000) DESC, rowid DESC
        LIMIT {str(matches_limit)}
    );
    """)

    try:
        # create a temporary table with the same structure
        matches_writer.execute("DROP TABLE IF EXISTS matches_tmp")
        matches_writer.execute("""
        CREATE TABLE matches_tmp(
            map INTEGER, result INTEGER,
            ally1 INTEGER, ally2 INTEGER, ally3 INTEGER,
            enemy1 INTEGER, enemy2 INTEGER, enemy3 INTEGER,
            id TEXT PRIMARY KEY, order_index INTEGER
        )
        """)

        # move data while generating a perfect contiguous index
        matches_writer.execute("""
        INSERT INTO matches_tmp
        SELECT map, result, ally1, ally2, ally3, enemy1, enemy2, enemy3, id,
               (ROW_NUMBER() OVER (ORDER BY COALESCE(order_index, 1000000000) ASC, rowid ASC) - 1)
        FROM matches
        """)

        # swap tables
        matches_writer.execute("DROP TABLE matches")
        matches_writer.execute("ALTER TABLE matches_tmp RENAME TO matches")
        matches_conn.commit()

    except Exception as e:
        matches_conn.rollback()
        print(f"Re-indexing failed: {e}")

    if os.path.exists(matches_csv_path):
        os.remove(matches_csv_path)

    # export final sorted CSV
    df = pd.read_sql_query(
        "SELECT * FROM matches ORDER BY order_index ASC", matches_conn
    )

    # save as csv
    df.to_csv(matches_csv_path, index=False)

    # close connection
    matches_writer.close()


if __name__ == "__main__":
    asyncio.run(main())
