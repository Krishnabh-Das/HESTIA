import { useEffect, useState } from "react";

import FlexBetween from "../../components/FlexBetween";
import Header from "../../components/Header";
import axios from 'axios';

import {
  DownloadOutlined,
} from "@mui/icons-material";

import {
  Box,
  Button,
  useTheme,
  Container
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import BreakdownChart from "../../components/BreakdownChart";
// import OverviewChart from "../../components/OverviewChart";
import StatBox from "../../components/StatBox";

// import { db, auth, storage } from "../../config/firebase";
import {db} from "../../config/firebase";

import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";

import { useNavigate } from 'react-router-dom'; // Import useNavigate hook

const SosReports = () => {

  const theme = useTheme();
  const navigate = useNavigate();
  const [selectedRow, setSelectedRow] = useState(null);


  //Sos report state
  const [sosList, setSosList] = useState([])

  const [sosLen, setSosLen] = useState(0);


  const SosReportsRef = collection(db, "SOS_Reports")
  
  
    const getSosReportsList = async () => { 
      try {
        const data = await getDocs(SosReportsRef);
  
        const filteredData = data.docs.map((doc) => ({
          ...doc.data(),
          id: doc.id,
        }));
  
  
      const sosStats = filteredData.length;

        setSosList(filteredData);
  
      return {sosStats, filteredData};
  
  
      } catch (err) {
        console.error(err);
      }
    }
  
    const sosStats = sosList.length;
  



    useEffect(() => {
        const fetchData = async () => { 
          const {sosStats, filteredData}= await getSosReportsList();
          setSosLen(sosStats)
          setSosList(filteredData)
    
          console.log("sosLen in useEffect", sosLen);
          console.log("sosList in useEffect", sosList);
        };
      
        fetchData();
      }, []);

      console.log("SOS reports>>>>>>>>>>>>>>>>>>.", sosList);


  //MUI datagrid setup

// Handler function for row selection
const handleRowSelection = (selection) => {
    // Assuming you want to navigate when a single row is selected
    if (selection.length === 1) {
      const selectedRowIndex = selection[0];
      console.log("selectedRowIndex>>>>>>>>>>>>>>>>>>>>",selectedRowIndex );
      const selectedRowData = sosList[selectedRowIndex];
      console.log("Selected Row Data:", selectedRowData);
      // Navigate to a new page (you need to replace '/detail' with your actual detail page route)
      navigate(`/details/${selectedRowIndex}`);
    }
  };
  

  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "incidentTime",
      headerName: "CreatedAt",
      flex: 1,
      renderCell: (params) => {
        const timestamp = params.value?.seconds || 0;
        const date = new Date(timestamp * 1000); // Convert seconds to milliseconds
      
        const days = date.getUTCDate() - 1; // Subtract 1 to get the correct day
        const hours = date.getUTCHours();
        const minutes = date.getUTCMinutes();
      
        return `${days} days ${hours} hours ${minutes} minutes`;
      },
    },
    {
      field: "incidentAddress",
      headerName: "Address",
      flex: 1,
    },
    {
      field: "incidentCategory",
      headerName: "Category",
      flex: 1,
    },
  ];

  return (

    <Box m="1.5rem 2.5rem"
    >
          <FlexBetween>
        <Header title="SOSREPORTS" subtitle="see all the emergency sos here (click for more info)" />

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
            rows={(sosList && sosList) || []}
            columns={columns}
            // checkboxSelection
            onSelectionModelChange={(selection) => {
            setSelectedRow(selection);
            handleRowSelection(selection);
          }}
          />
        </Box>
        
            </Box>
      </Container>


    </Box>

  )


}


export default SosReports;