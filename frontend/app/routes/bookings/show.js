import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    console.log('adadadawd', params.token);
    return this.store.findRecord('booking', params.token);
  }
});
