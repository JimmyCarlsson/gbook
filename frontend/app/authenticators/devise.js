import DeviseAuthenticator from 'ember-simple-auth/authenticators/devise';

export default DeviseAuthenticator.extend({
  resourceName: 'admin',
  serverTokenEndpoint: '/admins/sign_in',

  invalidate() {
    return Ember.$.ajax({
      url:  '/admins/sign_out',
      type: 'DELETE'
    });
  }
/*
  restore(data) {
    console.log(JSON.stringify(data));
  }
  */
});
