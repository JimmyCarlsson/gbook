import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    save(model) {
      this.transitionToRoute('events.show', model);
    }
  }
});
