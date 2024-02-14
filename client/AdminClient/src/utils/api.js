// api.js

const BASE_URL = "https://example.com/api";

export const API_ROUTES = {
  LOGIN: "/auth/login",
  USER_PROFILE: "/user/profile",
  POSTS: "/posts",
  // Add more routes as needed
};

export function getFullUrl(route) {
  return `${BASE_URL}${route}`;
}



// import React, { useState, useEffect } from "react";
// import axios from "axios";
// import { API_ROUTES, getFullUrl } from "./utils/api";

// function UserProfile() {
//   const [userData, setUserData] = useState(null);

//   useEffect(() => {
//     async function fetchUserProfile() {
//       try {
//         const response = await axios.get(getFullUrl(API_ROUTES.USER_PROFILE));
//         setUserData(response.data);
//       } catch (error) {
//         console.error("Error fetching user profile:", error);
//       }
//     }

//     fetchUserProfile();
//   }, []);

//   return (
//     <div>
//       {userData ? (
//         <div>
//           <h2>{userData.name}'s Profile</h2>
//           {/* Render user profile data */}
//         </div>
//       ) : (
//         <p>Loading...</p>
//       )}
//     </div>
//   );
// }

// export default UserProfile;
