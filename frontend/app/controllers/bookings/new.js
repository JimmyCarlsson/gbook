import Ember from 'ember';

export default Ember.Controller.extend({

  isBusiness: Ember.computed.equal('model.bookingType', 'business'),
  isPrivate: Ember.computed.equal('model.bookingType', 'private'),
  typeIsSet: Ember.computed.or('isPrivate', 'isBusiness'),

  emailConfirmed: Ember.computed('model.email', 'confirmEmail', function(){
    return (this.get('model.email') === this.get('confirmEmail')) && (!!this.get('confirmEmail'));
  }),

  showEmailDiffersMessage: Ember.computed('emailConfirmed', 'confirmEmail', function(){
    return (!this.get('emailConfirmed') && (this.get('confirmEmail')));
  }),

  actions: {
    save(model) {
      model.save().then((response) =>{
        console.log(response);
        this.transitionToRoute('bookings.show', response);
      });
    }
  }
});
