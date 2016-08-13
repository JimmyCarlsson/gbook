import Ember from 'ember';

export default Ember.Controller.extend({

  typeIsSet: Ember.computed.or('model.isPrivate', 'model.isBusiness'),

  emailConfirmed: Ember.computed('model.email', 'confirmEmail', function(){
    return (this.get('model.email') === this.get('confirmEmail')) && (!!this.get('confirmEmail'));
  }),

  showEmailDiffersMessage: Ember.computed('emailConfirmed', 'confirmEmail', function(){
    return (!this.get('emailConfirmed') && (this.get('confirmEmail')));
  }),

  actions: {
    save(model) {
      model.save().then((response) =>{
        this.transitionToRoute('bookings.show', response);
      });
    }
  }
});
