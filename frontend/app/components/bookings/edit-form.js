import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service(),
  typeIsSet: Ember.computed.or('model.isPrivate', 'model.isBusiness'),
  savingMode: false,

  setConfirmEmail: Ember.on('init', function(){
    // Set confirmEmail to model email in case such exists (edit mode)
    this.set('confirmEmail', this.get('model.email'));
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
    return (this.get('model.tickets') > 15 && !this.get('isAdmin'))
  }),

  saveDisabled: Ember.computed('emailConfirmed','model.termsAccepted', function(){
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
      });
    }
  }
});
