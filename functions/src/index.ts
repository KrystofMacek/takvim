
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
admin.initializeApp();

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

export const updateNewsPostNotification = functions.firestore
.document('posts/{postId}')
.onUpdate(async snapshot => {
    const newPost = snapshot.after.data();
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

