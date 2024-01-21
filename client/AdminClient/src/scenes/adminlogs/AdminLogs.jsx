import { useEffect, useState } from "react";

import FlexBetween from "components/FlexBetween";
import Header from "components/Header";
import axios from 'axios';


import {
  DownloadOutlined,
  Email,
  Room,
  PointOfSale,
  PersonAdd,
  Traffic,
} from "@mui/icons-material";


import PushPinIcon from '@mui/icons-material/PushPin';

import SosIcon from '@mui/icons-material/Sos';
import {
  Box,
  Button,
  Typography,
  useTheme,
  Container
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import BreakdownChart from "components/BreakdownChart";
import OverviewChart from "components/OverviewChart";

import StatBox from "components/StatBox";


import { db } from "../../config/firebase";

import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";


import { useNavigate } from 'react-router-dom'; // Import useNavigate hook

function AdminLogs() {
 
const [adminLogList, setAdminLogList] = useState([]);
const adminLogRef = collection(db, "Admin_logs");


const getRegionMapLogList = async () => {
  try {
    const data = await getDocs(adminLogRef);

    const filteredData = data.docs.map((doc) => ({id:doc.id,
      ...doc.data(),
    }));

    setAdminLogList(filteredData)

  console.log("filtered data in adminLogRef>>>>>>>>", filteredData);
  } catch (err) {
    console.log("error in adminLogRef ref", err);
  }
}


     const theme = useTheme();
     
   const navigate = useNavigate();
   const [selectedRow, setSelectedRow] = useState(null);

     useEffect(() => {

         getRegionMapLogList();
 
       }, []);


       console.log("all region map log list>>>>>>>>>>>>>>>>>>>>>> ", adminLogList);

   const columns = [
     {
       field: "User_id",
       headerName: "userID",
       flex: 1,
     },
     {
      field: "User_email",
      headerName: "Email",
      flex: 1,
    },
     {
      field: "timStamp",
      headerName: "Timestamp",
      flex: 1,
    },

   ];
   return (
 
     <Box m="1.5rem 2.5rem"
     >
           <FlexBetween>
         <Header title="ADMIN LOGS" subtitle="the users that have accessed admin actions " />
 
         <Box>
           <Button
             sx={{
               backgroundColor: theme.palette.secondary.light,
               color: theme.palette.background.alt,
               fontSize: "14px",
               fontWeight: "bold",
               padding: "10px 20px",
             }}
           >
             <DownloadOutlined sx={{ mr: "10px" }} />
             Download Reports
           </Button>
         </Box>
       </FlexBetween>
       <Container maxWidth="lg">
       <Box
     display="flex"
     alignItems="center"
     justifyContent="center"
     // height='30vh'
             
             
             >
             <Box
         //   gridColumn="span 8"
         //   gridRow="span 3"
         mt={5}
           sx={{
             height: 600, width:'100%',
             "& .MuiDataGrid-root": {
               border: "none",
               borderRadius: "5rem",
             },
             "& .MuiDataGrid-cell": {
               borderBottom: "none",
             },
             "& .MuiDataGrid-columnHeaders": {
               backgroundColor: theme.palette.background.alt,
               color: theme.palette.secondary[100],
               borderBottom: "none",
             },
             "& .MuiDataGrid-virtualScroller": {
               backgroundColor: theme.palette.background.alt,
             },
             "& .MuiDataGrid-footerContainer": {
               backgroundColor: theme.palette.background.alt,
               color: theme.palette.secondary[100],
               borderTop: "none",
             },
             "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
               color: `${theme.palette.secondary[200]} !important`,
             },
           }}
         >
 
           <DataGrid
             // loading={isLoading || !sosList}
             getRowId={(row) => row.id }
             rows={(adminLogList && adminLogList) || []}
             columns={columns}
             // checkboxSelection

           />
         </Box>
         
             </Box>
       </Container>
 
 
     </Box>
 
   )
 
 
 }
 


export default AdminLogs