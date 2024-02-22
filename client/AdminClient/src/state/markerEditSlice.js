// userSlice.js
import { createSlice } from "@reduxjs/toolkit";

const userSlice = createSlice({
  name: "markerEdit",
  initialState: {
    description: '',
  },
  reducers: {
    setDescription: (state, action) => {
      state.description = action.payload;
    },
  },
});

export const { setDescription, setAuthChecked } = userSlice.actions;
export const selectUser = (state) => state.markerEdit.description;

export default userSlice.reducer;
