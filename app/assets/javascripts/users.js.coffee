$ ->
  updateUndefinedOptionTypes = (response) ->
    $('select#property-type').html(response.undefined_attribute_types_html)


  $('button#add-property').click =>
    $.post(Routes.attributes_path(
        format: 'json'
      ),
        value: $('#property-value').val(),
        type: $('#property-type').val()
      , (response) =>
        if response.success
          $('#attributes-list tbody').append response.html
          $('.modal#add-property').modal 'hide'
          updateUndefinedOptionTypes(response)
    )

  $(document).off('click', 'a.remove-attr').on 'click', 'a.remove-attr', ->
    id = $(@).data('id')
    $.ajax(
      url: Routes.attributes_path(),
      type: 'DELETE',
      data:
        id: id
      success: (response) =>
        if response.success
          $("tr.attribute-#{ id }").remove()
          updateUndefinedOptionTypes(response)
        else
          alert 'Извините. Что-то пошло не так...'
    )
