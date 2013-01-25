# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->  
  $('#search_company').autocomplete
    source: $('#search_company').data('autocomplete-source')
    select: (event, ui) ->
      if ui.item?
        $('#search_company_id').val ui.item.id
        $('#search_company').attr('name', '')
