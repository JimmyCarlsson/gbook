import Model from 'ember-data/model';
import attr from 'ember-data/attr';
import { belongsTo, hasMany } from 'ember-data/relationships';

export default Model.extend({
  name: attr('string'),
  description: attr('string'),
  date: attr('date', {defaultValue: null}),
  price: attr('number'),
  seats: attr('number'),
  bookings: hasMany('booking'),
  availabilityString: attr('string'),

  ticketsArray: Ember.computed.mapBy('bookings', 'tickets'),
  totalTickets: Ember.computed.sum('ticketsArray'),
  availabilityPlenty: Ember.computed.equal('availabilityString', 'none'),
  availabilitySome: Ember.computed.equal('availabilityString', 'some'),
  availabilityFew: Ember.computed.equal('availabilityString', 'few'),
  availabilityNone: Ember.computed.equal('availabilityString', 'none'),

});
