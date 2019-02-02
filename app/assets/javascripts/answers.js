$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       console.log(answerId);
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })

  var x = $('.best').parent()
  x.insertAfter(".answer");


  $('.answer_vote_links').on('ajax:success', function(e) {
    var answerId = e.detail[0]['id'];
    var rating = e.detail[0]['rating']
    console.log('.answer_title' + answerId)
    $('.answer_title' + answerId + ' .answer_vote_links').html('<p>' + 'Voted with value ' + rating + '</p>');
  })

});
