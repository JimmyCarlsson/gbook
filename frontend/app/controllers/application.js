import Ember from 'ember';

export default Ember.Controller.extend({
  queryParams: 'bare',
  session: Ember.inject.service('session'),

  actions: {
    invalidateSession() {
      this.get('session').invalidate();
    }
  }
});
