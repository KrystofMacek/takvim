import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const newNewsPostNotification = functions.firestore
.document('posts/{postId}')
.onCreate(async snapshot => {
    const newPost = snapshot.data();
    const payload: admin.messaging.MessagingPayload = {
        notification: {
            title: newPost.notificationTitle,
            body: newPost.notificationBody,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
        },
        data: {
            URL: newPost.url
        }
    }

    if(newPost.sendNotification == true) {
        return fcm.sendToTopic(newPost.topic, payload);
    } else {
        return;
    }
});

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
