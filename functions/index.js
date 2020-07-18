const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const db = admin.firestore();

getQuote().then

var apn = require('apn');

exports.sendNotification = functions.https.onRequest((request, response) => {
    var options = {
        token: {
            key: "/Volumes/Reserve/Certificate/AuthKey_S8KWFM52JH.p8",
            keyId: "S8KWFM52JH",
            teamId: "G7CN72P9F4"
        },
        production: false
    };

    let notification = new apn.Notification();
    notification.alert = "Hello, world!";
    notification.badge = 1;
    notification.topic = "io.github.node-apn.test-app";

    let deviceToken = "a9d0ed10e9cfd022a61cb08753f49c5a0b0dfb383697bf9f9d750a1003da19c7";

    var apnProvider = new apn.Provider(options);

    var note = new apn.Notification();

    note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    note.badge = 3;
    note.sound = "ping.aiff";
    note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
    note.payload = {'messageFrom': 'John Appleseed'};
    note.topic = "Arsalan.Sletti";

// eslint-disable-next-line promise/catch-or-return
    apnProvider.send(note, deviceToken).then((response) => {
        response.send("Hello");
        return "salam";
    }).catch({

    })
})

// Take the text parameter passed to this HTTP endpoint and insert it into the
// Realtime Database under the path /messages/:pushId/original
exports.addMessage = functions.https.onRequest((req, res) => {
  // Grab the text parameter.
  const original = req.query.text;
  // Push the new message into the Realtime Database using the Firebase Admin SDK.
  return admin.database().ref('/messages').push({original: original}).then((snapshot) => {
    // Redirect with 303 SEE OTHER to the URL of the pushed object in the Firebase console.
    return res.redirect(303, snapshot.ref.toString());
  });
});

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});
