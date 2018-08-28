'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  let app = new EmberApp(defaults, {
    // Add options here
    outputPaths: {
      intl: '/assets/intl' // default
    },

    'ember-bootstrap': {
      bootstrapVersion: 3,
      importBootstrapFont: true,
      importBootstrapCSS: false
    }
  });

  // FIXME: Proper import
  // Ember-CLI will remove Bower support in the near future and
  // it doesn't support import files in subdirectories in node modules today.
  // It will likely be supported and when it makes it, we can migrate to proper import.
  // Or, these import should be done by ember-bootstrap.
  app.import('bower_components/bootstrap/js/tooltip.js');

  // Use `app.import` to add additional libraries to the generated
  // output files.
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  //
  // If the library that you are including contains AMD or ES6
  // modules that you would like to import into your application
  // please specify an object with the list of modules as keys
  // along with the exports of each module as its value.

  app.import('node_modules/spinkit/css/spinkit.css');

  return app.toTree();
};
