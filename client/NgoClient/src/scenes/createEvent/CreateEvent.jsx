import React, { useState } from "react";

import {
  Button,
  TextField,
  Grid,
  Typography,
  Container,
  MenuItem,
  InputLabel,
  Box,
  FormControl,
  Select,
} from "@mui/material";
import {
  MapContainer,
  TileLayer,
  Marker,
  Popup,
  useMapEvents,
} from "react-leaflet";
import { db, storage } from "../../config/firebase";
import {
  // getFirestore,
  collection,
  doc,
  addDoc,
  GeoPoint,
  setDoc,
  // getDoc,
  // getDocs,
  // updateDoc,
  // deleteDoc,
} from "firebase/firestore";
import { getDownloadURL, ref, uploadBytes } from "firebase/storage";

import {
  Unstable_NumberInput as BaseNumberInput,
  numberInputClasses,
} from "@mui/base/Unstable_NumberInput";

// // import Input from '@mui/joy/Input';

// import {Input} from '@mui/material'

// import { DatePicker } from '@mui/x-date-pickers/DatePicker';

import { DemoContainer } from "@mui/x-date-pickers/internals/demo";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { TimePicker } from "@mui/x-date-pickers/TimePicker";

import dayjs from "dayjs";

import localizedFormat from "dayjs/plugin/localizedFormat";

import { DatePicker } from "@mui/x-date-pickers/DatePicker";
import FlexBetween from "../../components/FlexBetween";

import { TextareaAutosize as BaseTextareaAutosize } from "@mui/base/TextareaAutosize";

import Textarea from "@mui/joy/Textarea";

// import Textarea from '@mui/base/TextareaAutosize'

import { styled } from "@mui/system";

import { useTheme } from "@mui/material";

import { useDispatch, useSelector } from "react-redux";

import {
  setUser,
  setAuthChecked,
  selectUser,
  selectAuthChecked,
} from "../../state/userSlice";

