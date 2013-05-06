class Discuss.Compose
  constructor: (form) ->
    @form = $(form)
    @checkbox = @form.find('#message_draft')
    @setup()


  setup: =>
    @checkbox.parent().hide()
    html = '<input name="save_draft" type="submit" value="Save as Draft" />'
    @form.find('input[type=submit]').after(html)
    @hijaxSubmit()


  hijaxSubmit: =>
    @save_draft_button = $('input[name=save_draft]')
    @save_draft_button.on 'click', (e) =>
      @checkbox.attr('checked', 'checked')

$ ->
  $('form#new_message').each -> $(@).data('composable', new Discuss.Compose(@))
