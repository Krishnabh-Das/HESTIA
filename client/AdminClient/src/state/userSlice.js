// userSlice.js
import { createSlice } from "@reduxjs/toolkit";

const userSlice = createSlice({
  name: "user",
  initialState: {
    user: null,
    authChecked: false,
  },
  reducers: {
    setUser: (state, action) => {
      state.user = action.payload;
      localStorage.setItem("user", JSON.stringify(action.payload));
    },
    setAuthChecked: (state) => {
      state.authChecked = true;
    },
  },
});

export const { setUser, setAuthChecked } = userSlice.actions;
export const selectUser = (state) => state.user.user;
export const selectAuthChecked = (state) => state.user.authChecked;

export default userSlice.reducer;
