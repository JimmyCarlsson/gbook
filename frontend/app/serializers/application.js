import DS from 'ember-data';

export default DS.JSONAPISerializer.extend({
  serializeAttribute(snapshot, json, key, attribute) {
    // do not serialize the attribute!
    if (attribute.options && attribute.options.readOnly) {
      return;
    }
    // Do no serialize updateOnly attributes if there is no ID
    if (attribute.options && attribute.options.updateOnly && snapshot.id == null) {
      return;
    }
    this._super(...arguments);
  },
});
