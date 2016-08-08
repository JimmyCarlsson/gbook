import DS from 'ember-data';
import attr from 'ember-data/attr';
import { belongsTo, hasMany } from 'ember-data/relationships';

export default DS.Model.extend({
  bookingType: attr('string'),
  name: attr('string'),
  contact_person: attr('string'),
  email: attr('string'),
  phone_nr: attr('string'),
  tickets: attr('number'),
  event: belongsTo('event'),
  token: attr('string'),

  totalPrice: Ember.computed('event.price', 'tickets', function(){
    return this.get('event.price') * this.get('tickets');
  })

});
