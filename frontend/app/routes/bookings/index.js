import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  queryParams: {
    paid: {
      refreshModel: true
    },
    sort_by: {
      refreshModel: true
    },
  },
  model: function(params){
    return this.store.query('booking', params);
  }
});
