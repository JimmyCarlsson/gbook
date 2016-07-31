import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.createRecord('event');
  },

  actions: {
    save: function(eventRecord) {
      eventRecord.save();
    }     
  }
});
