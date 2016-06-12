---
---

class Session

	constructor: () ->

	@user: null

	@token: null

class Database

	constructor: () ->

	@read: (path, callback) ->
		firebase.database().ref(path).once('value', (snapshot) -> callback(snapshot.val()))

	# get match by ID
	@getMatches: (callback) ->
		firebase.database().ref("/ladders/smash-4/matches").once('value', (snapshot) -> callback(Match.createList(snapshot.val())))


window.addEventListener 'load', () ->
	provider = new firebase.auth.GoogleAuthProvider();

	firebase.auth().getRedirectResult().catch((error) ->
		console.log "error code: " + error.code
		console.log error.message
	)

	firebase.auth().onAuthStateChanged((user) ->
		if(user)
			Session.user = user
			console.log("uid: " + user.uid)
			# replace sign-in button with indication that you're already signed in
			$("#sign-in-button").text(user.email).addClass("signed-in")

			# create new user in database, if it doesn't exist
			firebase.database().ref('/users').child(user.uid).once('value', (snapshot) ->
				if(!snapshot.val())
					console.log("created user profile")
					firebase.database().ref('/users/' + user.uid).set({
						name: user.displayName
						email: user.email
						displayName: user.displayName
					})
			)

		else
			# initialize sign-in button
			$("#sign-in-button").click((e) ->
				e.preventDefault();
				firebase.auth().signInWithRedirect(provider);
			)
	)

	Database.getMatches (matches) ->
		console.log(matches)
		for id, match of matches
			$(".match-list").append(match.toElement())
