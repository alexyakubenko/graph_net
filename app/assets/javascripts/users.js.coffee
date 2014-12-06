$ ->
  updateUndefinedOptionTypes = (response) ->
    $('select#attribute-type').html(response.undefined_attribute_types_html)


  $('button#add-attribute').click =>
    $.post(Routes.create_attribute_users_path(
        format: 'json'
      ),
        value: $('#attribute-value').val(),
        type: $('#attribute-type').val()
      , (response) =>
        if response.success
          $('#attributes-list tbody').append response.html
          $('.modal#add-attribute').modal 'hide'
          updateUndefinedOptionTypes(response)
    )

  $(document).off('click', 'a.remove-attr').on 'click', 'a.remove-attr', ->
    id = $(@).data('id')
    $.ajax(
      url: Routes.delete_attribute_users_path(),
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
