import { useEffect, useState } from "react";
import { db, auth, storage } from "../../config/firebase";
import CircularProgress from "@mui/material/CircularProgress";
import FlexBetween from "../../components/FlexBetween";
import Header from "../../components/Header";
import { DownloadOutlined, Delete, Edit, Preview } from "@mui/icons-material";
import {
  getDoc,
  getDocs,
  collection,
  addDoc,
  deleteDoc,
  updateDoc,
  doc,
  setDoc,
} from "firebase/firestore";
import axios from "axios";
import { useNavigate } from "react-router-dom"; // Import useNavigate hook

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

import {
  Box,
  Button,
  useTheme,
  Container,
  Card,
  CardContent,
  CardMedia,
  Typography,
  IconButton,
  Tooltip,
  Avatar,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";

//------------------------leaflet config------------------------
import "../../leaflet_myconfig.css";
import "leaflet/dist/leaflet.css";
import {
  MapContainer,
  TileLayer,
  Marker,
  Popup,
  Polygon,
  Polyline,
  useMap,
} from "react-leaflet";
import MarkerClusterGroup from "react-leaflet-cluster";
import { useMapEvents } from "react-leaflet/hooks";

import pinIcon1 from "../../assets/placeholder.png";
import pinIcon2 from "../../assets/pin.png";
import pinIcon3 from "../../assets/destination.png";

import { Icon, divIcon, point } from "leaflet";

import DataGridCustomToolbar from "../../components/DataGridCustomToolbar";
import { getFinderDetails } from "../../api/Ngo";
import CustomMarker from "../../components/CustomMarker";

function Markers() {
  const purpleOptions = { color: "purple" };

  const queryClient = useQueryClient();

  const {
    isLoading,
    isError,
    data: finderMarkers,
    error,
  } = useQuery({
    queryKey: ["finder"],
    queryFn: getFinderDetails,
  });

  console.log("finder markers>>>>", finderMarkers);

  // const map = useMap();
  const theme = useTheme();

  const navigate = useNavigate();

  //markers state

  const [markerList, setMarkerList] = useState([]);

  const [markerData, setMarkerData] = useState(null);

  const [markerIndex, setMarkerIndex] = useState(null);
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

      setMarkerList(filteredData);
    } catch (err) {
      console.error(err);
    }
  };

  console.log("markerList in outside", markerList);

  const markerDisplay = async () => {
    try {
      console.log("hi 1");
      console.log("markerIndex hi 1", markerIndex);
      console.log("hi2");
      const markerDocRef = doc(db, "Markers", markerIndex);
      console.log("hi3");
      console.log("markerDocRef", markerDocRef);
      const markerDocSnapshot = await getDoc(markerDocRef);

      console.log("hi 4");

      if (markerDocSnapshot.exists()) {
        console.log(
          "complete marker object obtained when set by markerIndex>>>>>>",
          markerDocSnapshot.data()
        );

        setMarkerData(markerDocSnapshot.data());
      } else {
        console.log("marker doesn't exist");
      }
    } catch (error) {}
  };

  //MUI datagrid setup
  // const [selectedRow, setSelectedRow] = useState(null);

  // Handler function for row selection
  const handleRowSelection = (selection) => {
    // Assuming you want to navigate when a single row is selected
    if (selection.length === 1) {
      const selectedRowIndex = selection[0];
      console.log("selectedRowIndex>>>>>>>>>>>>>>>>>>>>", selectedRowIndex);

      // Set the marker index
      setMarkerIndex(selectedRowIndex);
    }
  };

  console.log(
    "markerIndex after setting the selectedRowIndex>>>>>>>>>>>>>>>>>",
    markerIndex
  );

  // useEffect(() => {
  //   getMarkers();
  // }, []);

  useEffect(() => {
    if (finderMarkers) {
      setMarkerList(finderMarkers);
    }
  }, [finderMarkers]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        if (markerIndex !== null) {
          await markerDisplay();
        } else {
          console.log("marker Display not runned");
        }
      } catch (error) {
        console.error("Error in markerDisplay:", error);
      }
    };

    fetchData();
  }, [markerIndex]);

  const columns = [
    {
      field: "imageUrl",
      headerName: "Photo",
      width: 70,
      renderCell: (params) => (
        <Avatar src={params.row.imageUrl} variant="rounded" />
      ),
      sortable: false,
      filterable: false,
      // hide: true,
    },
    {
      field: "id",
      headerName: "id",
      flex: 1,
      hide: true,
    },
    {
      field: "userid",
      headerName: "userId",
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
      field: "address",
      headerName: "Address",
      flex: 1,
    },
  ];

  const pin1 = new Icon({
    iconUrl: pinIcon1,
    iconSize: [38, 38], // size of the icon
  });

  const pin2 = new Icon({
    iconUrl: pinIcon2,
    iconSize: [38, 38], // size of the icon
  });

  const pin3 = new Icon({
    iconUrl: pinIcon3,
    iconSize: [38, 38], // size of the icon
  });
  // custom cluster icon
  const createClusterCustomIcon = function (cluster) {
    return new divIcon({
      html: `<span class="cluster-icon">${cluster.getChildCount()}</span>`,
      className: "custom-marker-cluster",
      iconSize: point(33, 33, true),
    });
  };

  // const map = useMap();

  const coordinates = finderMarkers?.map((marker) => [marker.lat, marker.long]);

  console.log("coordinates for the finderMarkers", coordinates);

  return (
    <>
      <Box m="1.5rem 2.5rem">
        <FlexBetween>
          <Header
            title="FINDER"
            subtitle="track a lost person by uploading an image"
          />

          {/* <Box>
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
        </Box> */}
        </FlexBetween>

        <Container
          maxWidth="xl"
          sx={{
            //   "&  .MuiContainer-maxWidthXl css-19r6kue-MuiContainer-root": {
            //     margin: '0',
            //     padding: '0'
            // },
            "& .MuiContainer-root": {
              margin: "0",
              padding: "0",
            },
            "& .MuiContainer-root": {
              margin: "0",
              padding: "0",
            },
          }}
        >
          <Box
            display="flex"
            flexWrap="wrap"
            alignItems="center"
            justifyContent="center"
            gap={3}
            // height='30vh'
          >
            {markerList.length === 0 ? (
              <CircularProgress />
            ) : (
              <>
                <Box
                  sx={{
                    height: 642,
                    width: 800,
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
                    getRowId={(row) => row.id}
                    rows={(markerList && markerList) || []}
                    columns={columns}
                    sortModel={[
                      {
                        field: "formattedTime",
                        sort: "desc", // Sort formattedTime field in descending order
                      },
                    ]}
                    // checkboxSelection
                    onSelectionModelChange={(e) => {
                      console.log(
                        "wtf is selection in datagrid?>>>>>>>>>>>>>>>>>",
                        e
                      );
                      // setSelectedRow(e);
                      handleRowSelection(e);
                    }}
                    components={{ Toolbar: DataGridCustomToolbar }}
                  />
                </Box>

                <Box>
                  <Card
                    sx={{
                      backgroundImage: "none",
                      backgroundColor: theme.palette.background.alt,
                      borderRadius: "0.55rem",
                      marginTop: "30px", // Adjust margin top as needed
                      minWidth: "600px", // Adjust the width as needed
                      width: "400px",
                      // height: '650px',
                      padding: "0px", // Ensures the Card takes full width if maxWidth is not reached
                      // margin: '0 auto', // Center the Card horizontally
                    }}
                  >
                    <CardContent>
                      <Box mb={4}>
                        <MapContainer center={[22.1846, 78.4009]} zoom={4}>
                          <TileLayer
                            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                          />
                          <MarkerClusterGroup
                            chunkedLoading
                            iconCreateFunction={createClusterCustomIcon}
                          >
                            {markerList.map((marker, index) => (
                              // <Marker
                              //   position={[marker?.lat, marker?.long]}
                              //   icon={pin3}
                              // >
                              //   {/* <Popup>{marker?.description}</Popup> */}
                              //   <Popup>
                              //     <MarkerPopup
                              //       description={marker?.description}
                              //       imageUrl={marker?.imageUrl}
                              //       address={marker?.address}
                              //       formattedTime={marker?.formattedTime}
                              //     />
                              //   </Popup>
                              // </Marker>

                              <CustomMarker
                                description={marker?.description}
                                imageUrl={marker?.imageUrl}
                                address={marker?.address}
                                formattedTime={marker?.formattedTime}
                                position={[marker?.lat, marker?.long]}
                                order={index + 1}
                              />
                            ))}

                            {coordinates && (
                              <Polyline
                                pathOptions={purpleOptions}
                                positions={coordinates}
                              />
                            )}

                            {markerData && (
                              <FlyToMarker
                                position={[markerData?.lat, markerData?.long]}
                                zoom={17}
                              />
                            )}
                          </MarkerClusterGroup>
                        </MapContainer>
                      </Box>
                    </CardContent>
                  </Card>
                </Box>
              </>
            )}
          </Box>
        </Container>
      </Box>
    </>
  );
}

export default Markers;

const MarkerPopup = ({ imageUrl, description, formattedTime, address }) => {
  const theme = useTheme();

  return (
    // <div style={{ height: '200px', maxWidth: '200px' }}>
    <Box
      sx={{
        backgroundColor: theme.palette.background.alt,
        "& .MuiTypography-root": {
          margin: 0, // Remove default margin for Typography components
        },
        "& .MuiBox-root": {
          margin: 0, // Remove default margin for Typography components
        },
        width: "300px",
        height: "200px",
      }}
    >
      <Box
        sx={{
          display: "flex",
          // flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <img
          src={imageUrl}
          alt=""
          srcSet=""
          style={{ width: "100%", height: "100px", maxWidth: "100px" }}
        />
      </Box>

      <Box mt={2} display="flex">
        <Box>
          <Typography
            variant="body1"
            mr={1}
            sx={{ color: theme.palette.secondary[500] }}
          >
            Description:
          </Typography>
        </Box>
        <Box>
          <Typography
            variant="body1"
            sx={{ color: theme.palette.secondary[100] }}
          >
            {description}
          </Typography>
        </Box>
      </Box>

      <Box mt={2} display="flex">
        <Box>
          <Typography
            variant="body1"
            mr={2}
            sx={{ color: theme.palette.secondary[500] }}
          >
            Time:
          </Typography>
        </Box>
        <Box>
          <Typography
            variant="body1"
            sx={{ color: theme.palette.secondary[100] }}
          >
            {formattedTime}
          </Typography>
        </Box>
      </Box>

      <Box mt={2} display="flex">
        <Box>
          <Typography
            variant="body1"
            mr={1}
            sx={{ color: theme.palette.secondary[500] }}
          >
            Address:
          </Typography>
        </Box>
        <Box>
          <Typography
            variant="body1"
            sx={{ color: theme.palette.secondary[100] }}
          >
            {address}
          </Typography>
        </Box>
      </Box>
    </Box>
  );
};

const FlyToMarker = ({ position, zoom }) => {
  const map = useMap();

  map.flyTo(position, zoom, { duration: 2 });

  return null;
};
