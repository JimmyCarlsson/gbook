import Ember from 'ember';

export default Ember.Component.extend({

  actions: {
    save() {
      var that = this;
      this.get('model').save().then((response) =>{
        return this.save(response);
      });
    }
  }
});
