const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendHealthAlertNotification = functions.firestore
    .document("users/{userId}/alerts/{alertId}")
    .onCreate(async (snap, context) => {
      const alert = snap.data();
      const userId = context.params.userId;

      const notifiedUsers = alert.notifiedUsers || [userId];
      const tokens = [];

      for (const uid of notifiedUsers) {
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(uid)
            .get();
        if (userDoc.exists && userDoc.data().fcmToken) {
          tokens.push(userDoc.data().fcmToken);
        }
      }

      if (tokens.length === 0) {
        console.log("No FCM tokens found for notified users.");
        return null;
      }

      const payload = {
        notification: {
          title: "CRITICAL HEALTH ALERT",
          body: alert.message || "A crucial health event was detected!",
          sound: "alert_sound.mp3",
        },
        data: {
          type: alert.type || "",
          value:
          String(
            alert.value !== undefined && alert.value !== null ?
              alert.value :
              "",
          ),
          alertId: context.params.alertId,
        },
        android: {
          priority: "high",
          notification: {
            channel_id: "health_alerts",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "alert_sound.caf",
              category: "HEALTH_ALERT",
            },
          },
        },
      };

      await admin.messaging().sendToDevice(tokens, payload);
      return null;
    });
