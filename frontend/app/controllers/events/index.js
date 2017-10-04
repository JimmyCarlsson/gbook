import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service(),
  totalTicketsArray: Ember.computed.mapBy('model', 'bookedSeats'),
  totalTickets: Ember.computed.sum('totalTicketsArray'),
  totalSeatsArray: Ember.computed.mapBy('model', 'seats'),
  totalSeats: Ember.computed.sum('totalSeatsArray')
});
