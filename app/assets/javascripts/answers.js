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
    var rating = e.detail[0]['rating'];
    var voteValue = e.detail[0]['vote_value'];

    $('.answer_title' + answerId + ' .answer_vote_links').addClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_cancel').removeClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_content').html('<p>' + 'Voted with value ' + voteValue + '</p>');

    $('.answer_title' + answerId + ' .rating').html('<p>' + 'Resulting rating: ' + rating + '</p>');
  })

  $('.answer_vote_cancel').on('ajax:success', function(e) {
    var answerId = e.detail[0]['id'];
    var rating = e.detail[0]['rating'];

    $('.answer_title' + answerId + ' .answer_vote_links').removeClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_cancel').addClass('hidden');
    $('.answer_title' + answerId + ' .answer_vote_content').html('');

    $('.answer_title' + answerId + ' .rating').html('<p>' + 'Resulting rating: ' + rating + '</p>');
  })

});
