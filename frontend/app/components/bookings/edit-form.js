import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service(),
  store: Ember.inject.service(),
  typeIsSet: Ember.computed.or('model.isPrivate', 'model.isBusiness'),
  savingMode: false,

  initEditForm: Ember.on('init', function(){
    // Set confirmEmail to model email in case such exists (edit mode)
    this.set('confirmEmail', this.get('model.email'));
    this.set('model.sendEmail', false);
    // Set due date and delivery date
    if (!this.get('model.id')){
      this.set('model.deliveryDate', moment()._d);
      this.set('model.dueDate', moment().add(20, 'days')._d);
    }
    this.set('newOrderRow', this.get('store').createRecord('orderRow', {
      booking: this.get('model')
    }))
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

  tooManyTickets: Ember.computed('model.tickets', 'isAdmin', function(){
    return (this.get('model.tickets') > 20 && !this.get('isAdmin'))
  }),

  saveDisabled: Ember.computed('tooManyTickets' ,'emailConfirmed','model.termsAccepted', function(){
    if (!this.get('emailConfirmed')) {
      return true;
    }
    if (this.get('model.termsAccepted') !== true){
      return true;
    }
    if (this.get('tooManyTickets')) {
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
      this.get('model').save().then((response) =>{
        that.set('savingMode', false);
        return this.save(response);
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
      var confirm = window.confirm("Är du säker på att du vill radera orderraden: " + orderRow.get('name') + "? Totalpris och faktura kommer att påverkas.")
      if (confirm) {
        orderRow.deleteRecord();
        orderRow.save();
        return this.get('model').reload
      }
    }
  }
});
