import DS from 'ember-data';
import attr from 'ember-data/attr';
import { belongsTo, hasMany } from 'ember-data/relationships';

export default DS.Model.extend({
  bookingType: attr('string'),
  name: attr('string'),
  contact_person: attr('string'),
  email: attr('string'),
  phone_nr: attr('string'),
  tickets: attr('number', {defaultValue: 1}),
  event: belongsTo('event'),
  orderRows: hasMany('order-row'),
  token: attr('string', {readOnly: true}),
  createdAt: attr('date', {readOnly: true}),
  message: attr('string'),
  discount: attr('number', {adminOnly: true}),
  discountMessage: attr('string', {adminOnly: true}),
  memo: attr('string', {adminOnly: true}),
  paid: attr('boolean', {adminOnly: true}),
  totalPrice: attr('number', {readOnly: true}),
  termsAccepted: false,
  sendEmail: attr('boolean', {adminOnly: true, defaultValue: false}),
  dueDate: attr('date', {adminOnly: true}),
  deliveryDate: attr('date', {adminOnly: true}),
  addressStreet: attr('string'),
  addressZip: attr('string'),
  addressCity: attr('string'),

  isBusiness: Ember.computed.equal('bookingType', 'business'),
  isPrivate: Ember.computed.equal('bookingType', 'private'),

  invoiceLink: Ember.computed('token', function(){
    return "/v1/invoices/" + this.get('token') + ".pdf";
  }),

  ticketLink: Ember.computed('token', function(){
    return "/v1/tickets/" + this.get('token') + ".pdf";
  }),

  discountedTicketPrice: Ember.computed('event.price', 'discount', function(){
    var discount = this.get('discount');
    if (!discount){
      discount = 0;
    }
    return (this.get('event.price')- discount);
  }),

  calculatedTotalPrice: Ember.computed('event.price', 'discount', 'tickets', function(){
    var discount = this.get('discount');
    if (!discount){
      discount = 0;
    }
    return (this.get('event.price')- discount) * this.get('tickets');
  }),

  daysLeftUntilDue: Ember.computed('dueDate', function(){
    return moment(this.get('dueDate')).fromNow();
  }),

  overDue: Ember.computed('dueDate', function(){
    if (this.get('dueDate') < new Date()){
      return true;
    }
    return false;
  })


});
