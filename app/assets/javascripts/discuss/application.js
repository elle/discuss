//= require discuss/chosen.jquery
//= require_self

const compose = (form) => {
  const $form = $(form);
  const $checkbox = $form.find("#message_draft");

  $checkbox.parent().hide();

  $form
    .find("input[type=submit]")
    .after('<input name="save_draft" type="submit" value="Save as Draft" />');

  $("input[name=save_draft]").on("click", (e) => {
    $checkbox.attr("checked", "checked");
  });
};

$(function () {
  document.querySelectorAll(".compose form").forEach((form) => compose(form));
  $(".chosen").chosen();
});
