import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('bookings/edit-form', 'Integration | Component | bookings/edit form', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{bookings/edit-form}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#bookings/edit-form}}
      template block text
    {{/bookings/edit-form}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
