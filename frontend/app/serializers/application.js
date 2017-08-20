import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  session: Ember.inject.service(),
  serializeAttribute(snapshot, json, key, attribute) {
    // do not serialize the attribute!
    if (attribute.options && attribute.options.readOnly) {
      return;
    }
    // Do no serialize updateOnly attributes if there is no ID
    if (attribute.options && attribute.options.updateOnly && snapshot.id == null) {
      return;
    }
    // Do not serialize adminOnly attributes if user is not authenticated
    if (attribute.options && attribute.options.adminOnly && !this.get('session.isAuthenticated')){
      return;
    }
    this._super(...arguments);
  },
});
