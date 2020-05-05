var admin = require("firebase-admin");

var serviceAccount = {
    "type": "service_account",
    "project_id": "tasks-project-ca5f2",
    "private_key_id": "d3af97408a36ea29d1cb32f72d9141c3050c086c",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCrjUxB5IwBQp+2\nX6Wro81T2oUUNOndJUmv5aFt7V9W362ZOf+g8G3qMyK0QxSn49ZrORib2ga8hmhH\nCg2jjAwWZLle3qG20I9HWh8ehzKL9RT1FWK7X+u1y7XM3XPzzhzCvTkRgYMcbxgQ\njiIn2/D3I1vY5DsFqrZxQ9M3TdFv3ff/uGXa60nCU+Q6uZ8WcboQRNuxcwKWuF60\nIMO77srVNRCgI1YDGhq7hTB0HtzwROrbrEN6ITlo/n1hL2w4MC6UzkilMzjsbUGo\npLf5ongkGkbQ/1sEArf1Kqxha59kWmAhNOdhIKkDZY878E2h8dsWR5IHETR8ZmeK\nxbW/bYPLAgMBAAECggEACBpW8T/RyxdyAsO2yAonHyBRq9gp+auStO+0NcSB/dD3\n2qZuKBRjJK5Ao+INPjbZQFxEiMv+CHaSw1Q6u7BYO9CLHuuGGOP1+IlNsfvxy8GK\nOV9GuBH6SK50ClalbO0d16bnZKfI4RVwPgvwmhBd69ZsNqzlCsn67xOkjNasn0t5\nS3LZfYxPHfgaG29ASHB9RO9kRtn+nJSqaCih4wi6CCf2IDc4PVgInxgw0zEqvuaJ\nni3d3mPR6pCGiZJe/gjwjf3IMUb4VYyakzvGO6XTJeWcmxEJH2JmLG/iQ0iFoZmT\nYZA7yW70/4egjEiDbgHdXrqojQ5+DolNW3m6EniVeQKBgQDpWIRVp/MAR0CTVv9d\nkuxe8eB0T86raI6+B7o8GWjdzUcemYhUZd5+Ak93A+SaNiGSMK7vwOVZNMnAUyR2\nBlxU6hYVhKGWnHkgeZVoWG3Z7jMFCfvxbFUYHYNk652lafYJAoXAoLDQqe7roOAs\nm/3zySi1m4Lg9XGH/0GkumIQSQKBgQC8NPtV7JuwoHq6FPI57k5s59Z4z6cdM265\nn0oJIWBqajhFIBcPoG+CfytkuKH489b4gqybcfi9Jfx+XBQYRmz2k5OsEnR5CwcZ\nYc8jWZT7MGxyOaqI8VLwMx2beGLYRHmDZQL7HQAKGFOGtZBBkHO6Q1FzX1qhA+3P\npLuOAWSbcwKBgQC4/nEjy1uua865QO6BS/rTJuVwsNjDMciAxXWTMf3eYmEw1D2t\n03k54zEGxPJWg/XHhYsbDo2FVIFiVUgBvfczZsYNVzIYSoMJCPs3V2v3q42NQCYa\nd21bCgLiXp2Dx2bEK9jIJ10mgKKm8crn8t+5h1Ab8mcnW88fJ3HuW8lk6QKBgHMm\nM1Q55HOnbA8nu5/oBsGpAtZ9rfA2xJr7M0/sxNG21WCtpo5gCXmdFs6UDD2F6tO3\nF6YvkBEiCZ7B9WV4yTf/yMzxqaNZNOm5pwMozvb0hJVKZOVOSQE/NPEnMcrB8lqK\n1c0PzDNg+NGlinIi0Dt47n+ZKpjzD3AIiNv0TDqzAoGAaYuY6cKWUqePNSfAFkuJ\nBEizgbQWAuAua1UAAfc2FUDbAELwTuL+mW3Ekmy3z0D42zb9fCP0CKigQ8qG7pKz\nOSVpXeVkd6FiBTOr/3TL/NTowFNK8FrOuuNGOT0dZSBf6PMm6OO/64Sq7r8P1T21\nL0VMFGXBqUO3y9/z0S7oLyo=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-qtzrt@tasks-project-ca5f2.iam.gserviceaccount.com",
    "client_id": "108934530511457545494",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-qtzrt%40tasks-project-ca5f2.iam.gserviceaccount.com"
};

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://tasks-project-ca5f2.firebaseio.com"
});

exports.CreateTaskList = function () {
    let docRef = db.collection('users').doc('alovelace');

    let setAda = docRef.set({
        first: 'Ada',
        last: 'Lovelace',
        born: 1815
    });
}