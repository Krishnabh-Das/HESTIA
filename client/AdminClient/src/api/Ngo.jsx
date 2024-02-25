import {
    getDoc,
    getDocs,
    collection,
    addDoc,
    deleteDoc,
    updateDoc,
    doc,
    setDoc,
    query,
    where,
  } from "firebase/firestore";
  import axios from "axios";

import dayjs from 'dayjs'

  import { db, auth, storage } from "../config/firebase";


  export const fetchEvents = async() => { 
    try {
        const eventsRef = collection(db, "Events");
        const data = await getDocs(eventsRef);

        const filteredData = data.docs.map((doc) => ({
            event_id: doc.id,
            ...doc.data(),
          }));

          return filteredData;
    } catch (err) {
        console.log('error in fetching events', err);
    }
}

//    export async function fetchPosts() {
//     const response = await fetch('http://localhost:3000/posts');
//     return response.json()
// }


export const fetchEventsById = async (ngoID) => {
    try {
        const eventsRef = collection(db, "Events");
        const q = query(eventsRef, where("ngoId", "==", ngoID));
        const querySnapshot = await getDocs(q);

        const filteredData = querySnapshot.docs.map((doc) => ({
            event_id: doc.id,
            ...doc.data(),
        }));

        return filteredData;
    } catch (err) {
        console.log('error in fetching events by ID', err);
    }
};


export const fetchVolunteers = async () => { 
    try {
        const volunteersRef = collection(db, "Volunteers");
        const data = await getDocs(volunteersRef);


        const filteredData = data.docs.map((doc) => ({
            volunteer_id: doc.id,
            ...doc.data(),
          }));

          return filteredData;

    } catch (err) {
        console.log('error in fetching events', err);
    }
}


export const fetchVolunteerById = async (id) => { 
      try {
        const volunteerRef = doc(db, 'Volunteers', id);
        const volunteerDocSnapshot = await getDoc(volunteerRef);

        // if (volunteerDocSnapshot.exists()) {

        //     console.log("volunteer data", volunteerDocSnapshot.data());
        //   return volunteerDocSnapshot.data()
        // } else {
        //   console.log('Document does not exist!');
        // }
        const volunteer = volunteerDocSnapshot.data()

        console.log('volunteer data in api', volunteer);
        console.log('volunteer id in api', id);

        return volunteer;

      } catch (error) {
        console.error('Error fetching detail data:', error);
      }
    };

export const updateVolunteerStatusById = async (e) => { 
    try {
        const volunteerRef = doc(db, "Volunteers", e.id);

        await updateDoc(volunteerRef, {
            status: e.status,
          });


        
    } catch (err) {
        console.error('Error fetching detail data:', error);
    }
 }


export const getAllMarkers = async () => {
    try {
    const markersRef = collection(db, "Markers");
      const data = await getDocs(markersRef);

      const filteredData = data.docs.map((doc) => ({
        marker_id: doc.id,
        ...doc.data(),
      }));

      return filteredData;
    } catch (err) {
      console.error(err);
    }
  };


export const getFinderDetails = async (photo) => {
    try {
        const dummyData = {
            Custer: [
                "1708885500298","1708452071221","1708873467031", "1708885439721", "1708885452075", "1708885469893", "1708885469893"
            ],
            CusterId: "test"
        }

        const markers = [];

        for (const markerId of dummyData.Custer) {

            const marker = await getMarkerById(markerId);
            markers.push(marker);

//             const timeStamp = 1645891200000;

// // Convert timeStamp to date type
// const date = dayjs(timeStamp).toDate();

// console.log('timestamp to date?>>>>>>>>>>>>',date);
        }
        
        console.log('Markers in the appended array: >>>>>>>>>', markers);

                // Sort markers array based on the 'time' field in descending order
                markers.sort((a, b) => {
                    const timeA = dayjs.unix(a.time.seconds);
                    const timeB = dayjs.unix(b.time.seconds);
                    return timeB.diff(timeA); // Compare in descending order
                });
        
                console.log('Sorted Markers: >>>>>>>>>>>>>>>', markers);


        
        return {
            markers: markers
        };
    } catch (err) {
        console.error(err);
    }
}


export const getMarkerById = async (id) => { 
    try {
      const markerRef = doc(db, 'Markers', id);
      const markerDocSnapshot = await getDoc(markerRef);

      if (markerDocSnapshot.exists()) {
        console.log('marker data of markerDocSnapshot',markerDocSnapshot.data());

        return markerDocSnapshot.data()
      } else {
        console.log("Document does not exist!");
      }

      // if (volunteerDocSnapshot.exists()) {

      //     console.log("volunteer data", volunteerDocSnapshot.data());
      //   return volunteerDocSnapshot.data()
      // } else {
      //   console.log('Document does not exist!');
      // }
    //   const marker = markerDocSnapshot.data()

    //   console.log('marker id in api', id);
    //   console.log('marker data in api', marker);

    //   return marker;

    } catch (error) {
      console.error('Error fetching detail data:', error);
    }
  };



//    export async function fetchPosts() {
//     const response = await fetch('http://localhost:3000/posts');
//     return response.json()
// }
//   export async function fetchPost(id) {
//     const response = await fetch(`http://localhost:3000/posts/${id}`);
//     return response.json()
//   }
  
//   export async function createPost(newPost) {
//     const response = await fetch(`http://localhost:3000/posts`, {
//       method: "POST",
//       headers: {
//         "Content-Type": "application/json"
//       },
//       body: JSON.stringify(newPost)
//     });
//     return response.json()
//   }
  
//   export async function updatePost(updatedPost) {
//     const response = await fetch(`http://localhost:3000/posts/${updatedPost.id}`, {
//       method: "PUT",
//       headers: {
//         "Content-Type": "application/json"
//       },
//       body: JSON.stringify(updatedPost)
//     });
//     return response.json()
//   }
  
//   export async function deletePost(id) {
//     const response = await fetch(`http://localhost:3000/posts/${id}`, {
//       method: "DELETE",
//     });
//     return response.json()
//   }