import Ember from 'ember';

export default Ember.Component.extend({
  typeIsSet: Ember.computed.or('model.isPrivate', 'model.isBusiness'),

  emailConfirmed: Ember.computed('model.email', 'confirmEmail', function(){
    return (this.get('model.email') === this.get('confirmEmail')) && (!!this.get('confirmEmail'));
  }),

  showEmailDiffersMessage: Ember.computed('emailConfirmed', 'confirmEmail', function(){
    return (!this.get('emailConfirmed') && (this.get('confirmEmail')));
  }),
  actions: {
    save() {
      var that = this;
      this.get('model').save().then((response) =>{
        return this.save(response);
      });
    }
  }
});
