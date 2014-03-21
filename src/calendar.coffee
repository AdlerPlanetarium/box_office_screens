class Calendar
 
  constructor: ->
   

  render: =>
    week = @getFocusDate().isoWeek()
    @el.html(
      @cTemplates['week']
        week:   week
        events: (@eventsByWeek[week] || [])
    )

  updatePageTimes:=>
    hours        = @getOpenHours()
    weekdayHours = @openHours().hours[@session()].weekday
    weekendHours = @openHours().hours[@session()].weekend 

    if hours != "closed"
      shopHours  = "#{hours.shopOpen} - #{hours.shopClose}"
      cafeHours  = "#{hours.cafeOpen} - #{hours.cafeClose}"
      hours      = "#{hours.open} - #{hours.close}"

    else
      shopHours = 'closed'
      cafeHours = 'closed'

    weekendHours = "#{weekendHours.open} - #{weekendHours.close}"
    weekdayHours = "#{weekdayHours.open} - #{weekdayHours.close}"

    $(".hours .today span").html(hours)
    $(".hours .weekday span").html(weekdayHours)
    $(".hours .weekend span").html(weekendHours)

    $("#top-bar li.museum span").html(hours)
    $("#top-bar li.cafe span").html(cafeHours)
    $("#top-bar li.shop span").html(shopHours)

  updateEventsOverview: =>
    events = @squarespaceEvents.upcoming || []
    todaysEvents    = (e for e in events when moment(e.startDate).isSame(moment(),'day'))
    tomorrowsEvents = (e for e in events when moment(e.startDate).isSame(moment().add(1,'day'),'day'))

    if todaysEvents && todaysEvents.length > 0
      html = @cTemplates['overview']({ today: todaysEvents, tomorrow: tomorrowsEvents })
    else
      html = 'There are no events scheduled.'

    $('#events-overview').html(html)

  getShowTimes:(cb=null)=>
    $.ajax
      dataType: "json"
      url: "#{window.location.protocol}//adlersiteserver.herokuapp.com/show_times?callback=?"
      timeout : 10000

      success: (times)=>
        @showTimes = times

        for show, extra_times of window.extra_shows
          @showTimes[show] = extra_times

        @gotShowTimes()    
        cb() if cb?
      error: =>
        @showTimes ||= []
        # @gotShowTimes()
        cb() if cb?

  gotShowTimes:=>
    # console.log "show times new ", @showTimes
    # @showTimes["Maravilla C&#243smica"] = @showTimes["Maravilla Cósmica"] || []
    @showTimes["Maravilla Cósmica"] = []

    for show, times of  @showTimes
      times = (time.StartDateTime for time in times when time.Available > 0 )
      if show == "Space Junk 3D"
        times = (time for time in times when time != "Nov 4 2013 10:30:00:000AM" )
      
      @showTimes[show] = (moment( time ,"MMM DD YYYY HH:mm:ss:SSSA").local()  for time in times)

  showTimesForDay:(day)=>
    dayTimes = {}
    # console.log "show times in cal are", @showTimes
    for show,times of @showTimes
      dayTimes[show] = (time for time in times when time.isSame(day, 'day'))
    dayTimes

  todaysShowTimes:=>
    @todaysTimes = @showTimesForDay(moment())



  getOpenHours:=>
    if @isClosed()
      result = 'closed'
    else
      hours  = @openHours().hours
      session = @session()
      dayType = @dayType()

      hours[session][dayType]

  dayType:=>
    if moment().day() == 0 or moment().day() == 6
      'weekend'
    else
      'weekday'

  session:=>
    if moment().isAfter(@memorialDay()) and moment().isBefore(@labourDay())
      "late"
    else
      "normal"

  memorialDay:(year=null)=>
    year ||= moment().year()
    may = moment("#{year} 5 31")
    if may.day() == 1
      lastMonday = june
    else if may.day() == 0
      lastMonday = may.subtract(6,"days")
    else
      lastMonday = may.subtract( may.day() - 1 , 'days' )
    lastMonday

  labourDay:(year=null)=>
    year ||= moment().year()
    september = moment("#{year} 9 1")
    if september.day() == 1
      firstMonday = september
    else if september.day() == 0
      firstMonday = september.add(1,"day")
    else
      firstMonday = september.add( 8 - september.day(), 'days' )
    firstMonday

  isClosed:=>
    today = moment()

    for closedDay in @openHours().closed
      if today.date()  == moment(closedDay).date() and today.month() == moment(closedDay).month()
        return true

    return false

  openHours:=>
    hours:
      late :
        weekday:
          open:  "9:30 am"
          close: "6 pm"
          cafeOpen   : "10 am"
          cafeClose  : "3 pm"
          shopOpen   : "9:30 am"
          shopClose  : "6 pm"
        weekend:
          open:  "9:30 am"
          close: "6 pm"
          cafeOpen   : "10 am"
          cafeClose  : "3:30 pm"
          shopOpen   : "9:30 am"
          shopClose  : "6 pm"
          

      normal:
        weekday:
          open:  "9:30 am"
          close: "6 pm"
          cafeOpen   : "10 am"
          cafeClose  : "3 pm"
          shopOpen   : "9:30 am"
          shopClose  : "6 pm"
        weekend:
          open:  "9:30 am"
          close: "6 pm"
          cafeOpen   : "10 am"
          cafeClose  : "3:30 pm"
          shopOpen   : "9:30 am"
          shopClose  : "6 pm"

    closed: ["25th December", "28 November"]


  getEventsByWeek: (events, cb) =>
    @eventsByWeek = {}

    for e in events
      if e.startDate?
        week = moment(e.startDate).isoWeek()
        day  = moment(e.startDate).day()
        @eventsByWeek[week] = {} unless @eventsByWeek[week]?
        @eventsByWeek[week][day] = [] unless @eventsByWeek[week][day]?
        @eventsByWeek[week][day].push(e)

    cb() if cb?

  getFocusDate: =>
    @focusDate or= moment()

  _compileTemplates: =>
    @cTemplates = {}
    for templateName, text of @templates
      @cTemplates[templateName] = _.template(text)


window.Calendar = Calendar
