import { CssBaseline, ThemeProvider } from "@mui/material";
import { createTheme } from "@mui/material/styles";
import { useMemo, useEffect } from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { themeSettings } from "./config/theme";
import Layout from "./scenes/layout";
import Dashboard from "./scenes/dashboard";
import Regionmap from "./scenes/regionmap";
// import Admin from "scenes/admin";
import SosReports from "./scenes/sosreports/SosReports";
// import AdminLogs from "./scenes/adminlogs/AdminLogs";
// import AdminActions from "./scenes/adminactions/AdminActions";
import CreateEvent from "./scenes/createEvent/CreateEvent";

import Markers from "./scenes/markers/Markers";

import DetailPage from "./components/DetailPage";
import MarkerDetailPage from "./components/MarkerDetailPage";
import Signin from "./components/Signin";
import './App.css'

import EventDetails from './scenes/eventDetails/EventDetails'

import {auth} from "./config/firebase";

import {
  onAuthStateChanged,
} from "firebase/auth";

import { useDispatch, useSelector } from "react-redux";

import { setUser, setAuthChecked, selectUser, selectAuthChecked } from "./state/userSlice";

function App() {

  const user = useSelector(selectUser);


  const mode = useSelector((state) => state.global.mode);
  const theme = useMemo(() => createTheme(themeSettings(mode)), [mode]);

  // console.log("auth in App js>>>>>>>>>>>>>>>>>>>>>>>>>",auth?.currentUser?.email);
  // console.log("</> user  in App js>>>>>>>>>>>>>>>>>>>>>>>>>",user);
  // console.log("</> user email in App js>>>>>>>>>>>>>>>>>>>>>>>>>",user?.email);

  console.log(auth?.currentUser?.uid);
  return (
    <div className="app">
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
             
              <Route path="/markers" element={user? (<Markers />): (<Navigate to="/auth" replace />)} />
              <Route path="/regionmap" element={user? (<Regionmap />): (<Navigate to="/auth" replace />)} />
              {/* <Route path="/admin" element={user? (<Admin />) : (<Navigate to="/auth" replace />)} /> */}
              <Route path="/createevents" element={user? (<CreateEvent />): (<Navigate to="/auth" replace />)} />
              <Route path="/eventdetails" element={user? (<EventDetails />): (<Navigate to="/auth" replace />)} />
            </Route>
          </Routes>
        </ThemeProvider>
      </BrowserRouter>
    </div>
  );
}

export default App;