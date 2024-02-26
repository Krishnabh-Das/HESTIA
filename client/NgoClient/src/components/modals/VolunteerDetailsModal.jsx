import * as React from 'react';

import { useState, Fragment } from "react";
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


import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { fetchVolunteerById } from '../../api/Ngo';

export default function FormDialog({params}) {
  const {volunteer_id} = params.row;



  const user = useSelector(selectUser);


  const [open, setOpen] = useState(false);

  const handleClickOpen = () => {
    setOpen(true);
  
  


  };

  const handleClose = () => {
    setOpen(false);
  };

  console.log('1');

  console.log("volunteer ID>>>>>>", volunteer_id);

  // const {
  //   isLoading,
  //   isError,
  //   data: volunteer,
  //   error,
  // } = useQuery({
  //   queryKey: ["volunteer", volunteer_id],
  //   queryFn: () => fetchVolunteerById(volunteer_id),
  // });

  const { isLoading, isError, data: volunteer, error } = useQuery({
    queryKey: ["volunteer", volunteer_id],
    queryFn: () => fetchVolunteerById(volunteer_id),
  });

  // Handle loading and error states
  if (isLoading) return <div>Loading...</div>;
  if (isError) return <div>Error: {error.message}</div>;



  return (
    <Fragment>
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
        <DialogTitle>
          <Typography >Volunteer Details</Typography>
        </DialogTitle>
        <DialogContent>
          <Box> 
            
          </Box>
        </DialogContent>

      </Dialog>
    </Fragment>
  );
}
