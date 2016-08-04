import JSONAPIAdapter from 'ember-data/adapters/json-api';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default JSONAPIAdapter.extend(DataAdapterMixin, {
  // Application specific overrides go here
  namespace: 'v1',
  authorizer: 'authorizer:devise'
});
