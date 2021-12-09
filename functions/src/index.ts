import * as functions from "firebase-functions";
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

exports.onMessageScheduled = functions.firestore
    .document('rooms/{roomId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {
        const roomId = snapshot.data().roomId;
        const authorId = snapshot.data().authorId;
        const text = snapshot.data().text;

        return db.collection("rooms").doc(roomId).get().then((snapshot: any) => {
            snapshot.data().userIds.forEach((topic: string) => {
                if (topic != authorId) {
                    /// send notification to all the users in the room except the author
                    console.log("topic::", topic);
                    const payload = {
                        notification: {
                            title: text,
                            body: text,
                            icon: 'https://placeimg.com/100/100/any',
                            // click_action: "https://yegobox.com/chat/" + roomId
                            click_action: "FLUTTER_NOTIFICATION_CLICK",
                        },
                        data: {
                            id: roomId,
                            authorId: authorId,
                            text: text,
                            route: "chat",
                        },
                        topic: topic,
                    };

                    return admin.messaging().sendToTopic(topic, payload);
                }
            });
            //dummy return for a function to be happy no idea of better way!
            return 22;
        }).catch((e: any) => {
            console.error('got error', e);
        })
    });



// second

// exports.changeLastMessage = functions.firestore
//     .document('rooms/{roomId}/messages/{messageId}')
//     .onUpdate((change, context) => {
//         const message = change.after.data()
//         if (message) {
//             return db.doc('rooms/' + context.params.roomId).update({
//                 lastMessages: [message],
//             })
//         } else {
//             return null
//         }
//     })

// third
exports.changeMessageStatus = functions.firestore
    .document('rooms/{roomId}/messages/{messageId}')
    .onWrite((change): any => {
        const message = change.after.data()
        if (message) {
            if (['delivered', 'seen', 'sent'].includes(message.status)) {
                return null
            } else {
                return change.after.ref.update({
                    status: 'delivered',
                })
            }
        } else {
            return null
        }
    })