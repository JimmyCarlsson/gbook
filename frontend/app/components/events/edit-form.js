import Ember from 'ember';

export default Ember.Component.extend({

  priceWithDedicatedTax: Ember.computed.sum('model.tax25', 'model.tax12', 'model.tax6'),
  priceWithoutDedicatedTax: Ember.computed('priceWithDedicatedTax', 'model.price', function(){
    return this.get('model.price') - this.get('priceWithDedicatedTax');
  }),

  percentageTax25: Ember.computed('model.tax25', 'model.price', function(){
    return this.calculatePercent(this.get('model.tax25'), this.get('model.price')).toFixed(2);
  }),

  percentageTax12: Ember.computed('model.tax12', 'model.price', function(){
    return this.calculatePercent(this.get('model.tax12'), this.get('model.price')).toFixed(2);
  }),

  percentageTax6: Ember.computed('model.tax6', 'model.price', function(){
    return this.calculatePercent(this.get('model.tax6'), this.get('model.price')).toFixed(2);
  }),

  calculatePercent(part, whole) {
    if (part < 1 || whole < 1 ){
      return 0;
    }
    return (part / whole) * 100
  },

  actions: {
    save() {
      var that = this;
      this.get('model').save().then((response) =>{
        return this.save(response);
      });
    }
  }
});
