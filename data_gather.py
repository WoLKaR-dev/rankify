from time import sleep
from typing import Any
import os
import requests
import csv
import asyncio

class Metronome: 
    """Acts as a metronome to add api call rate limit.
    """

    def __init__(self, interval):
        self.interval = interval 
        self.nextCall = time.perf_counter()

    async def wait(self): 
        now = time.perf_counter()

        if self.nextCall < now :
                self.nextCall = now

        waitTime = self.nextCall - now 

        self.nextCall += self.interval

        if waitTime > 0: 
            await asyncio.sleep(waitTime)




# token
token = os.getenv("BS_API_KEY")
# create header
header = {
    "Authorization": f"Bearer {token}",
    "Accept": "application/json",
}
sem = asyncio.Semaphore(10) # creates async sem
rithm = Metronome(0.11) # ~ 9 per second

def getBattleData(battleData, playerId):
    """Gets formatted battle data from a player

    Args:
        battleData : Player data to format
        playerId : Player ID to organize teams as if local

    Returns:
        _type_: _description_
    """
    try:
        battleMap = int(battleData["event"]["id"]) # gets battle map id (...)
        battleResult = 1 if battleData["battle"]["result"] == "victory" else 0 # gets result (1 or 0)
        battleTime = battleData["battleTime"] # gets battle time
        teams = battleData["battle"]["teams"] # gets teams
        data = [battleMap, battleResult] # so far, adds map and result

        teamsData = [] # variable in which save teams

        for team in teams: 
            teamData = {"brawlers": [], "localTeam": False} # generates template data
            for player in team:
                if player["tag"] == playerId: 
                    teamData["localTeam"] = True # if the player has te host id, then the team is the hoster

                teamData["brawlers"].append(int(player["brawler"]["id"])) # append the player brawler into team brawlers

            teamsData.append(teamData) # appends data

        teamsData.sort(key=lambda x: x["localTeam"], reverse=True) # sorts teams so host team goes first

        for team in teamsData:
            for brawler in team["brawlers"]: 
                data.append(brawler) # append team brawlers in order

        data.append(battleTime) # appends data
        
        return data # returns data
    except Exception:
        return []

def isMatchRepeated(matchMatrix):
    """Check if the match is repeated

    Args:
        matchMatrix (list[Any]): Match matrix

    Returns:
        bool: `True` if repeated, `False` if not. 
    """
    if not os.path.exists("data.csv"): 
        return False # returns false if `data.csv` does not exists
    
    with open("data.csv", "r", encoding="utf-8") as data:
        reader = csv.reader(data)
        for line in reader:
            if len(line) >= 9 and str(line[0]) == str(matchMatrix[0]) and \
               str(line[1]) == str(matchMatrix[1]) and str(line[8]) == str(matchMatrix[8]):
                return True # returns true if any of the `data.csv` files contains same data. 
            
    return False # returns false by default

def addMatchToCSV(matchMatrix):
    """Adds a new matrix to the CSV

    Args:
        matchMatrix : Matrix returned from `getBattleData()`
    """
    with open("data.csv", "a", newline="", encoding="utf-8") as data:
        writer = csv.writer(data)
        writer.writerow(matchMatrix) # adds the row

def getRankingPlayers():
    """Síncrona está bien porque solo son 10 llamadas al inicio."""
    players = [] # all players
    countryCodes = ["global", "es", "jp", "it", "de", "fr", "ru", "us", "kr", "gb", "mx", "pe", "tr", "ua", "pl", "ro", "ca", "nl"] # country codes to study
    for code in countryCodes:
        result = requests.get(f"https://bsproxy.royaleapi.dev/v1/rankings/{code}/players", headers=header) # result of the call
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
    tag_url = tag.replace("#", "%23") # replaces tag

    url = f"https://bsproxy.royaleapi.dev/v1/players/{tag_url}/battlelog" # creates url

    async with session.get(url, headers=header) as response: # waits for the response
        if response.status == 200:
            data = await response.json()
            await asyncio.sleep(0.1)
            return data.get("items", []) # gets the item list or empty.
        return []

async def process_player(session, player, index):
    tag = player["tag"]# player tag
    name = player["name"] # get player name (visual only)
    new_matches = 0 # create new matches counter 

    await rithm.wait()

    async with sem: # 10 concurrent battles
        log = await getPlayerBattleLog_async(session, tag) # gets log
        print(f"Gathering from: n{index} - {name}")

    for battle in log:
        try:
            if battle.get("battle", {}).get("type") == "soloRanked":
                processed = getBattleData(battle, tag)
                if processed and not isMatchRepeated(processed):
                    addMatchToCSV(processed)
                    new_matches += 1
        except Exception:
            continue
    return new_matches

async def main():
    ranking = getRankingPlayers() # get ranking players
    print(f"Obtained {len(ranking)} players. Starting async logs...")
    
    writtenMatchCounter = 0
    
    async with aiohttp.ClientSession() as session:
        tasks = []
        for i, player in enumerate(ranking):
            tasks.append(process_player(session, player, i + 1))
        
        results = await asyncio.gather(*tasks)
        writtenMatchCounter = sum(results)

    print(f"Data gather ended. {writtenMatchCounter} new matches added.")

if __name__ == "__main__":