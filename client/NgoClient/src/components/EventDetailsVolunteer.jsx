import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import {
  Box,
  Tab,
  Tabs,
  Typography,
  Button,
  CardMedia,
  CardActions,
  Card,
  CardContent,
  Snackbar,
  useTheme,
  useMediaQuery,
  IconButton,
  Tooltip,
  Container,
  TextField,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import { useDispatch, useSelector } from "react-redux";

import CancelIcon from '@mui/icons-material/Cancel';
import HourglassTopIcon from '@mui/icons-material/HourglassTop';
import VerifiedUserIcon from '@mui/icons-material/VerifiedUser';
import { setUser, setAuthChecked, selectUser, selectAuthChecked } from "../state/userSlice";

import VolunteerDetailsModal from '../components/modals/VolunteerDetailsModal'

import DataGridCustomToolbar from "../components/DataGridCustomToolbar";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import Header from "../components/Header";

import destinationImg from "../assets/map_image.jpg";

import RoomIcon from "@mui/icons-material/Room";

import AlarmIcon from "@mui/icons-material/Alarm";

import EmailIcon from "@mui/icons-material/Email";

import EditIcon from "@mui/icons-material/Edit";

import HandshakeIcon from "@mui/icons-material/Handshake";


import { fetchVolunteers } from "../api/Ngo";

const EventDetailsVolunteer = () => {
    const user = useSelector(selectUser);
    console.log("<>user in Admin Actions?>>>>>>>>>>>>>>>>>>>>>>>>>",user?.uid);
  const theme = useTheme();
  const { id, option } = useParams();
  const [activeTab, setActiveTab] = useState(0);
//   const [volunteers, setVolunteers] = useState([]);

  useEffect(() => {
    // Parse the option from the URL params and set the active tab accordingly
    switch (option) {
      case "pending":
        setActiveTab(0);
        break;
      case "accepted":
        setActiveTab(1);
        break;
      case "rejected":
        setActiveTab(2);
        break;
      default:
        setActiveTab(0); // Default to 'pending' if option is not recognized
        break;
    }

    // Fetch volunteers data based on the option (you need to implement this)
    // Example fetchVolunteers function:
    // const fetchVolunteers = async () => {
    //   const response = await fetch(`/api/volunteers?option=${option}`);
    //   const data = await response.json();
    //   setVolunteers(data);
    // };
    // fetchVolunteers();
  }, [option]);

  // Define columns for the data grid
  const columns = [
    { field: "name", headerName: "Name", flex: 1 },
    { field: "email", headerName: "Email", flex: 1 },
    { field: "status", headerName: "Status", flex: 1,
    // renderCell: (params) => {
    //   switch (params.status) {
    //     case 'pending':
    //         <h1>hi</h1>
    //       break;
    //     case 'accepted':
    //         <h1>hi2</h1>
    //     break;
    //     case 'accepted':
    //       <h1>hi3</h1>
    //   break;
    //     default:
    //       break;
    //   }
    // }


    renderCell: (params) => {
      switch (params.value) {
        case 'pending':
          return <HourglassTopIcon sx={{color: '#EDD000'}}/>
        case 'accepted':
          return <VerifiedUserIcon sx={{color: '#5bff86'}}/>
        case 'rejected':
          return <CancelIcon sx={{color: 'red'}}/>
        default:
          return null;
      }
    }
  },
    { field: "actions", headerName: "More details", flex: 1,
    renderCell: (params) => {
      return (
        <VolunteerDetailsModal/>
      )
    }
  },
    // Add more columns as needed
  ];


  const {
    isLoading,
    isError,
    data: volunteers,
    error,
  } = useQuery({
    queryKey: ["volunteers"],
    queryFn: fetchVolunteers 
  });


  console.log(volunteers);

  return (
    <Box m="1.5rem 2.5rem">
      <Header title="VOLUNTEER DETAILS" subtitle="event details " />
      <Container maxWidth="lg">

        <Box
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
          <Tabs
            value={activeTab}
            onChange={(event, newValue) => setActiveTab(newValue)}
          >
            <Tab label="Pending" />
            <Tab label="Accepted" />
            <Tab label="Rejected" />
          </Tabs>
          {activeTab === 0 && <DataGrid loading={isLoading} getRowId={(row) => row.volunteer_id} rows={volunteers?.filter((volunteer) => volunteer.status === 'pending')   || []} columns={columns} components={{ Toolbar: DataGridCustomToolbar }}/>}

          {activeTab === 1 && <DataGrid loading={isLoading} getRowId={(row) => row.volunteer_id} rows={volunteers?.filter((volunteer) => volunteer.status === 'accepted')   || []} columns={columns} components={{ Toolbar: DataGridCustomToolbar }}/>}


          {activeTab === 2 && <DataGrid loading={isLoading} getRowId={(row) => row.volunteer_id} rows={volunteers?.filter((volunteer) => volunteer.status === 'rejected')   || []} columns={columns} components={{ Toolbar: DataGridCustomToolbar }}/>}
        

          
        </Box>
        

      </Container>

    </Box>
  );
};

export default EventDetailsVolunteer;
