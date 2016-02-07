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
	rows = data.rankings.all()
	bracket = ""
	for obj in rows
		if obj.Bracket != "" then bracket = obj.Bracket
		$( ".player-ranks > ul" ).append """
			<li class="player bracket-#{ bracket.toLowerCase() }">

					<div class="rank">#{ obj.Rank }</div>
					<div class="name">#{ obj.Player }</div>

			</li>
		"""
