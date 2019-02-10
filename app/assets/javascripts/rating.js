   function rating(resource_name) {

     $('.answers').on('ajax:success', ".vote_links", function(e) {
      var Id = e.detail[0]['id'];
      var rating = e.detail[0]['rating'];
      var voteValue = e.detail[0]['vote_value'];

      $(resource_name + '_title' + Id + ' .vote_links').addClass('hidden');
      $(resource_name + '_title' + Id + ' .vote_cancel').removeClass('hidden');
      $(resource_name + '_title' + Id + ' .vote_content').html('<p>' + 'Voted with value ' + voteValue + '</p>');

      $(resource_name + '_title' + Id + ' .rating').html('<p>' + 'Resulting rating: ' + rating + '</p>');

    })

     $('.answers').on('ajax:success', ".vote_cancel", function(e) {
      var Id = e.detail[0]['id'];
      var rating = e.detail[0]['rating'];
      $(resource_name + '_title' + Id + ' .vote_links').removeClass('hidden');
      $(resource_name + '_title' + Id + ' .vote_cancel').addClass('hidden');
      $(resource_name + '_title' + Id + ' .vote_content').html('');

      $(resource_name + '_title' + Id + ' .rating').html('<p>' + 'Resulting rating: ' + rating + '</p>');
    })

};
