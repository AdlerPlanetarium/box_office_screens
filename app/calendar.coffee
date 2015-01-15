class Calendar
  render: => 
    week = moment().isoWeek()
    @el.html(
      @cTemplates['week']
        week: week
        events: (@eventsByWeek[week] || [])
    )

  getShowTimes: (cb = null) =>
    $.ajax
      dataType: "json"
      url: "#{window.location.protocol}//s3.amazonaws.com/adler-cache/show_times.json"

      success: (@showTimes) =>
        @gotShowTimes()    
        cb?()

      error: =>
        @showTimes ||= []
        cb?()

  gotShowTimes: =>
    for show, times of @showTimes
      times = ({time: moment( time.StartDateTime ,"MMM DD YYYY HH:mm:ss:SSSA").local() , available: ( time.Available  ), theater:(time.ResourceID),  eventType: (time.EventTypeID)} for time in times  )

      @showTimes[show] = times

  showTimesForDay: (day) =>
    dayTimes = {}

    for show,times of @showTimes
      dayTimes[show] = (time for time in times when time.time.isSame(day, 'day'))
    dayTimes

module.exports = Calendar
