---
---

window.onload = () ->
	init()

#key = "1yt5jFdwrQR3ZPAuzz2y_Z3snwRF7aMA_514d4joSt1A"

Function::property = (prop, desc) ->
	Object.defineProperty @prototype, prop, desc

slugify = (string) ->
	return string
		.toLowerCase()
		.replace(/[^\w ]+/g, "")
		.replace(/ +/g, "-")

class Player
	constructor: (@username, @matches) ->
		characters = @matches.getCharactersUsed(@username)
		@characters = []
		if characters.length == 0 then return
		counts = {}
		for character in characters
			counts[character] = if character of counts then counts[character] + 1 else 1
		for character, count of counts
			@characters.push [character, (Math.round(count / characters.length * 100 * 100) / 100)]
		@characters.sort((a, b) -> b[1] - a[1])

	getRankChange: ->
		diff = @rank_last - @rank;
		if diff > 0 then return "+" + diff;
		else return diff;

	getRating: -> @rating
	getRank: -> @rank
	getTier: -> @tier
	getUsername: -> @username
	getName: -> @displayname
	getGamesPlayed: -> @matches.getGamesPlayed(@username)
	getGamesWon: -> @matches.getGamesWon(@username)
	getWinStreak: -> @matches.getWinStreak(@username)
	hasCharacterMain: -> @characters.length != 0
	getCharacterMain: -> if @characters.length == 0 then "" else @characters[0]
	getCharacterImage: -> if @characters.length == 0 then "" else "/img/stock/#{ slugify @characters[0][0] }.png"

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

	getCharactersUsed: (username) ->
		characters = []
		for row in @values
			if row[4] == username
				if row[10] != "" then characters.push row[10]
				if row[14] != "" then characters.push row[14]
				if row[18] != "" then characters.push row[18]
				if row[22] != "" then characters.push row[22]
				if row[26] != "" then characters.push row[26]
			else if row[7] == username
				if row[11] != "" then characters.push row[11]
				if row[15] != "" then characters.push row[15]
				if row[19] != "" then characters.push row[19]
				if row[23] != "" then characters.push row[23]
				if row[27] != "" then characters.push row[27]
		return characters

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
			console.log player
			Ladder.players.push player

		for player in Ladder.players


			playerRankChange = player.getRankChange()

			if playerRankChange == 0 then rankChangeClass = "rank-change__none"
			if playerRankChange > 0  then rankChangeClass = "rank-change__raise"
			if playerRankChange < 0  then rankChangeClass = "rank-change__lower"

			$( "ul.ladder--rankings" ).append """
				<li>
				<div class="player tier-#{ player.getTier().toLowerCase() } rank-#{ player.getRank() } rating-#{ player.getRating() }">
						<div class="rank">#{ player.getRank() }</div>
						<div class="rank-change #{ rankChangeClass }">#{ player.getRankChange() }</div>
						<div class="name">#{ player.getName() }</div>
						<div class="games">#{ player.getGamesPlayed() } Games</div>
						#{ if player.hasCharacterMain() then "<div class=\"main\"><img title=\"#{ "Played " + player.getCharacterMain()[1] + "%" }\" src=#{ player.getCharacterImage() } alt=#{ player.getCharacterMain()[0] }></div>" else "" }
				</div>
				</li>
			"""

init = () ->
	skrollr.init()
	Ladder.load "https://docs.google.com/spreadsheets/d/1aNji1A2YqsDZldwpqv-pybWnV4ITKafV8fththQCB2I/pubhtml"
