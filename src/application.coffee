
showLocations=
	"Definiti Space Theater" :[
		"One World, One Sky; Big Bird's Adventure",
		"Earth, Moon & Sun",
		"Night Sky Live!",
		"Undiscovered Worlds"
	],
	"Granger Sky Theater":[
	  "Welcome To The Universe",
	  "Cosmic Wonder", 
    "Destination Solar System"
	],
	
	"Johnson Star Theater" :[
		"3D Sun",
		"Space Junk 3D"
	],
	
	"Guided Tours": [
		"Beyond the Dome Guided Tour"
	]



$(document).ready ->
	cal = new Calendar()

	
	time_shift = parseInt(window.location.hash.replace("#","")) || 0

	setInterval =>
		$(".current-date").html(moment().format("dddd, MMMM D, YYYY"))
		$(".current-time").html(moment().format("hh:mm a"))
	, 200

	# setTimeout =>
		# if hostReachable()
			# location.reload()
	# , 10*60*1000

	update_show_times = =>
		cal.getShowTimes =>
	
	update_screen = =>
		shows = cal.showTimesForDay moment()
			
		for theater, showList of showLocations
			theaterDiv = $("##{theater.split(" ")[0].toLowerCase()}_shows")
			theaterDiv.html("")
			for show in showList
				times = ( "<span 	class=' time #{ if time.isAfter(moment().subtract("hours",time_shift)) then "active" else "" }' > #{time.format('h:mm a')}</span>" for time in (shows[show] || [])).join(", ")
				if times 
					theaterDiv.append("<div class='show_container'> <p class='show'>#{show}</p><p class='times'> #{times} </p> </div>")
					

	update_show_times()
	setInterval update_show_times, 20000
	setInterval update_screen, 1000
					
