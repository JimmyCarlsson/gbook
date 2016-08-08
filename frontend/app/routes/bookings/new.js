import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.createRecord('booking', {
      event: this.modelFor('events/show')
    });
  }
});
