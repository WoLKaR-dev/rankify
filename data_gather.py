from time import sleep
from typing import Any
import os
import requests
import csv


# token
token = os.getenv("BS_API_KEY")

# create header
header = {
    "Authorization": f"Bearer {token}",
    "Accept": "application/json",
}


def getBattleData(battleData, playerId):
    """Returns a processed player data, ready for csv.
    If an error occurs, returns an empty list.

    Args:
        battleData : main battle data.
        playerId : local team's player id.
    """

    data = []

    try:
        battleMap = int(battleData["event"]["id"])  # Simply the battle map
        battleResult = (
            1 if battleData["battle"]["result"] == "victory" else 0
        )  # Battle result
        battleTime = battleData["battleTime"]
        teams = battleData["battle"][
            "teams"
        ]  # Battle teams. Usually: [ [plr1, ..., plr3], [plr4, ..., plr6] ]

        data = [battleMap, battleResult]  # reasign data

        teamsData = []  # format: { brawlers: [...], localTeam: bool }

        for team in teams:  # processing teams
            teamData = {"brawlers": [], "localTeam": False}  # init format

            for player in team:  # processing each player of the team
                isHostingGame = (
                    player["tag"] == playerId
                )  # check if the player is the host

                if isHostingGame:
                    teamData["localTeam"] = True  # flags the host if true

                brawler = int(player["brawler"]["id"])

                teamData["brawlers"].append(brawler)  # adds brawler

            teamsData.append(teamData)  # add team data

        # sorting list so host team gets first position
        teamsData.sort(key=lambda x: x["localTeam"], reverse=True)

        # add hoster brawlers first
        for team in teamsData:
            for brawler in team["brawlers"]:
                data.append(brawler)  # adds brawlers

        data.append(battleTime)  # adding timestamp

        return data

    except Exception:
        print("An error ocurred getting battle data")
        return data

def getRankingPlayers():
    """Gets brawl stars main global ranking (trophies.)"""
    players = []  # total players

    # main country codes
    countryCodes = ["global", "es", "jp", "it", "de", "fr", "ru", "us", "kr", "gb"]

    for code in countryCodes:
        #fetch data
        result = requests.get(
            f"https://bsproxy.royaleapi.dev/v1/rankings/{code}/players", headers=header
        )
        if result.status_code == 200:
            try:
                data = result.json()

                rankingPlayers = data["items"]

                for player in rankingPlayers: 
                    players.append(player)

            except Exception:
                pass
        sleep(0.1)
        
    print(f"Obtained data from {len(players)} players.")

    return players

def getPlayerBattleLog(tag: str):
    """Gets player battle log from a player tag.

    Args:
        tag (str): Player tag, including the `#` character.
    """
    tag = tag.replace("#", "%23")  # important to replace critic characters
    playerLogRequest = requests.get(
        "https://bsproxy.royaleapi.dev/v1/players/" + tag + "/battlelog",
        headers=header,
    )  # making the request
    if playerLogRequest.status_code == 200:  # checking the status
        # print("Battle log obtained successfully")
        playerLogJSON = playerLogRequest.json()
        playerLog = playerLogJSON["items"]
        return playerLog  # returning log.
    else:
        # print(f"Battle log error: {playerLogRequest.status_code} ")
        return []

def isMatchRepeated(matchMatrix: list[Any]):
    """Inspects every line of `data.csv`, ensuring that the match does
    not extist.

    Args:
        matchMatrix (list[Any]): The `getBattleData` returned matrix.

    Returns:
        bool: `true` if exists, `false` if not.
    """
    with open("data.csv", "r", encoding="utf-8") as data:
        reader = csv.reader(data)
        for line in reader:
            if (
                str(line[0]) == str(matchMatrix[0])
                and str(line[1]) == str(matchMatrix[1])
                and str(line[8]) == str(matchMatrix[8])
            ):
                return True
        return False

def addMatchToCSV(matchMatrix: list[Any]):
    with open("data.csv", "a", newline="", encoding="utf-8") as data:
        writer = csv.writer(data)
        writer.writerow(matchMatrix)

ranking = getRankingPlayers()  # get ranking
counter = 1 # number of player (visual purpose only)
writtenMatchCounter = 0

for player in ranking:
    name: str = player["name"]  # just visual for terminal only

    print(f"Gathering from: n{counter} - {name}")

    tag: str = player["tag"]  # get tag

    log = getPlayerBattleLog(tag)  # get log from tag


    for battle in log:
        # print(f"Battle found: {battle}")

        try:
            if battle["battle"]["type"] == "soloRanked":  # only solo ranked games
                processedBattle: list[Any] = getBattleData(
                    battle, tag
                )  # get battle data formatted

                # print(f"formatted battle: {processedBattle}")

                if len(processedBattle) != 0:
                    exists = isMatchRepeated(processedBattle)

                    # print(f"battle status: exists: {exists}")

                    if not exists:
                        addMatchToCSV(processedBattle)  # simply adds the formated data
                        writtenMatchCounter += 1

        except Exception:
            pass

    counter += 1
    sleep(0.1)

print(f"Data gather ended. ${writtenMatchCounter} new matches added. ")
