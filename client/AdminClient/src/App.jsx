import { CssBaseline, ThemeProvider } from "@mui/material";
import { createTheme } from "@mui/material/styles";
import { useMemo, useEffect, useState } from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { themeSettings } from "./config/theme";
import Layout from "./scenes/layout";
import Dashboard from "./scenes/dashboard";
import Regionmap from "./scenes/regionmap";
// import Admin from "scenes/admin";
import SosReports from "./scenes/sosreports/SosReports";
import AdminLogs from "./scenes/adminlogs/AdminLogs";
import AdminActions from "./scenes/adminactions/AdminActions";

import Markers from "./scenes/markers/Markers";

import DetailPage from "./components/DetailPage";
import MarkerDetailPage from "./components/MarkerDetailPage";
import Signin from "./components/Signin";

import './App.css'

import {auth, generateToken, messaging} from "./config/firebase";

import {
  onAuthStateChanged,
} from "firebase/auth";

import { useDispatch, useSelector } from "react-redux";

import { setUser, setAuthChecked, selectUser, selectAuthChecked } from "./state/userSlice";
import { onMessage } from "firebase/messaging";


import {
  Snackbar,
} from "@mui/material";
import MuiAlert from "@mui/material/Alert";


import { Toaster, toast } from 'sonner'


// import toast, { Toaster } from 'react-hot-toast';


function App() {

  const [snackbarOpen, setSnackbarOpen] = useState(false);

  const [notification, setNotification] = useState({title: '', body: ''});
  


  const handleCloseSnackbar = (event, reason) => {
    if (reason === "clickaway") {
      return;
    }

    setSnackbarOpen(false);
  };

  useEffect(() => {
    generateToken();
    onMessage(messaging, (payload) => {
      console.log("payload>>>>", payload);
      // toast('Here is your toast.')
      setSnackbarOpen(true);

      setNotification({title: payload?.notification?.title, body: payload?.notification?.body});     

    })
  }, [])
  

  const user = useSelector(selectUser);


  const mode = useSelector((state) => state.global.mode);
  const theme = useMemo(() => createTheme(themeSettings(mode)), [mode]);

  // console.log("auth in App js>>>>>>>>>>>>>>>>>>>>>>>>>",auth?.currentUser?.email);
  // console.log("</> user  in App js>>>>>>>>>>>>>>>>>>>>>>>>>",user);
  // console.log("</> user email in App js>>>>>>>>>>>>>>>>>>>>>>>>>",user?.email);

  // console.log(auth?.currentUser?.uid);
  return (
    <div className="app">
                  <Snackbar
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
        open={snackbarOpen}
        autoHideDuration={6000}
        onClose={handleCloseSnackbar}
      >
        <MuiAlert
          elevation={6}
          // variant="outlined"
          onClose={handleCloseSnackbar}
          severity="error"
          sx={{ width: "500px" }} // Adjust the width as needed
        >
          <b><strong>{notification?.title}</strong></b>
          <p>{notification?.body}</p>
        </MuiAlert>
      </Snackbar>

      <Toaster richColors  position="bottom-center"/>

      <BrowserRouter>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <Routes>
          <Route path="/auth" element={user ? (<Navigate to="/"/>) : (<Signin/>)} />
            {/* <Route path="/auth" element={ !user ? <AuthPage/> : <Navigate to="/"/> }/> */}
            <Route element={<Layout />}>
              






              <Route path="/" element={user? (<Navigate to="/dashboard" replace />):(<Navigate to="/auth" replace />)} />
              <Route path="/dashboard" element={user? (<Dashboard />): (<Navigate to="/auth" replace />)} />
              <Route path="/details/:id" element={user? (<DetailPage />): (<Navigate to="/auth" replace />)} />
              <Route path="/markers/:id" element={user? (<MarkerDetailPage/>) : (<Navigate to="/auth" replace />)} />
              <Route path="/sosreports" element={user? (<SosReports />): (<Navigate to="/auth" replace />)} />
              <Route path="/adminlogs" element={user? (<AdminLogs />): (<Navigate to="/auth" replace />)} />
              <Route path="/markers" element={user? (<Markers />): (<Navigate to="/auth" replace />)} />
              <Route path="/regionmap" element={user? (<Regionmap />): (<Navigate to="/auth" replace />)} />
              {/* <Route path="/admin" element={user? (<Admin />) : (<Navigate to="/auth" replace />)} /> */}
              <Route path="/adminactions" element={user? (<AdminActions />) : (<Navigate to="/auth" replace />)} />
            </Route>
          </Routes>
        </ThemeProvider>
      </BrowserRouter>
    </div>
  );
}

export default App;