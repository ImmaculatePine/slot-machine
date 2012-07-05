jQuery ->
  # Convert slot machine JSON object to array of arrays
  convertJsonToArray = (json) ->
    reels = []  
    for reel in json
      new_reel = []
      new_reel.push icon for icon in reel
      reels.push new_reel
    return reels
    
  # Draw first 3 elements of arrays
  draw = (o) ->
    $('#sm').empty()
    for reel in o
      reel = reel[1..3]
      $('#sm').append($('<div class="reel">'))
      for icon in reel
        $('#sm').find('div:last').append($('<img src="/assets/icons/'+icon.image+'">'))

  # Add click handler on button
  $('#pull').on 'click', (e) ->
    $.getJSON "/machines/press_button.json", (sm) ->
      result = convertJsonToArray(sm.result)    
      draw(result)
        
  # Get the structure of slot machine
  $.getJSON "/machines/load.json", (sm) ->
    $('h2').html("("+sm.name+")")
    reels = convertJsonToArray(sm.reels)
    draw(reels)