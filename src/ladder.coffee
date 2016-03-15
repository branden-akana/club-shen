---
---

window.onload = () ->
	init()

#key = "1yt5jFdwrQR3ZPAuzz2y_Z3snwRF7aMA_514d4joSt1A"

Function::property = (prop, desc) ->
	Object.defineProperty @prototype, prop, desc

class Elo
	@tier: (rating) ->
		if rating >= 2050 then return "S"
		else if rating >= 1350 then return "A"
		else if rating >= 850 then return "B"
		else return "C"

class Game
	constructor: (@challenger, @defender, @winner, @cCharacter, @dCharacter, @stage) ->

	getChallenger: () ->
	getDefender: () ->
	getWinner: () ->
	getChallengerPick: () ->
	getDefenderPick: () ->
	getStage: () ->

class MatchSet
	constructor: (@challenger, @defender, @winner, @games) ->

class Matches
	constructor: (@values) ->

	getGamesPlayed: (username) ->
		games = 0
		for row in @values
			if row[4] == username || row[7] == username then games++
		return games

	getGamesWon: (username) ->
		games = 0
		for row in @values
			if row[4] == username && row[3] == "Challenger" || row[7] == username && row[3] == "Defender" then games++
		return games

	getGamesLost: (username) ->
		games = 0
		for row in @values
			if row[4] == username && row[3] == "Defender" || row[7] == username && row[3] == "Challenger" then games++
		return games

	getWinStreak: (username) ->
		games = 0
		for row in @values
			# player won
			if row[4] == username && row[3] == "Challenger" || row[7] == username && row[3] == "Defender" then games++
			# player lost
			else if row[4] == username && row[3] == "Defender" || row[7] == username && row[3] == "Challenger" then games = 0
		return games



class Ladder
	@players: []

	@load: (@key) ->
		Tabletop.init({
			key: @key
			callback: @update
			wanted: ["Statistics", "Matches"]
			orderby: "rank"
		})

	@update: (data, tabletop) ->

		console.log data

		table = data["Statistics"].all()
		Ladder.matches = new Matches(data["Matches"].toArray())

		for row in table
			console.log(row.length)

			player = new Player(row["Username"], Ladder.matches)

			player.displayname = row["Display Name"]
			player.rank = row["Rank"]
			player.rating = row["Rating"]
			player.rank_last = row["Rank Last"]
			player.tier = Elo.tier(player.rating)

			Ladder.players.push player

		for player in Ladder.players

			playerRankChange = player.getRankChange();

			if playerRankChange == 0 then rankChangeClass = "rank-change__none"
			if playerRankChange > 0  then rankChangeClass = "rank-change__raise"
			if playerRankChange < 0  then rankChangeClass = "rank-change__lower"

			$( "ul.ladder-rankings" ).append """
				<li>
				<div class="player tier-#{ player.getTier().toLowerCase() } rank-#{ player.getRank() } rating-#{ player.getRating() }">
						<div class="rank">#{ player.getRank() }</div>
						<div class="rank-change #{ rankChangeClass }">#{ player.getRankChange() }</div>
						<div class="name">#{ player.getName() }</div>
						<div class="games">#{ player.getGamesPlayed() } Games #{ if player.getWinStreak() > 0 then "(#{ player.getWinStreak() } game win streak)" else "" }</div>
						<div class="tier">#{ player.getTier() }</div>
				</div>
				</li>
			"""

class Player
	constructor: (@username, @matches) ->

	getRankChange: () ->
		diff = @rank_last - @rank;
		if diff > 0 then return "+" + diff;
		else return diff;
	getRating: () -> @rating
	getRank: () -> @rank
	getTier: () -> @tier
	getUsername: () -> @username
	getName: () -> @displayname
	getGamesPlayed: () -> @matches.getGamesPlayed(@username)
	getGamesWon: () -> @matches.getGamesWon(@username)
	getWinStreak: () -> @matches.getWinStreak(@username)

init = () ->
	Ladder.load("https://docs.google.com/spreadsheets/d/1aNji1A2YqsDZldwpqv-pybWnV4ITKafV8fththQCB2I/pubhtml")
