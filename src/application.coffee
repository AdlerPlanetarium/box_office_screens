

showLocations=
    1  : "Granger Sky Theater" ,
    37 : "Granger Sky Theater" ,
    38 : "Granger Sky Theater" ,
    2  : "Definiti Space Theater",
    3  : "Johnson Star Theater",
    5  : "Guided Tours"

$(document).ready ->
    cal = new Calendar()

    window.cal = cal


    
    time_shift = parseInt(window.location.hash.replace("#","")) || 0
    
    # setInterval =>
    #     $(".current-date").html(moment().format("dddd, MMMM D, YYYY"))
    #     $(".current-time").html(moment().format("hh:mm a"))
    # , 200

    # setTimeout =>
        # if hostReachable()
            # location.reload()
    # , 10*60*1000

    update_show_times = =>
        cal.getShowTimes =>

    show_active_conditions =(show,show_name) =>
        active = false 
       
        if show.time.isAfter(moment().subtract("hours",time_shift)) and show.available > 0 
            active = true

        if show_name.indexOf("Up?") > 0
            active = false 
        active
    
    update_screen = =>
        showsList = cal.showTimesForDay moment()
        allowed_event_types = [1,3,37,38]
        
        for theater_id, theater_name of showLocations
            theaterDiv = $("##{theater_name.split(" ")[0].toLowerCase()}_shows")
            theaterDiv.html("")

        for show_name, shows of showsList when shows.length > 0
            console.log show_name, shows 
            if allowed_event_types.indexOf(shows[0].eventType) != -1 and show_name.indexOf("Up?") == -1 
                theater = showLocations[shows[0].theater]
                if theater
                    theaterDiv = $("##{theater.split(" ")[0].toLowerCase()}_shows")
                    times = ( "<span class=' time #{ if show_active_conditions(show,show_name) then "active" else "" }' > #{show.time.format('h:mm a')}</span>" for show in shows || []).join(", ")
                    if times
                        console.log show_name,shows[0].thearter 
                        theaterDiv.append("<div class='show_container'> <p class='show'>#{show_name}</p><p class='times'> #{times} </p> #{if shows[0].theater == 37 then '<p class="premier">Premier Show</p>' else ""}</div>")

                    

    update_show_times()
    setInterval update_show_times, 20000
    setInterval update_screen, 1000
                    
