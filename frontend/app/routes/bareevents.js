import Ember from 'ember';

export default Ember.Route.extend({
  queryParams: {
    eventname: {
      refreshModel: true
    }
  },

  model: function(params){
    return this.store.query('event', params);
  }
});
