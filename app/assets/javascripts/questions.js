$(document).on('turbolinks:load', function(){
   $('.questions').on('click', '.edit-question-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var questionId = $(this).data('questionId');
       console.log(questionId);
       $('form#edit-question-' + questionId).removeClass('hidden');
   })

   $('.vote_links').on('ajax:success', function(e) {
    var questionId = e.detail[0]['id'];
    var rating = e.detail[0]['rating']
    console.log('.question_title' + questionId)
    $('.question_title' + questionId + ' .vote_links').html('<p>' + 'Voted with value ' + rating + '</p>');
  })
});
