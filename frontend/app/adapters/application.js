import JSONAPIAdapter from 'ember-data/adapters/json-api';

export default JSONAPIAdapter.extend({
  // Application specific overrides go here
  namespace: 'v1',
  authorizer: 'authorizer:device'
});
