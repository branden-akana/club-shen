---
---

window.onload = () ->
	init()

#key = "1yt5jFdwrQR3ZPAuzz2y_Z3snwRF7aMA_514d4joSt1A"

init = () ->
	Tabletop.init({
		key: "https://docs.google.com/spreadsheets/d/1yt5jFdwrQR3ZPAuzz2y_Z3snwRF7aMA_514d4joSt1A/pubhtml",
		callback: update
	})

update = (data, tabletop) ->
	data = tabletop.sheets("Rankings").toArray()
	tier = ""

	# 0: tier
	# 1: rank
	# 2: player
	for row in data
		tier = row[0].toLowerCase()
		rank = row[1]
		player = row[2]

		if tier != "" then @tier = tier

		if player != ""
			$( ".player-ranks > ul" ).append """
				<li>
				<div class="player tier-#{ @tier }">
						<div class="rank">#{ rank }</div>
						<div class="name">#{ player }</div>
				</div>
				</li>
			"""
