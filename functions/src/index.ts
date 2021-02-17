
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
admin.initializeApp();

const fcm = admin.messaging();
const firestore = admin.firestore();
const db = admin.database();

export const createNewsPostNotification = functions.firestore
.document('posts/{postId}')
.onCreate(async snapshot => {
    const newPost = snapshot.data();

    console.log(newPost);

    if(newPost != undefined) {
        const notification = (await firestore.collection('topics').doc(newPost.topicId).get()).data();

        if(notification != undefined) {
            console.log(notification);
    
            var mosqueName = '';
            var mosqueOrt = '';
            var mosqueKanton = '';
    
            await db.ref().child('mosques').child(`${newPost.mosqueId}`).on('value', function(snapshot) {
                const mosque = snapshot.val();
                mosqueName = mosque.Name;
                mosqueOrt = mosque.Ort;
                mosqueKanton = mosque.Kanton;
                
                console.log(`${mosqueOrt} ${mosqueKanton} / ${mosqueName}`);
            
      
                if(mosqueName.length > 0 && mosqueOrt.length > 0 && mosqueKanton.length > 0) {
                    const payload: admin.messaging.MessagingPayload = {
                        notification: {
                            title: newPost.title,
                            body: `${mosqueOrt} ${mosqueKanton} / ${mosqueName}`,
                            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                        },
                        data: {
                            URL: newPost.url
                        }
                    }
                
                    if(newPost.sendNotification == true) {
                        return fcm.sendToTopic(newPost.topicId, payload);
                    } else {
                        return;
                    }
                } else {
                    return;
                }
            });
    
           
        } else {
            return;
        }
    } else {
        return;
    }
    
});

export const updateNewsPostNotification = functions.firestore
.document('posts/{postId}')
.onUpdate(async snapshot => {
    
    const newPost = snapshot.after.data();
    if(newPost != undefined) {
        const notification = (await firestore.collection('topics').doc(newPost.topicId).get()).data();

        if(notification != undefined) {
    
            var mosqueName = '';
            var mosqueOrt = '';
            var mosqueKanton = '';
    
            db.ref().child('mosques').child(`${newPost.mosqueId}`).on('value', function(snapshot) {
                const mosque = snapshot.val();
                mosqueName = mosque.Name;
                mosqueOrt = mosque.Ort;
                mosqueKanton = mosque.Kanton;
            });
            
            if(mosqueName.length > 0 && mosqueOrt.length > 0 && mosqueKanton.length > 0) {
                const payload: admin.messaging.MessagingPayload = {
                    notification: {
                        title: newPost.title,
                        body: `${mosqueOrt} ${mosqueKanton} / ${mosqueName}`,
                        clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                    },
                    data: {
                        URL: newPost.url
                    }
                }
            
                if(newPost.sendNotification == true) {
                    return fcm.sendToTopic(newPost.topicId, payload);
                } else {
                    return;
                }
            } else {
                return;
            }
        
           
        } else {
            return;
        }
    } else {
        return;
    }
    
});

