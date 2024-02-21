import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import { configureStore } from "@reduxjs/toolkit";
import globalReducer from "./state/index";
import { Provider } from "react-redux";
import { setupListeners } from "@reduxjs/toolkit/query";
import './index.css'
// import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';

// import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';


import userReducer from "./state/userSlice";

const store = configureStore({
  reducer: {
    global: globalReducer,
    user: userReducer
  },
});
setupListeners(store.dispatch);

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <Provider store={store}>
    {/* <LocalizationProvider dateAdapter={AdapterDayjs}> */}
      <App />
      {/* </LocalizationProvider> */}
    </Provider>
  </React.StrictMode>
)
