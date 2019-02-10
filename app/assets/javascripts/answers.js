$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })

  var x = $('.best').parent();
  x.insertAfter(".answer");

  rating('.answer');

  if (gon.questionID) {

    App.cable.subscriptions.create({channel: 'AnswersChannel', question_id: gon.questionID}, {
      connected: function() {
        this.perform('follow');
      },

      received: function(data) {
        console.log(gon.user_id)
        if (gon.user_id != data.answer.author_id) {
          $(".answers").append(JST["templates/answer"]({answer: data.answer, answer_links: data.answer_links, answer_files: data.answer_files}));
        }
      }
    });

  }

});



