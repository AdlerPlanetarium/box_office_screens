Calendar = require './calendar'

showLocations =
    1  : "Granger Sky Theater" ,
    37 : "Granger Sky Theater" ,
    38 : "Granger Sky Theater" ,
    2  : "Definiti Space Theater",
    3  : "Johnson Star Theater",
    5  : "Guided Tours"

ONE_MINUTE = 60 * 1000

$(document).ready ->
  calendar = new Calendar()
  timeShift = +window.location.hash.replace("#","") || 0

  updateShowTimes = (callback) =>
    calendar.getShowTimes(callback)

  showActiveConditions = (show, showName) =>
    active = if show.time.isAfter(moment().subtract("hours", timeShift)) and show.available > 0
      true
    else
      false

    active

  updateScreen = =>
    showsList = calendar.showTimesForDay moment()
    allowed_event_types = [1, 3, 37, 38]

    for theaterId, theaterName of showLocations
      theaterDiv = $("##{theaterName.split(" ")[0].toLowerCase()}-shows")
      theaterDiv.html("")

    for showName, shows of showsList when shows.length > 0
      if allowed_event_types.indexOf(shows[0].eventType) != -1 and showName.indexOf("Up?") == -1
        theater = showLocations[shows[0].theater]
        if theater
          theaterDiv = $("##{theater.split(" ")[0].toLowerCase()}-shows")
          times = ( "<span class=' time #{ if showActiveConditions(show, showName) then "active" else "" }' > #{show.time.format('h:mm a')}</span>" for show in shows || []).join(", ")
          if times
            theaterDiv.append("<div class='show-container'> <p class='show'>#{showName}</p><p class='times'> #{times} </p> #{if shows[0].theater == 37 then '<p class="premier">Premier Show</p>' else ""}</div>")

  updateShowTimes updateScreen

  setInterval updateShowTimes, 20000
  setInterval updateScreen, ONE_MINUTE
