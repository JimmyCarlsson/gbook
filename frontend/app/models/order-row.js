import DS from 'ember-data';
import attr from 'ember-data/attr';
import { belongsTo} from 'ember-data/relationships';

export default DS.Model.extend({
  name: attr('string'),
  booking: belongsTo('booking'),
  createdAt: attr('date', {readOnly: true}),
  description: attr('string'),
  amount: attr('number'),
  price: attr('number'),
  tax6: attr('number'),
  tax12: attr('number'),
  tax25: attr('number'),
  totalPrice: attr('number', {readOnly: true}),
  totalNetPrice: attr('number', {readOnly: true})

});
