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
  discount: attr('number'),
  discountMessage: attr('string'),
  memo: attr('string'),
  paid: attr('boolean'),
  totalPrice: attr('number', {readOnly: true}),
  termsAccepted: false,

  isBusiness: Ember.computed.equal('bookingType', 'business'),
  isPrivate: Ember.computed.equal('bookingType', 'private'),

  invoiceLink: Ember.computed('token', function(){
    return "/v1/invoices/" + this.get('token') + ".pdf";
  }),

  ticketLink: Ember.computed('token', function(){
    return "/v1/tickets/" + this.get('token') + ".pdf";
  }),

  calculatedTotalPrice: Ember.computed('event.price', 'discount', 'tickets', function(){
    var discount = this.get('discount');
    if (!discount){
      discount = 0;
    }
    return (this.get('event.price')- discount) * this.get('tickets');
  }),

  saveDisabled: Ember.computed('termsAccepted', function(){
    if (this.get('termsAccepted') === true){
      return null;
    }
    return true;
  })

});
