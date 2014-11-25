$ ->
  $('button#add-property').click =>
    $.post(Routes.properties_path(
        format: 'json'
      ),
        value: $('#property-value').val(),
        type: $('#property-type').val()
      , (response) =>
        console.log response
    )
