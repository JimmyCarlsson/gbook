import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  actions: {
    delete(event) {
      var confirm = window.confirm("Är du säker på att du vill radera eventet " + this.get('model.name') + "? All information och bokningar kommer att raderas.")
      if (confirm) {
        event.deleteRecord();
        event.save();
        this.transitionToRoute('events.index');
      }
    }
  }
});
