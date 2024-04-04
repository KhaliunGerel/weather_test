const admin = require('firebase-admin');

var serviceAccount = require('../weather-khln-firebase-adminsdk-ee90i-84704d0ab3');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
export * from './weather';
export * from './subscription';
