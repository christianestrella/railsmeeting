# Captiva Tecnología Digital
# by: Christian Estrella
# date: January 2013

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#search_company').autocomplete
    source: $('#search_company').data('autocomplete-source')
    select: (event, ui) ->
      if ui.item?
        $('#search_company_id').attr 'name', 'user[company_id]' # asignar el atributo 'name' de search_company_id
        $('#search_company_id').val ui.item.id # asignar company id
        $('#search_company').attr 'name', '' # eliminar atributo 'name' de search_company

  $('#search_company').keydown (event) ->
    if event.which is 8 or event.which is 46 # 8 = Retroceso, 46 = Suprimir 
      $('#search_company').attr 'name', 'user[company_attributes][name]' # asignar el atributo 'name' a search_company
      $('#search_company_id').val '' # delete value
      $('#search_company_id').attr 'name', '' # eliminar atributo 'name' de search_company_id
    
