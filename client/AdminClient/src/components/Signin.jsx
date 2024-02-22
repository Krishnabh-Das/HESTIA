import * as React from 'react';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import FormControlLabel from '@mui/material/FormControlLabel';
import Checkbox from '@mui/material/Checkbox';
import Link from '@mui/material/Link';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import { createTheme, ThemeProvider } from '@mui/material/styles';

// import { db, auth, storage } from "../../config/firebase";
import { db, storage } from "../config/firebase";

import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";

import { auth } from "../config/firebase";
import {
  createUserWithEmailAndPassword,
  signInWithPopup,
  signOut,
  onAuthStateChanged,
  signInWithEmailAndPassword
} from "firebase/auth";

import { ref, uploadBytes } from "firebase/storage";

import { useNavigate } from 'react-router-dom'; // Import useNavigate hook

import { useDispatch } from "react-redux";
import { setUser, setAuthChecked, selectUser } from "../state/userSlice";
// import { Navigate, } from "react-router-dom";

// TODO remove, this demo shouldn't need to reset the theme.

const defaultTheme = createTheme();






export default function SignIn() {

  const dispatch = useDispatch();


  const navigate = useNavigate(); 


  const handleLogout = async() => { 
    try {
      await signOut(auth);
      // console.log(auth?.currentUser);
      localStorage.removeItem("user")
      dispatch(setUser(null))

      navigate('/auth')
  
      // console.log(auth?.currentUser?.email);
    } catch (err) {
      console.error(err);
    }
   }
  const handleSubmit = async (event) => {
      try {
          event.preventDefault();
        const data = new FormData(event.currentTarget);
        const email = data.get('email')
        const password = data.get('password')
        console.log({
        email, password
        });
        await signInWithEmailAndPassword(auth, email, password);
        // console.log(auth?.currentUser);
  
        // console.log(auth?.currentUser?.email);

        

        onAuthStateChanged(auth, (user) => {
            if (user) {
              // User is signed in, log the user information
              // console.log(user);
              // console.log(user.email);
              // console.log(user.uid);

              localStorage.setItem("user", JSON.stringify(user));

              dispatch(setUser(user));


            navigate('/')

    
              // You can navigate to the desired route here if needed
            //   navigate('/dashboard');
            } else {
              // User is signed out
              console.log('User signed out');
            }
          });

      } catch (err) {
        console.error(err);
      }





  };


  // console.log(auth?.currentUser);
  // console.log(auth?.currentUser?.email);
  // // console.log(auth?.currentUser?.accessToken);
  // console.log(auth?.currentUser?.uid);


  return (



    <ThemeProvider theme={defaultTheme}>
      <Container component="main" maxWidth="xs">
        <CssBaseline />
        <Box
          sx={{
            marginTop: 8,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          }}
        >
          <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
            <LockOutlinedIcon />
          </Avatar>
          <Typography component="h1" variant="h5">
            Sign in
          </Typography>
          <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
            <TextField
              margin="normal"
              required
              fullWidth
              id="email"
              label="Email Address"
              name="email"
              autoComplete="email"
              autoFocus
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Password"
              type="password"
              id="password"
              autoComplete="current-password"
            />
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Sign In
            </Button>
            {/* <Grid container>
              <Grid item xs>
                <Link href="#" variant="body2">
                  Forgot password?
                </Link>
              </Grid>
              <Grid item>
                <Link href="#" variant="body2">
                  {"Don't have an account? Sign Up"}
                </Link>
              </Grid>
            </Grid> */}
          </Box>
        </Box>
      </Container>
    </ThemeProvider>
  );
}