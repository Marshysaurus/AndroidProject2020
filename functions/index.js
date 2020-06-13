const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { firestore } = require("firebase-admin");

admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

const stripe = require("stripe")(functions.config().stripe.private_key);

exports.createStripeCustomer = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const newUser = snap.data();

    const stripeCustomer = await stripe.customers.create({
      email: newUser.email,
      name: newUser.name,
    });

    const stripeId = stripeCustomer.id;

    await snap.ref.set({ stripe_id: stripeId }, { merge: true });

    return true;
  });

exports.addPaymentMethod = functions.https.onCall(async (data, context) => {
  const { id } = data;
  const uid = context.auth.uid;

  const user = await (await db.collection("users").doc(uid).get()).data();

  const stripe_id = user.stripe_id;

  const response = await stripe.paymentMethods.attach(id, {
    customer: stripe_id,
  });

  await db.collection("users").doc(uid).collection("methods").add({
    stripe_id: response.id,
    brand: response.card.brand,
    last4: response.card.last4,
    name: response.billing_details.name,
  });

  return response;
});
