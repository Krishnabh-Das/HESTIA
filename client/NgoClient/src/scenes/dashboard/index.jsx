import { useEffect, useState } from "react";

import FlexBetween from "../../components/FlexBetween";
import Header from "../../components/Header";
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
  useMediaQuery,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import BreakdownChart from "../../components/BreakdownChart";
// import OverviewChart from "../../components/OverviewChart";
import StatBox from "../../components/StatBox";

// import { db, auth, storage } from "../../config/firebase";
import { db, auth, storage } from "../../config/firebase";

import {
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
} from "firebase/firestore";

import { ref, uploadBytes } from "firebase/storage";

import { useNavigate } from 'react-router-dom'; // Import useNavigate hook



// http://192.168.1.26:8000/location/get

const Dashboard = () => {

  const theme = useTheme();
  const isNonMediumScreens = useMediaQuery("(min-width: 1200px)");
  
  
  
  
  
  
  
  const navigate = useNavigate(); // Initialize useNavigate
  

  const [selectedRow, setSelectedRow] = useState(null);



  //firebase hookup

  //Sos report state
const [sosList, setSosList] = useState([])

const [sosLen, setSosLen] = useState(0); // initialize with a default value


const SosReportsRef = collection(db, "SOS_Reports")


  const getSosReportsList = async () => { 
    try {
      const data = await getDocs(SosReportsRef);

      const filteredData = data.docs.map((doc) => ({
        ...doc.data(),
        id: doc.id,
      }));


    const sosStats = filteredData.length;

    console.log("sosStats------------------->", sosStats);



      console.log("data in getSos>>>>>>>>", data);
      setSosList(filteredData);
      console.log("filtereddata in getSos>>>>>>>>", filteredData);

      //this is showing empty as the filteddata has to be prosseced before
      console.log("sosList in getSos>>>>>>>>", sosList);

    console.log("||||||||||||||||||||||||||||");

    return {sosStats, filteredData};


    } catch (err) {
      console.error(err);
    }
  }

  const sosStats = sosList.length;

  console.log("sosStats ------------------>", sosStats);




  //markers state

  const [markerLen, setMarkerLen] = useState(0); // initialize with a default value


  const [markerList, setMarkerList] = useState([]);
  const markersRef = collection(db, "Markers");


  const getMarkerStats = async () => {
    try {
      const data = await getDocs(markersRef);

      const filteredData = data.docs.map((doc) => ({
        ...doc.data(),
      }));
  
      const markerStats = filteredData.length;
  
      console.log("markerStats------------------->", markerStats);

      return markerStats;

    } catch (err) {
      console.error(err);
    }
  };
  



   //region state

   const [regionList, setRegionList] = useState([])

   const [regionLen, setRegionLen] = useState(0); // initialize with a default value

   const regionRef = collection(db, "RegionMap")

   const getRegionStats = async ()=>{
    try{
      const data = await getDocs(regionRef);

      const filteredData = data.docs.map((doc) => ({
        ...doc.data(),
      }));
      // setRegionList(filteredData);

      // console.log("filtered data in Region>>>>>>>>", filteredData);

      const regionStats = filteredData.length;

      console.log("regionStats------------------->", regionStats);

      return regionStats;
    }catch(err){
      console.error(err)
    }
   }


  useEffect(() => {
    const fetchData = async () => {
      const regionStats = await getRegionStats();
      console.log("regionStats in useEffect", regionStats);
      setRegionLen(regionStats)

      const markerStats = await getMarkerStats();
      console.log("markerStats in useEffect", markerStats);
      setMarkerLen(markerStats)

      const {sosStats, filteredData}= await getSosReportsList();


      // sosLen = sosList.length;
      
      setSosLen(sosStats)

      setSosList(filteredData)

      console.log("sosLen in useEffect", sosLen);
      console.log("sosList in useEffect", sosList);

      // setMarkerLen(markerStats)
      // Now you can set the state or perform any other logic with regionStats
    };
  
    fetchData();
  }, []);


  console.log("sosLen in outside", sosLen);
  console.log("sosList in outside", sosList);




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
    <Box m="1.5rem 2.5rem">
      <FlexBetween>
        <Header title="DASHBOARD" subtitle="Welcome to your dashboard" />

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

      <Box
        mt="20px"
        display="grid"
        gridTemplateColumns="repeat(12, 1fr)"
        gridAutoRows="160px"
        gap="20px"
        sx={{
          "& > div": { gridColumn: isNonMediumScreens ? undefined : "span 12" },
        }}
      >

          <StatBox
          title="Total Region Maps"
          value={regionLen}
          // value={data && data.totalCustomers}
          increase="+14%"
          description="Since last month"
          icon={
            <Room
              sx={{ color: theme.palette.secondary[300], fontSize: "26px" }}
            />
          }
        />


        
        {/* 2nd box */}
        {/* <Box
          gridColumn="span 4"
          gridRow="span 3"        
        > */}





        {/* 3rd box */}




{/* 
        </Box> */}

        <StatBox
          title="Total Markers"
          value={markerLen}
          increase="+21%"
          description="Since last month"
          icon={
            <PushPinIcon
              sx={{ color: theme.palette.secondary[300], fontSize: "26px" }}
            />
          }
        />
        {/* <Box
          gridColumn="span 8"
          gridRow="span 3"
          backgroundColor={theme.palette.background.alt}
          p="1rem"
          borderRadius="0.55rem"
        >
          <OverviewChart view="sales" isDashboard={true} />
        </Box> */}
        <StatBox
          title="Total SOS reports"
          value={sosLen}
          increase="+5%"
          description="Since last month"
          icon={
            <SosIcon
              sx={{ color: theme.palette.secondary[300], fontSize: "26px" }}
            />
          }
        />
        {/* <StatBox
          title="Yearly Sales"
          value={data && data.yearlySalesTotal}
          increase="+43%"
          description="Since last month"
          icon={
            <Traffic
              sx={{ color: theme.palette.secondary[300], fontSize: "26px" }}
            />
          }
        /> */}

        {/* {sosList ? (<h1>hi</h1>) : (<h1>hello</h1> )} */}

        {/* ROW 2 */}
        <Box
          gridColumn="span 8"
          gridRow="span 3"
          sx={{
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
            loading={!sosList}
            getRowId={(row) => row.id || row._id}
            rows={(sosList && sosList) || []}
            columns={columns}
            // checkboxSelection
            onSelectionModelChange={(selection) => {
            setSelectedRow(selection);
            handleRowSelection(selection);
          }}
          />
{/* 
<DataGrid
            loading={isLoading || !data}
            getRowId={(row) => row.id}
            rows={(data && data.transactions) || []}
            columns={columns}
          /> */}
        </Box>
        <Box
          gridColumn="span 4"
          gridRow="span 3"
          backgroundColor={theme.palette.background.alt}
          p="1.5rem"
          borderRadius="0.55rem"
        >
          <Typography variant="h6" sx={{ color: theme.palette.secondary[100] }}>
            Crime By Category (to be implemented)
          </Typography>
          <BreakdownChart isDashboard={true} />
          {/* <Typography
            p="0 0.6rem"
            fontSize="0.8rem"
            sx={{ color: theme.palette.secondary[200] }}
          >
           to be implemented
          </Typography> */}
        </Box>
      </Box>
    </Box>
  );
};

export default Dashboard;
