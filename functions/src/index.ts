import * as functions from "firebase-functions";
// const axios = require('axios');
// const cors = require('cors')({ origin: true });
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

exports.onMessageScheduled = functions.firestore
    .document('rooms/{roomId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {
        console.log('Sent the notification to all!!', snapshot.data());
        // axios.post('https://apihub.yegobox.com/v2/api/sendToAll', {
        //     title: snapshot.data().title,
        //     message: snapshot.data().message,
        //     userId: snapshot.id
        // })
        //     .then((r: any) => {
        //         console.log(r);
        //         console.log('Sent the notification to all', snapshot.data().title, snapshot.data().message);
        //     })
        //     .catch(function () {
        //         console.log('Failed to send notification');
        //     });
    });
