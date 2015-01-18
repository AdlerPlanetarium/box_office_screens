RAW_DATE_FORMAT = 'MMM DD YYYY HH:mm:ss:SSSA'

class Calendar
  getShowTimes: (cb = null) =>
    $.ajax
      dataType: "json"
      url: "#{window.location.protocol}//s3.amazonaws.com/adler-cache/show_times.json"

      success: (@showsList) =>
        for show, showTimes of @showsList
          times = []
          for time in showTimes
            parsedTime = moment(time.StartDateTime, RAW_DATE_FORMAT).local()
            continue unless parsedTime.isSame new Date(), 'day'
            times.push {
              time: parsedTime
              available: time.Available
              theater: time.ResourceID 
              eventType: time.EventTypeID
            }

          @showsList[show] = times
        cb?()

      error: =>
        @showsList ||= {}
        cb?()

module.exports = Calendar
