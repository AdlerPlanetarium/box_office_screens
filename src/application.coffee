
showLocations=
	"Definiti Space Theater" :[
		"One World, One Sky: Big Bird's Adventure",
		"Earth, Moon & Sun",
		"Winter Sky Live!",
		"Undiscovered Worlds"
	],
	"Granger Sky Theater":[
	  "Welcome To The Universe",
	  "Cosmic Wonder"
	],
	
	"Johnson Star Theater" :[
		"3D Sun",
		"Space Junk 3D"
	],
	
	"Guided Tours": [
		"Beyond The Dome"
	]



$(document).ready ->
	cal = new Calendar()

	setInterval =>
		$(".current-date").html(moment().format("dddd, MMMM, YYYY"))
		$(".current-time").html(moment().format("hh:mm a"))
	, 200

	cal.getShowTimes =>

		shows = cal.showTimesForDay moment()
		
		console.log  "shows are ",shows 
		(console.log show for show, times of shows)
		console.log showLocations
		for theater, showList of showLocations

			theaterDiv = $("##{theater.split(" ")[0].toLowerCase()}_shows")
			for show in showList
				times = (time.format("h:mm a") for time in (shows[show] || []) ).join(", ")
				
				if times 
					console.log times 
					theaterDiv.append("<p class='show'>#{show}</p>")
					theaterDiv.append("<p class='times'> #{times}</p>")
				# ("<span class='showtime'>#{moment(time).format('h:mm a')}</span>" for show, times of shows)
					
