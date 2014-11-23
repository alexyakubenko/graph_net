$ ->
  $('button#add-property').click =>
    $.post(Routes.properties_path(
        format: 'json'
      ),
        title: $('#property-type').val(),
        type: $('#property-title').val()
      , (response) =>
        console.log response
    )
