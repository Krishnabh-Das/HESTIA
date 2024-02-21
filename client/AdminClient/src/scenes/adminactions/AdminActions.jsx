import { useEffect, useState } from "react";
import {
  Box,
  Card,
  CardContent,
  Snackbar,
  Typography,
  useTheme,
  useMediaQuery,
} from "@mui/material";
import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";
import CircularProgress from '@mui/material/CircularProgress';
import { db, auth, storage } from "../../config/firebase";
import Header from "../../components/Header";
import { ref, uploadBytes } from "firebase/storage";
import axios from 'axios';
import { useNavigate } from 'react-router-dom'; // Import useNavigate hook

import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import IconButton from '@mui/material/IconButton';

import ReplayIcon from '@mui/icons-material/Replay';
import MuiAlert from "@mui/material/Alert";


import { useDispatch, useSelector } from "react-redux";
import { setUser, setAuthChecked, selectUser, selectAuthChecked } from "../../state/userSlice";


import {
  onAuthStateChanged,
} from "firebase/auth";


import AdminActionsModal from '../../components/modals/AdminActionsModal'  






  const AdminActions = () => {

    const user = useSelector(selectUser);
    console.log("<>user in Admin Actions?>>>>>>>>>>>>>>>>>>>>>>>>>",user?.email);
    console.log("</>user in Admin Actions?>>>>>>>>>>>>>>>>>>>>>>>>>",user);
    // const theme = useTheme();
    const theme = useTheme();

    const [snackbarOpen, setSnackbarOpen] = useState(false);

    // const [user, setUser] = useState("");



    // useEffect(() => {
    //   const unsubscribe = onAuthStateChanged(auth, (user) => {
    //     setUser(user);
    //     // setAuthChecked(true); // Set to true once authentication state is checked
    //   });
  
    //   // Clean up the subscription when the component unmounts
    //   return () => unsubscribe();
    // }, []);

    // console.log("user iin admin actions>>>>>>>>>>>>>>>>>>>>", user.uid);

    const handleCloseSnackbar = (event, reason) => {
      if (reason === "clickaway") {
        return;
      }
  
      setSnackbarOpen(false);
    };
  
    
     //region state
  
     const [adminActionsList, setAdminActionsList] = useState([])
     const adminActionsRef = collection(db, "AdminActions")
  
     const getAdminActionsList = async ()=>{
      try{
        const data = await getDocs(adminActionsRef);
  
        const filteredData = data.docs.map((doc) => ({id: doc.id,
          ...doc.data(),
        }));

        setAdminActionsList(filteredData)
  
    console.log("||||||||||||||||||||||||||");
  
      }catch(err){
        console.error(err)
      }
     }
    
  
    //admin action state

    
  
    useEffect(() => {
      // getRegion();
      getAdminActionsList();
    }, []);
  
    console.log("adminActionsList in outside", adminActionsList);
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    //----------------------------------------
    // const { data, isLoading } = useGetAdminActionsQuery();
    const isNonMobile = useMediaQuery("(min-width: 1000px)");


    const [loading, setLoading] = useState(false);


    const handleAdminActionClick = async (actionRoute) => {
      try {
              // Set loading to true when the button is clicked
      setLoading(true);
 
        const response = await axios.put(`${actionRoute}`, { id:user.uid, email:user.email });

        const data = response.data;

        console.log("response after put request>>>>>>>>", data);
        setSnackbarOpen(true);
      } catch (error) {
        console.error("Error in handleAdminActionClick:", error);
      }
      finally {
        // Set loading back to false after the request is complete
        setLoading(false);
      }
    };
  
  
    // console.log("data in AdminActions>>>>>>", data);
  
    return (
      <Box m="1.5rem 2.5rem">
        <Header title="ADMIN ACTIONS" subtitle="trigger admin actions" />


        <Snackbar
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        open={snackbarOpen}
        autoHideDuration={6000}
        onClose={handleCloseSnackbar}
      >
        <MuiAlert
          elevation={6}
          variant="filled"
          onClose={handleCloseSnackbar}
          severity="success"
          sx={{ width: "500px" }} // Adjust the width as needed
        >
          Admin Action Success!
        </MuiAlert>
      </Snackbar>



 
      {adminActionsList.length !== 0 ? (
        <Box
          mt="20px"
          display="grid"
          gridTemplateColumns="repeat(4, minmax(0, 1fr))"
          justifyContent="space-between"
          rowGap="20px"
          columnGap="1.33%"
          sx={{
            "& > div": { gridColumn: isNonMobile ? undefined : "span 4" },
          }}
        >
          {adminActionsList.map(({ id, actionName, actionRoute, actionType }) => { 

            switch (actionType) {
              case 'url':
                return(
                  <Card
                  key={id}
                  sx={{
                    backgroundImage: "none",
                    backgroundColor: theme.palette.background.alt,
                    borderRadius: "0.55rem",
                  }}
                >
                  <CardContent>
                    <Typography
                      sx={{ fontSize: 20 }}
                      color={theme.palette.grey[50]}
                      gutterBottom
                    >
                      {actionName}
                    </Typography>
                    <Box
                      display="flex"
                      alignItems="center"
                      justifyContent="flex-end"
                    >
              <AdminActionsModal actionRoute={actionRoute}/>
    
                    </Box>
                  </CardContent>
                </Card> 
                )                

            
              default:
                return(
                  <Card
                  key={id}
                  sx={{
                    backgroundImage: "none",
                    backgroundColor: theme.palette.background.alt,
                    borderRadius: "0.55rem",
                  }}
                >
                  <CardContent>
                    <Typography
                      sx={{ fontSize: 20 }}
                      color={theme.palette.grey[50]}
                      gutterBottom
                    >
                      {actionName}
                    </Typography>
                    <Box
                      display="flex"
                      alignItems="center"
                      justifyContent="flex-end"
                    >
                      <IconButton
                        size="large"
                        sx={{
                backgroundColor: 'success.main',
      }}
                        onClick={() => handleAdminActionClick(actionRoute)}
                      >
                                          {loading ? (
                          <CircularProgress size={24} color="inherit" />
                        ) : (
                          <ReplayIcon fontSize="inherit" />
                        )}
                      </IconButton>
    
                    </Box>
                  </CardContent>
                </Card> 
                )

            }

          })} 
        </Box>
        
      ) : (
        <CircularProgress />
      )}
    </Box>
  );
};


export default AdminActions;