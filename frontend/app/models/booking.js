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
  token: attr('string', {readOnly: true}),
  createdAt: attr('date', {readOnly: true}),
  message: attr('string'),
  discount: attr('number', {updateOnly: true}),
  discountMessage: attr('string', {updateOnly: true}),
  memo: attr('string', {updateOnly: true}),
  paid: attr('boolean'),

  totalPrice: Ember.computed('event.price', 'tickets', function(){
    return this.get('event.price') * this.get('tickets');
  }),

  isBusiness: Ember.computed.equal('bookingType', 'business'),
  isPrivate: Ember.computed.equal('bookingType', 'private'),

  invoiceLink: Ember.computed('token', function(){
    return "/v1/invoices/" + this.get('token') + ".pdf";
  })

});
