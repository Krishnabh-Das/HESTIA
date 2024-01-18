import { CssBaseline, ThemeProvider } from "@mui/material";
import { createTheme } from "@mui/material/styles";
import { useMemo, useState, useEffect } from "react";
import { useSelector } from "react-redux";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { themeSettings } from "theme";
import Layout from "scenes/layout";
import Dashboard from "scenes/dashboard";
import Regionmap from "scenes/regionmap";
// import Admin from "scenes/admin";
import SosReports from "scenes/sosreports/SosReports";
import RegionMapLogs from "scenes/regionmaplogs/RegionMapLogs";
import AdminActions from "scenes/adminactions/AdminActions";

import Markers from "scenes/markers/Markers";

import DetailPage from "components/DetailPage";
import MarkerDetailPage from "components/MarkerDetailPage";
import Signin from "components/Signin";



import {auth} from "./config/firebase";

import {
  onAuthStateChanged,
} from "firebase/auth";

function App() {
  const [user, setUser] = useState(null);
  const [authChecked, setAuthChecked] = useState(false);

  // Listen for authentication state changes
  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setUser(user);
      setAuthChecked(true); // Set to true once authentication state is checked
    });

    // Clean up the subscription when the component unmounts
    return () => unsubscribe();
  }, []);

  const mode = useSelector((state) => state.global.mode);
  const theme = useMemo(() => createTheme(themeSettings(mode)), [mode]);

  // If authentication state is not yet checked, you can show a loading spinner or some other UI
  if (!authChecked) {
    return <div>Loading...</div>;
  }


  console.log("auth in App js>>>>>>>>>>>>>>>>>>>>>>>>>",auth?.currentUser?.email);
  console.log("user in App js>>>>>>>>>>>>>>>>>>>>>>>>>",user?.email);

  console.log(auth?.currentUser?.uid);
  return (
    <div className="app">
      <BrowserRouter>
        <ThemeProvider theme={theme}>
          <CssBaseline />
          <Routes>
          <Route path="/auth" element={<Signin/>} />
            {/* <Route path="/auth" element={ !user ? <AuthPage/> : <Navigate to="/"/> }/> */}
            <Route element={<Layout />}>
              <Route path="/" element={user? (<Navigate to="/dashboard" replace />):(<Navigate to="/auth" replace />)} />
              <Route path="/dashboard" element={user? (<Dashboard />): (<Navigate to="/auth" replace />)} />
              <Route path="/details/:id" element={user? (<DetailPage />): (<Navigate to="/auth" replace />)} />
              <Route path="/markers/:id" element={user? (<MarkerDetailPage/>) : (<Navigate to="/auth" replace />)} />
              <Route path="/sosreports" element={user? (<SosReports />): (<Navigate to="/auth" replace />)} />
              <Route path="/regionmaplogs" element={user? (<RegionMapLogs />): (<Navigate to="/auth" replace />)} />
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
