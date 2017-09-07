import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('events', function() {
    this.route('new');
    this.route('show', {path: '/:id'}, function() {
      this.route('edit');
    });
  });
  this.route('login');

  this.route('bookings', function() {
    this.route('new');
    this.route('show', {path: '/:token'}, function() {
      this.route('edit');
    });
  });
});

export default Router;
