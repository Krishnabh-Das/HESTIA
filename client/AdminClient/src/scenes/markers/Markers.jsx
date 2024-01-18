import { useEffect, useState } from "react";
import { db, auth, storage } from "../../config/firebase";
import CircularProgress from '@mui/material/CircularProgress';
import FlexBetween from "components/FlexBetween";
import Header from "components/Header";
import {
    DownloadOutlined,
  } from "@mui/icons-material";
import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";
import axios from 'axios';
import { useNavigate } from 'react-router-dom'; // Import useNavigate hook

import {
    Box,
    Button,
    useTheme,
    Container
  } from "@mui/material";
  import { DataGrid } from "@mui/x-data-grid";
function Markers() {
    const theme = useTheme();
    
    const navigate = useNavigate();

    //markers state

const [markerList, setMarkerList] = useState([]);
const markersRef = collection(db, "Markers");

const getMarkers = async () => {
  try {
    const data = await getDocs(markersRef);

    const filteredData = data.docs.map((doc) => ({
        marker_id: doc.id,
      ...doc.data(),
    }));

    const markerStats = filteredData.length;

    console.log("markerStats------------------->", markerStats);

    console.log("filtered data in Markers>>>>>>>>", filteredData);
    console.log("markerList in Markers>>>>>>>>", markerList);

    const coordinates = await Promise.all(
      filteredData.map(async (marker) => {
        const lat = marker.lat;
        const lon = marker.long;
        const postData = {
          lat: lat.toString(),
          lon: lon.toString(),
        };

        try {
          let response = await axios.post(
            `${process.env.REACT_APP_API_BASE_URL}/location/get`,
            postData,
            {
              headers: {
                'Content-Type': "application/json",
              },
            }
          );
          console.log("response in marker>>>>>>>>>>", response.data.address);

          const address = response.data.address;
          return { ...marker, address };
        } catch (err) {
          console.log(
            "error in getting the address from coordinates: ",
            err.message
          );
        }
      })
    );

    console.log('Coordinates for all markers:', coordinates);
    setMarkerList(coordinates);


  } catch (err) {
    console.error(err);
  }
};


useEffect(() => {
    getMarkers();
  }, []);



  console.log("markerList in outside", markerList);



   //MUI datagrid setup
  const [selectedRow, setSelectedRow] = useState(null);


// Handler function for row selection
const handleRowSelection = (selection) => {
    // Assuming you want to navigate when a single row is selected
    if (selection.length === 1) {
      const selectedRowIndex = selection[0];
      console.log("selectedRowIndex>>>>>>>>>>>>>>>>>>>>",selectedRowIndex );
      const selectedRowData = markerList[selectedRowIndex];
      console.log("Selected Row Data:", selectedRowData);
      // Navigate to a new page (you need to replace '/detail' with your actual detail page route)
      navigate(`/markers/${selectedRowIndex}`);
    }
  };
  

  const columns = [
    {
      field: "id",
      headerName: "ID",
      flex: 1,
    },
    {
      field: "formattedTime",
      headerName: "Time",
      flex: 1,
    },
    {
      field: "description",
      headerName: "Description",
      flex: 1,
    },
    {
      field: "userid",
      headerName: "userId",
      flex: 1,
    },
  ];





  return (
    <>
    {markerList.length===0 ?     <CircularProgress/>: (
//start
        <Box m="1.5rem 2.5rem"
    >
          <FlexBetween>
        <Header title="MARKERS" subtitle="all the markers created by the users" />

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
            getRowId={(row) =>row.marker_id}
            rows={(markerList && markerList) || []}
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











    ) }

    </>
  )
}

export default Markers