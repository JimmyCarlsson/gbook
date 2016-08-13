import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { belongsTo, hasMany } from 'ember-data/relationships';

export default Model.extend({
  name: attr('string'),
  description: attr('string'),
  date: attr('date', {defaultValue: null}),
  price: attr('number'),
  tax25: attr('number'),
  tax12: attr('number'),
  tax6: attr('number'),
  seats: attr('number'),
  bookings: hasMany('booking'),
  availabilityString: attr('string', {readOnly: true}),
  netPrice: attr('number', {readOnly: true}),
  totalTax: attr('number', {readOnly: true}),

  ticketsArray: Ember.computed.mapBy('bookings', 'tickets'),
  totalTickets: Ember.computed.sum('ticketsArray'),
  availabilityPlenty: Ember.computed.equal('availabilityString', 'none'),
  availabilitySome: Ember.computed.equal('availabilityString', 'some'),
  availabilityFew: Ember.computed.equal('availabilityString', 'few'),
  availabilityNone: Ember.computed.equal('availabilityString', 'none'),

  taxSumValid: Ember.computed('price', 'tax25', 'tax12', 'tax6', () => {
    return (this.get('tax25') + this.get('tax12') + this.get('tax6')) === this.get('price');
  })

});
