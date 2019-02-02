$(document).on('turbolinks:load', function(){
   $('.questions').on('click', '.edit-question-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var questionId = $(this).data('questionId');
       $('form#edit-question-' + questionId).removeClass('hidden');
   })

   $('.vote_links').on('ajax:success', function(e) {
    var questionId = e.detail[0]['id'];
    var rating = e.detail[0]['rating'];
    var voteValue = e.detail[0]['vote_value'];

    $('.question_title' + questionId + ' .vote_links').addClass('hidden');
    $('.question_title' + questionId + ' .vote_cancel').removeClass('hidden');
    $('.question_title' + questionId + ' .vote_content').html('<p>' + 'Voted with value ' + voteValue + '</p>');

    $('.question_title' + questionId + ' .rating').html('<p>' + 'Resulting rating: ' + rating + '</p>');

  })

  $('.vote_cancel').on('ajax:success', function(e) {
    var questionId = e.detail[0]['id'];
    var rating = e.detail[0]['rating'];
    $('.question_title' + questionId + ' .vote_links').removeClass('hidden');
    $('.question_title' + questionId + ' .vote_cancel').addClass('hidden');
    $('.question_title' + questionId + ' .vote_content').html('');

    $('.question_title' + questionId + ' .rating').html('<p>' + 'Resulting rating: ' + rating + '</p>');
  })

});




/*
    if ($('.question_title' + questionId + ' .vote_links').hasClass('hidden')) {
      $('.question_title' + questionId + ' .vote_links').addClass('hidden');
      $('.question_title' + questionId + ' .vote_cancel').removeClass('hidden');
      $('.question_title' + questionId + ' .vote_content').html('<p>' + 'Voted with value ' + rating + '</p>');
      }
    else {
      $('.question_title' + questionId + ' .vote_links').removeClass('hidden');
      $('.question_title' + questionId + ' .vote_cancel').addClass('hidden');
      $('.question_title' + questionId + ' .vote_content').html('');
    }

*/
