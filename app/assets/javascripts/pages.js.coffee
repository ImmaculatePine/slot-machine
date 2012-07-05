jQuery ->
  
  loadSlotMachine = (id, name = "") ->
    # Convert slot machine JSON object to array of arrays
    convertJsonToArray = (json) ->
      reels = []  
      for reel in json
        new_reel = []
        new_reel.push icon for icon in reel
        reels.push new_reel
      return reels
      
    # Draw only visible elements of arrays
    draw = (object, lines) ->
      $('#'+id).find('.sm').empty()
      for reel in object
        reel = reel[0..lines-1]
        $('#'+id).find('.sm').append($('<div class="reel">'))
        for icon in reel
          $('#'+id).find('.sm').find('div:last').append($('<img src="/assets/icons/'+icon.image+'">'))
  
    # Add click handler on button
    $('#'+id).find('.pull').on 'click', (e) ->
      $.getJSON "/machines/press_button/"+name, (sm) ->
        result = convertJsonToArray(sm.result)
        draw(result, sm.lines_quantity)
        $('#'+id).find('.win').html(sm.win)
          
    # Get the structure of slot machine
    $.getJSON "/machines/load/"+name, (sm) ->
      $('#'+id).find('h2').html("("+sm.name+")")
      reels = convertJsonToArray(sm.reels)
      draw(reels, sm.lines_quantity)
      
  loadSlotMachine('big')
  loadSlotMachine('simple', 'simple')