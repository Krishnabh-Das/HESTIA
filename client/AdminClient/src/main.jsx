import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import { configureStore } from "@reduxjs/toolkit";
import globalReducer from "./state/index";
import { Provider } from "react-redux";
import { setupListeners } from "@reduxjs/toolkit/query";
import './index.css'

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import userReducer from "./state/userSlice";

const queryClient = new QueryClient();


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
    <QueryClientProvider client={queryClient}>
      <App />
      <ReactQueryDevtools initialIsOpen={true} />
      </QueryClientProvider>
    </Provider>
  </React.StrictMode>
)
