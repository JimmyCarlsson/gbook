import Ember from 'ember';

export default Ember.Route.extend({
  session: Ember.inject.service(),

  model(params) {
    return this.store.findRecord('event', params.id);
  },
  setupController(model) {
    this.set('model', model);

    if (!this.get('session.isAuthenticated')){
      this.transitionTo('bookings.new');
    }
  }
});
