$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e) {
     e.preventDefault();
     $(this).hide();
     var questionId = $(this).data('questionId');
     $('form#edit-question-' + questionId).removeClass('hidden');
  })

  rating('.question');

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow');
    },

    received: function(data) {
      $('.questions').append(data);
    }
  });

});

