import { initializeApp } from "firebase/app";
import { getMessaging, onMessage, getToken } from "firebase/messaging";
import { getAuth, GoogleAuthProvider } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";
import { getAnalytics } from "firebase/analytics";


console.log({
  apiKey: import.meta.env.VITE_REACT_API_KEY,
  authDomain: import.meta.env.VITE_REACT_authDomain,
  storageBucket: import.meta.env.VITE_REACT_storageBucket,
  messagingSenderId: import.meta.env.VITE_REACT_messagingSenderId,
  appId: import.meta.env.VITE_REACT_appId,
  measurementId: import.meta.env.VITE_REACT_measurementId
})

const firebaseConfig = {
  apiKey: import.meta.env.VITE_REACT_API_KEY,
  projectId: import.meta.env.VITE_REACT_projectId,
  authDomain: import.meta.env.VITE_REACT_authDomain,
  storageBucket: import.meta.env.VITE_REACT_storageBucket,
  messagingSenderId: import.meta.env.VITE_REACT_messagingSenderId,
  appId: import.meta.env.VITE_REACT_appId,
  measurementId: import.meta.env.VITE_REACT_measurementId
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const messaging = getMessaging();



// const analytics = getAnalytics(app);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();

export const db = getFirestore(app);
export const storage = getStorage(app);


export const generateToken = async () => {
  const permission = await Notification.requestPermission();
  console.log(permission);

  console.log("vapid key",import.meta.env.VITE_REACT_VAPID_KEY );

  console.log("1");

  if(permission === "granted"){
  console.log("2");

    const token = await getToken(messaging, {
      vapidKey: import.meta.env.VITE_REACT_VAPID_KEY,
    });
  console.log("3");

    console.log(token);
  console.log("4");

  }
  console.log("5");

}