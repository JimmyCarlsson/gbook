import DS from 'ember-data';
import attr from 'ember-data/attr';

export default DS.Model.extend({
  name: attr('string'),
  createdAt: attr('date', {readOnly: true}),
  description: attr('string'),
  price: attr('number'),
  tax6: attr('number', {defaultValue: 0}),
  tax12: attr('number', {defaultValue: 0}),
  tax25: attr('number', {defaultValue: 0}),
  netPrice: attr('number', {readOnly: true}),

});
