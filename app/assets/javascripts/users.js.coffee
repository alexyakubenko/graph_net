$ ->
  $(document).off('click', '.add-profile-attribute').on 'click', '.add-profile-attribute', ->
    i = $(@)

    attribute_container = i.closest 'tr'

    add_link_html = i.parent().html()
    input_html = attribute_container.find('td:eq(1)').html()

    i.remove()

    attribute_container.after("<tr><td></td><td>#{ input_html }</td><td>#{ add_link_html }</td>").next().find('input').val('')
