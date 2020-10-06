import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service(),
  store: Ember.inject.service(),
  typeIsSet: Ember.computed.or('model.isPrivate', 'model.isBusiness'),
  savingMode: false,
  itemRows: Ember.A(),

  initEditForm: Ember.on('init', function(){
    var that = this;
    // Set confirmEmail to model email in case such exists (edit mode)
    this.set('confirmEmail', this.get('model.email'));
    this.set('model.sendEmail', false);
    // Set due date and delivery date
    if (!this.get('model.id')){
      this.set('model.deliveryDate', moment()._d);
      this.set('model.dueDate', moment().add(20, 'days')._d);
    }
    // Populate itemrows
    this.set('itemRows', Ember.A());
    this.get('store').findAll('item').then(function(items) {
      items.forEach(function(item) {
        if(that.get('model.event.items').includes(Number(item.id))){
          that.get('itemRows').pushObject({item: item, amount: 0, itemId: item.get('id')})
        }
      });
    });
    //Setup additional orderrow
    this.set('newOrderRow', this.get('store').createRecord('orderRow', {
      booking: this.get('model')
    }))

    if (this.get('model.event.ticketLimitLower') > 0) {
      this.set('model.tickets', this.get('model.event.ticketLimitLower'))
    }
  }),

  updateBookingType: Ember.observer('model.bookingType', function(){
    if (this.get('model.bookingType') == 'business'){
      this.set('model.dueDate', moment(this.get('model.deliveryDate')).add(10, 'days')._d);
    } else {
      this.set('model.dueDate', moment(this.get('model.deliveryDate')).add(20, 'days')._d);
    }
  }),

  invoiceDaysCalculated: Ember.computed('model.dueDate', 'model.deliveryDate', function(){
    return moment(this.get('model.dueDate')).diff(moment(this.get('model.deliveryDate')), 'days');
  }),

  emailConfirmed: Ember.computed('model.email', 'confirmEmail', function(){
    return (this.get('model.email') === this.get('confirmEmail'));
  }),

  showEmailDiffersMessage: Ember.computed('emailConfirmed', 'confirmEmail', function(){
    return !this.get('emailConfirmed');
  }),

  showAdminFields: Ember.computed('session.isAuthenticated', function(){
    return this.get('session.isAuthenticated'); //&& this.get('model.id');
  }),

  isAdmin: Ember.computed('session.isAuthenticated', function(){
    return this.get('session.isAuthenticated'); //&& this.get('model.id');
  }),

  tooManyTickets: Ember.computed('model.tickets', 'isAdmin', 'model.event.ticketLimitHigher', function(){
    if (this.get('model.event.ticketLimitHigher') > 0){
      return (this.get('model.tickets') > this.get('model.event.ticketLimitHigher') && !this.get('isAdmin'))
    } else {
      return false
    }
  }),
  
  tooFewTickets: Ember.computed('model.tickets', 'isAdmin', 'model.event.ticketLimitLower', function(){
    if (this.get('model.event.ticketLimitLower') > 0){
      return (this.get('model.tickets') < this.get('model.event.ticketLimitLower') && !this.get('isAdmin'))
    } else {
      return false
    }
  }),

  saveDisabled: Ember.computed('tooManyTickets', 'tooFewTickets', 'emailConfirmed','model.termsAccepted', function(){
    if (!this.get('emailConfirmed')) {
      return true;
    }
    if (this.get('model.termsAccepted') !== true){
      return true;
    }
    if (this.get('tooManyTickets')) {
      return true;
    }
    if (this.get('tooFewTickets')) {
      return true;
    }
    return null;
  }),

  actions: {
    setType(type) {
      this.set('model.bookingType', type);
    },

    save() {
      var that = this;
      this.set('savingMode', true);
      this.get('model').set('itemRows', this.get('itemRows'));
      this.get('model').save().then((response) =>{
        that.set('savingMode', false);
        that.get('model').set('itemRows', null);
        that.get('model').get('orderRows').reload().then(function() {
          return that.save(response);
        });
      }, (error) =>{
        that.set('savingMode', false);
        error.errors.forEach(function(error){
          if (error.detail === "tickets - Det finns inte tillräckligt många platser kvar."){
            that.$('#tooManyTicketsModal').modal();
          }
        })
      });
    },
    saveNewOrderRow(){
      var that = this;
      this.get('newOrderRow').save().then((response) =>{
        that.set('savingMode', false);
        this.set('newOrderRow', this.get('store').createRecord('orderRow', {
          booking: this.get('model')
        }));
        return;
      }, (error) =>{
        that.set('savingMode', false);
        })
    },
    deleteOrderRow(orderRow){
      var that = this;
      var confirm = window.confirm("Är du säker på att du vill radera orderraden: " + orderRow.get('name') + "? Totalpris och faktura kommer att påverkas.")
      if (confirm) {
        orderRow.deleteRecord();
        orderRow.save().then(function(){
          that.get('model').get('orderRows').reload().then(function() {
            return;
          })
        });
      }
    }
  }
});
