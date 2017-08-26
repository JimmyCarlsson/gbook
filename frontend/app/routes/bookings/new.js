import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    console.log('event:', this.modelFor('events/show'));
    if (!this.modelFor('events/show')){
      this.transitionTo('events');
    }
    return this.store.createRecord('booking', {
      event: this.modelFor('events/show')
    });
  }
});
