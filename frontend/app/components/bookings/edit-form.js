import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service(),
  typeIsSet: Ember.computed.or('model.isPrivate', 'model.isBusiness'),
  savingMode: false,

  emailConfirmed: Ember.computed('model.email', 'confirmEmail', function(){
    return (this.get('model.email') === this.get('confirmEmail')) && (!!this.get('confirmEmail'));
  }),

  showEmailDiffersMessage: Ember.computed('emailConfirmed', 'confirmEmail', function(){
    return (!this.get('emailConfirmed') && (this.get('confirmEmail')));
  }),

  showAdminFields: Ember.computed('model.id', 'session.isAuthenticated', function(){
    return this.get('session.isAuthenticated'); //&& this.get('model.id');
  }),
  actions: {
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
