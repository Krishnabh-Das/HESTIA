import * as React from 'react';
// import Button from '@mui/material/Button';
// import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';


import { Field, Form, Formik } from "formik";
import { object, string } from "yup";

import axios from 'axios';

import {db} from "../../config/firebase";

import { addDoc, collection, deleteDoc, doc, getDocs, updateDoc } from 'firebase/firestore'
import PlayArrowIcon from '@mui/icons-material/PlayArrow';


import {
  TextField, 
  Button,

    Box,
    Card,
    CardContent,
    Snackbar,
    Typography,
    useTheme,
    useMediaQuery,
  } from "@mui/material";

import IconButton from '@mui/material/IconButton';

import ReplayIcon from '@mui/icons-material/Replay';


import { useDispatch, useSelector } from "react-redux";
import { setUser, setAuthChecked, selectUser, selectAuthChecked } from "../../state/userSlice";



export default function FormDialog({actionRoute}) {

  console.log("action route in my add context url", actionRoute);

  const user = useSelector(selectUser);
  // console.log("<>user in Admin Actions?>>>>>>>>>>>>>>>>>>>>>>>>>",user?.email);
  // console.log("<>user in Admin Actions?>>>>>>>>>>>>>>>>>>>>>>>>>",user?.uid);
  // console.log("</>user in Admin Actions?>>>>>>>>>>>>>>>>>>>>>>>>>",user);



  const [open, setOpen] = React.useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };


const handleAddUrl = async ({url}) => { 
  console.log("handle url>>>>", url);
  try {
                  // Set loading to true when the button is clicked
                  // setLoading(true);
 
                  const response = await axios.put(`${actionRoute}`, { user_id:user?.uid, url:url });
          
                  const data = response.data;

                  console.log("response after put request>>>>>>>>", data);
                  // setSnackbarOpen(true);
    
  } catch (error) {
    console.error("Error in handleAddUrl:", error);
  }
  // finally {
  //   // Set loading back to false after the request is complete
  //   setLoading(false);
  // }

 }


  const initalValues = {
    // email: "",
    // name: "",
    // password: "",
    url: '',
  };

  return (
    <React.Fragment>
      {/* <Button variant="outlined" onClick={handleClickOpen}>
        Open form dialog
      </Button> */}
      <Box>
      <IconButton
                    size="large"
                    sx={{
            backgroundColor: 'success.main',
  }}
                    onClick={handleClickOpen}
                  >

                      <PlayArrowIcon fontSize="inherit" />

                  </IconButton>
      </Box>


      <Dialog
        open={open}
        onClose={handleClose}
        // PaperProps={{
        //   component: 'form',
        //   onSubmit: (event) => {
        //     event.preventDefault();
        //     const formData = new FormData(event.currentTarget);
        //     const formJson = Object.fromEntries(formData.entries());
        //     const email = formJson.email;
        //     console.log(email);
        //     handleClose();
        //   },
        // }}
      >
        <DialogTitle>Add Context Url</DialogTitle>
        <DialogContent>


        <div 
        // className="MaterialForm"
        >
      {/* <Typography variant="h4">
        Add a url to continue forward
      </Typography> */}
      <Formik
        initialValues={initalValues}
        validationSchema={object({
          // email: string().required("Please enter email").email("Invalid email"),
          url: string().required("please enter a valid url").url(),
          // name: string().required("Please enter name").min(2, "Name too short"),
          // password: string()
          //   .required("Please enter password")
          //   .min(7, "Password should be minimum 7 characters long"),
        })}
        onSubmit={(values, formikHelpers) => {
          console.log(values);
          handleAddUrl(values)
          
          formikHelpers.resetForm();
        }}
      >
        {({ errors, isValid, touched, dirty }) => (
          <Form>
                        <Box height={14} />
                        <Field
                        my={20}
              name="url"
              // type="email"
              as={TextField}
              variant="outlined"
              color="primary"
              label="url"
              fullWidth
              error={Boolean(errors.url) && Boolean(touched.url)}
              helperText={Boolean(touched.url) && errors.url}
            />
            <Box height={14} />

{/* 

            <Field
              name="email"
              type="email"
              as={TextField}
              variant="outlined"
              color="primary"
              label="Email"
              fullWidth
              error={Boolean(errors.email) && Boolean(touched.email)}
              helperText={Boolean(touched.email) && errors.email}
            />
            <Box height={14} />

            <Field
              name="name"
              type="name"
              as={TextField}
              variant="outlined"
              color="primary"
              label="Name"
              fullWidth
              error={Boolean(errors.name) && Boolean(touched.name)}
              helperText={Boolean(touched.name) && errors.name}
            />
            <Box height={14} />
            <Field
              name="password"
              type="password"
              as={TextField}
              variant="outlined"
              color="primary"
              label="Password"
              fullWidth
              error={Boolean(errors.password) && Boolean(touched.password)}
              helperText={Boolean(touched.password) && errors.password}
            />
            <Box height={14} /> */}

            <Button
              type="submit"
              variant="contained"
              color="primary"
              size="large"
              disabled={!isValid || !dirty}
            >
              ADD
            </Button>

            <Button
              onClick={handleClose}
              variant="contained"
              color="primary"
              size="large"
              // disabled={!isValid || !dirty}
            >
              Close
            </Button>
          </Form>
        )}
      </Formik>
    </div>




          {/* <TextField
            autoFocus
            required
            margin="dense"
            id="name"
            name="email"
            label="Email Address"
            type="email"
            fullWidth
            variant="standard"
          /> */}




        </DialogContent>
        {/* <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button type="submit">Add</Button>
        </DialogActions> */}
      </Dialog>
    </React.Fragment>
  );
}