const CreateEvent = () => {
  const theme = useTheme();
  const user = useSelector(selectUser);

  console.log(user);



  const Textarea = styled(BaseTextareaAutosize)(
    `
        box-sizing: border-box;
        width: 320px;
        font-family: 'IBM Plex Sans', sans-serif;
        font-size: 0.875rem;
        font-weight: 400;
        line-height: 1.5;
        padding: 8px 12px;
        border-radius: 8px;
        color: ${theme.palette.neutral[100]};
        background: ${theme.palette.primary[500]};
        border: 1px solid ${theme.palette.background[500]};
        box-shadow: 0px 2px 2px ${theme.palette.primary[500]};
    
        &:hover {
          border-color: ${theme.palette.background[500]};
        }
    
        &:focus {
          border-color: ${theme.palette.primary[500]};
          box-shadow: 0 0 0 3px ${theme.palette.primary[500]};
        }
    
        // firefox
        &:focus-visible {
          outline: 0;
        }
      `
  );

  dayjs.extend(localizedFormat);

  const [fromDate, setFromDate] = useState(dayjs().format());

  const [toDate, setToDate] = useState(dayjs().format());

  const [time, setTime] = React.useState(dayjs().format());

  const [rawTime, setRawTime] = useState(dayjs().format())

  const [rawFromDate, setRawFromDate] = useState(dayjs().format())

  const [rawToDate, setRawToDate] = useState(dayjs().format())


  console.log('time',time);
  console.log('rawTime',rawTime);

  console.log('fromDate',fromDate);
  console.log('rawFromDate',rawFromDate);

  console.log('toDate',toDate);
  console.log('rawToDate',rawToDate);

  const [eventName, setEventName] = useState("");
  const [poster, setPoster] = useState(null);
  // const [time, setTime] = useState('');
  const [position, setPosition] = useState(null);

  const [eventDescription, setEventDescription] = useState("");

  const [eventContact, setEventContact] = useState(user.email);

  const [volunteerCount, setVolunteerCount] = useState(0);

  const [type, setType] = useState("");

  const handleChange = (event) => {
    setType(event.target.value);
  };

  const handleSubmit = async (e) => {

    try {
      e.preventDefault();

      const eventID = dayjs().valueOf();
      console.log("dayjs", eventID);

      const posterExt = poster.name.split(".").slice(-1)[0];
  
      const storageRef = ref(
        storage,
        `Event/${eventID}/Poster/Poster.${posterExt}`
      );
      await uploadBytes(storageRef, poster).then((snapshot) => {
        console.log("Uploaded a blob or file!");
      });
      const posterUrl = await getDownloadURL(storageRef);
      // Here you can submit the form data to your backend or handle it as needed
      const locPoint = new GeoPoint(position.lat, position.lng);
      const data = {
        eventName: eventName,
        poster: posterUrl,
        time: dayjs(time).format("LT"),
        rawTime: dayjs(time).format(),
        location: locPoint,
        fromDate: dayjs(fromDate).format("L"),
        rawFromDate: dayjs(fromDate).format(),
        toDate: dayjs(toDate).format("L"),
        rawToDate: dayjs(toDate).format(),
        eventDescription,
        eventContact,
        volunteerCount,
        ngoId: user.uid,
        type: type,
      };
  
      // const eventDocRef = doc(collection(db, "Events"), eventID);
  
      // await setDoc(eventDocRef,collection(db, "Events"), data);
  
      const eventDocRef = doc(collection(db, "Events"), eventID.toString());
  
      await setDoc(eventDocRef, data);
  
      console.log({ eventName, posterUrl, time, position });
    } catch (err) {
      console.log('error in handle submit', err);
    }

  };

  const handlePosterChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const fileType = file.type;
      if (
        fileType === "image/jpeg" ||
        fileType === "image/png" ||
        fileType === "image/jpg"
      ) {
        setPoster(file);
      } else {
        // Display an error message or handle the invalid file type as needed
        console.error("Invalid file type. Please upload a JPEG or PNG image.");
      }
    }
  };

  const handleMapClick = (e) => {
    setPosition(e.latlng);
  };

  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <Container component="main" maxWidth="md">
        <Typography variant="h4" align="center" gutterBottom>
          Submit Event
        </Typography>
        <form onSubmit={handleSubmit}>
          <Grid container spacing={2}>
            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Event Name"
                variant="outlined"
                value={eventName}
                onChange={(e) => setEventName(e.target.value)}
              />
            </Grid>
            <Grid item xs={12}>
              <input
                accept="image/*"
                id="poster"
                type="file"
                style={{ display: "none" }}
                onChange={handlePosterChange}
              />
              <label htmlFor="poster">
                <Button
                  variant="outlined"
                  component="span"
                  fullWidth
                  style={{ color: "white", backgroundColor: "green" }}
                >
                  Upload Poster
                </Button>
              </label>
              {poster && (
                <div>
                  <Typography variant="body1" gutterBottom>
                    Poster uploaded: {poster.name}
                    {/* Extension: {poster.name.split('.').slice(-1)[0]} */}
                  </Typography>
                  <img
                    src={URL.createObjectURL(poster)}
                    alt="Uploaded Poster"
                    style={{ maxWidth: "100%", maxHeight: "200px" }}
                  />
                  <Button
                    variant="contained"
                    fullWidth
                    onClick={() => setPoster(null)}
                  >
                    Clear Poster
                  </Button>
                </div>
              )}
            </Grid>
            <Grid item xs={12}>
              {/* <TextField
                            fullWidth
                            label="Time"
                            variant="outlined"
                            value={time}
                            onChange={(e) => setTime(e.target.value)}
                        /> */}
              <Box display="flex" flexDirection="column" gap={2}>
                <Box display="flex" justifyContent="space-between">
                  <TimePicker
                    label="Time"
                    value={dayjs(time)}
                    onChange={(newValue) => {
                      setTime(dayjs(newValue))
                      setRawTime(dayjs(newValue))
                    }
                    }
                  />

                  <TextField
                    // size='medium'
                    label="Contact"
                    variant="outlined"
                    value={eventContact}
                    onChange={(e) => setEventContact(e.target.value)}
                  />
                </Box>
                <Box display="flex" justifyContent="space-between">
                  <DatePicker
                    label="From"
                    value={dayjs(fromDate)}
                    onChange={(newValue) => {
                      setFromDate(dayjs(newValue))
                      setRawFromDate(dayjs(newValue))
                    
                    }}
                  />
                  <DatePicker
                    label="To"
                    value={dayjs(toDate)}
                    onChange={(newValue) =>{ 
                      setToDate(dayjs(newValue))
                      setRawToDate(dayjs(newValue))

                    }}
                  />
                </Box>
                <Box>
                  <TextField
                    fullWidth
                    size="medium"
                    label="Event Description"
                    variant="outlined"
                    value={eventDescription}
                    onChange={(e) => setEventDescription(e.target.value)}
                    multiline
                    rows={4}
                  />
                </Box>

                <Box
                  display="flex"
                  justifyContent="space-between"
                  alignItems="center"
                >
                  <Box sx={{ minWidth: 120 }}>
                    <FormControl fullWidth>
                      <InputLabel id="demo-simple-select-label">
                        Type
                      </InputLabel>
                      <Select
                        labelId="demo-simple-select-label"
                        id="demo-simple-select"
                        value={type}
                        label="Type"
                        onChange={handleChange}
                      >
                        <MenuItem value={"Awareness Campaign"}>
                          Awareness Campaign
                        </MenuItem>
                        <MenuItem value={"Fundraising"}>Fundraising</MenuItem>
                        <MenuItem value={"Volunteer Drive"}>
                          Volunteer Drive
                        </MenuItem>
                        <MenuItem value={"Training and Capacity Building"}>
                          Training and Capacity Building
                        </MenuItem>
                        <MenuItem value={"Cultural and Arts"}>
                          Cultural and Arts
                        </MenuItem>
                        <MenuItem value={"Health and Wellness"}>
                          Health and Wellness
                        </MenuItem>
                        <MenuItem value={"Environmental"}>
                          Environmental
                        </MenuItem>
                        <MenuItem value={"Humanitarian Relief"}>
                          Humanitarian Relief
                        </MenuItem>
                        <MenuItem value={"Celebratory"}>Celebratory</MenuItem>
                        <MenuItem value={"Networking and Collaboration"}>
                          Networking and Collaboration
                        </MenuItem>
                        <MenuItem value={"Education and Literacy"}>
                          Education and Literacy
                        </MenuItem>
                        <MenuItem
                          value={"Refugee and Migrant Support Services"}
                        >
                          Refugee and Migrant Support
                        </MenuItem>
                        <MenuItem value={"Empowerment Workshop"}>
                          Empowerment Workshop
                        </MenuItem>
                        <MenuItem
                          value={"HIV/AIDS Awareness and Testing Camps"}
                        >
                          HIV/AIDS Awareness and Testing Camps
                        </MenuItem>
                      </Select>
                    </FormControl>
                  </Box>

                  <TextField
                    label="volunteer count (optional)"
                    type="number"
                    variant="outlined"
                    value={volunteerCount}
                    onChange={(e) => setVolunteerCount(e.target.value)}
                  />
                </Box>

                {/* <Textarea
              value={eventDescription}
              onChange={(e) => setEventDescription(e.target.value)}
              /> */}
              </Box>
            </Grid>
            <Grid item xs={12}>
              <MapContainer
                center={[51.505, -0.09]}
                zoom={13}
                style={{ height: "400px" }}
              >
                <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
                {position && (
                  <Marker position={position}>
                    <Popup>You selected this location</Popup>
                  </Marker>
                )}
                <MapClickHandler setPosition={setPosition} />
              </MapContainer>
              {position && (
                <Grid container spacing={2}>
                  <Grid item xs={6}>
                    <TextField
                      fullWidth
                      label="Latitude"
                      variant="outlined"
                      value={position.lat.toFixed(6)}
                      disabled
                    />
                  </Grid>
                  <Grid item xs={6}>
                    <TextField
                      fullWidth
                      label="Longitude"
                      variant="outlined"
                      value={position.lng.toFixed(6)}
                      disabled
                    />
                  </Grid>
                </Grid>
              )}
            </Grid>
          </Grid>
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            style={{ marginTop: "1rem" }}
          >
            Create Event
          </Button>
        </form>
      </Container>
    </LocalizationProvider>
  );
};

const MapClickHandler = ({ setPosition }) => {
  useMapEvents({
    click(e) {
      setPosition(e.latlng);
    },
  });
  return null;
};

export default CreateEvent;
