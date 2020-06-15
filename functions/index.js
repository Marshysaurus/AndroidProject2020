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
  const { id, uid } = data;

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

exports.deletePaymentMethod = functions.https.onCall(async (data, context) => {
  const { id, uid } = data;

  const method = await (
    await db.collection("users").doc(uid).collection("methods").doc(id).get()
  ).data();

  const response = await stripe.paymentMethods.detach(method.stripe_id);

  await db.collection("users").doc(uid).collection("methods").doc(id).delete();

  return response;
});

exports.getAllProducts = functions.https.onCall(async (data, context) => {
  return db
    .collection("categories")
    .get()
    .then((categories) => {
      return Promise.all(
        categories.docs.map((category) => {
          if (category.id === "promotions") return [];

          return category.ref
            .collection("products")
            .get()
            .then((productDocs) => {
              return productDocs.docs;
            });
        })
      );
    })
    .then((productResponses) => {
      const productDocs = [];
      productResponses.forEach((productResponse) => {
        productDocs.push(...productResponse);
      });

      const products = productDocs.map((productDoc) => {
        return { ...productDoc.data(), id: productDoc.id };
      });

      return products;
    });
});

exports.payWithMethod = functions.https.onCall(async (data, context) => {
  const { payment_method_id, currency, amount, uid, products } = data;

  const user = await (await db.collection("users").doc(uid).get()).data();

  const stripe_id = user.stripe_id;

  const paymentIntent = await stripe.paymentIntents.create({
    amount,
    currency,
    payment_method: payment_method_id,
    payment_method_types: ["card"],
    confirm: true,
    customer: stripe_id,
  });

  await db
    .collection("users")
    .doc(uid)
    .collection("orders")
    .add({
      products,
      stripe_id: paymentIntent.id,
      amount,
      currency,
      created_at: new Date(paymentIntent.created * 1000),
      status: paymentIntent.status,
    });

  return paymentIntent;
});
