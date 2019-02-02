$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })

  var x = $('.best').parent()
  x.insertAfter(".answer");


  $('.answer_vote_links').on('ajax:success', function(e) {
    var answerId = e.detail[0]['id'];
    var rating = e.detail[0]['rating']

    $('.answer_title' + answerId + ' .answer_vote_links').addClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_cancel').removeClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_content').html('<p>' + 'Voted with value ' + rating + '</p>');
  })

  $('.answer_vote_cancel').on('ajax:success', function(e) {
    var answerId = e.detail[0]['id'];
    $('.answer_title' + answerId + ' .answer_vote_links').removeClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_cancel').addClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_content').html('');
  })

});
