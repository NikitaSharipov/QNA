$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e) {
     e.preventDefault();
     $(this).hide();
     var questionId = $(this).data('questionId');
     $('form#edit-question-' + questionId).removeClass('hidden');
  })

  rating('.question');

  App.cable.subscriptions.create({channel: 'QuestionsChannel'}, {
    connected: function() {
      this.perform('follow');
    },

    received: function(data) {
      console.log(data);
      if (gon.user_id != data.question.author_id) {
        $(".questions").append(JST["templates/question"]({question: data.question}));
      }
    }
  });


    $('.questions').on('ajax:error', function(e) {
      let errors = e.detail[0];

      $('.notice').html(errors);
  });

});

