
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
admin.initializeApp();

const fcm = admin.messaging();
const firestore = admin.firestore();

export const writeNewsPostNotification = functions.firestore
.document('posts/{postId}')
.onWrite(async snapshot => {
    
    const newPost = snapshot.after.data();
    if(newPost != undefined) {
        const topic = (await firestore.collection('topics').doc(newPost.topicId).get()).data();
        const mosqueData = (await firestore.collection('mosques').doc(newPost.mosqueId).get()).data();

        if(topic != undefined && mosqueData != undefined) {
    
            var mosqueName = mosqueData.Name;
            var mosqueOrt = mosqueData.Ort;
            var mosqueKanton = mosqueData.Kanton;
    
           
            
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
                
                const isDraft = (newPost.draft);
            
                if(newPost.sendNotification == true && !isDraft) {
                    console.log(`${newPost.title} ${newPost.url} ${admin.database.ServerValue.TIMESTAMP}`);
                    firestore.collection('posts').doc(snapshot.after.id).update({sendNotification: false});
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

