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

import DataGridCustomToolbar from "../components/DataGridCustomToolbar";

import Header from "../components/Header";

import destinationImg from "../assets/map_image.jpg";

import RoomIcon from "@mui/icons-material/Room";

import AlarmIcon from "@mui/icons-material/Alarm";

import EmailIcon from "@mui/icons-material/Email";

import EditIcon from "@mui/icons-material/Edit";

import HandshakeIcon from "@mui/icons-material/Handshake";

const EventDetailsVolunteer = () => {

  const theme = useTheme();
  const { id, option } = useParams();
  const [activeTab, setActiveTab] = useState(0);
  const [volunteers, setVolunteers] = useState([]);

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
    { field: "status", headerName: "Status", flex: 1 },
    { field: "actions", headerName: "More details", flex: 1 },
    // Add more columns as needed
  ];

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
          {activeTab === 0 && <DataGrid rows={volunteers} columns={columns} components={{ Toolbar: DataGridCustomToolbar }}/>}
          {activeTab === 1 && <DataGrid rows={volunteers} columns={columns} components={{ Toolbar: DataGridCustomToolbar }}/>}
          {activeTab === 2 && <DataGrid rows={volunteers} columns={columns} components={{ Toolbar: DataGridCustomToolbar }}/>}
        </Box>
        

      </Container>

    </Box>
  );
};

export default EventDetailsVolunteer;
