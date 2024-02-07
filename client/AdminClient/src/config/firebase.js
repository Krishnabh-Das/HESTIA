import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";
import { getAnalytics } from "firebase/analytics";

// const firebaseConfig = {
//   apiKey: "AIzaSyAlztMMVXKXA5oSVpwe0XthJ6TWNe31BSo",
//   authDomain: "fir-course-beba9.firebaseapp.com",
//   projectId: "fir-course-beba9",
//   storageBucket: "fir-course-beba9.appspot.com",
//   messagingSenderId: "236316955671",
//   appId: "1:236316955671:web:2b18d92e1b6644fae3f852",
//   measurementId: "G-HENJ7D82KH",
// };

// const app = initializeApp(firebaseConfig);
// export const auth = getAuth(app);
// export const googleProvider = new GoogleAuthProvider();

// export const db = getFirestore(app);
// export const storage = getStorage(app);

// ---------------------------------------

// Import the functions you need from the SDKs you need
// import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyCj2qJGz3y_ovrNE7F3GTLwWVtZEa7l1Z4",
  authDomain: "hestia-c73a5.firebaseapp.com",
  projectId: "hestia-c73a5",
  storageBucket: "hestia-c73a5.appspot.com",
  messagingSenderId: "677683607683",
  appId: "1:677683607683:web:0b8ee32b7f349d9807c3b6",
  measurementId: "G-T2W7D1CCP6"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// const analytics = getAnalytics(app);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();

export const db = getFirestore(app);
export const storage = getStorage(app);