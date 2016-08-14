import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service(),

  actions: {
    delete(booking) {
      var confirm = window.confirm("Är du säker på att du vill radera bokningen " + this.get('model.name') + "? All information kommer att raderas.")
      if (confirm) {
        booking.deleteRecord();
        booking.save();
        this.transitionToRoute('events.show', booking.get('event.id'));
      }
    }
  }
});
