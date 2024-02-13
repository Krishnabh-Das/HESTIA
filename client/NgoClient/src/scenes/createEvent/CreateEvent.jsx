import React, { useState } from 'react';
import { Button, TextField, Grid, Typography, Container } from '@mui/material';
import { MapContainer, TileLayer, Marker, Popup, useMapEvents } from 'react-leaflet';
import { db, storage } from '../../config/firebase';
import {
    // getFirestore,
    collection,
    // doc,
    addDoc,
    GeoPoint,
    // getDoc,
    // getDocs,
    // updateDoc,
    // deleteDoc,
  } from 'firebase/firestore';
import { getDownloadURL, ref, uploadBytes } from 'firebase/storage';

const CreateEvent = () => {
    const [eventName, setEventName] = useState('');
    const [poster, setPoster] = useState(null);
    const [time, setTime] = useState('');
    const [position, setPosition] = useState(null);

    const handleSubmit = async (e) => {
        e.preventDefault();

        const storageRef = ref(storage, `EventPosters/${poster.name}`);
        await uploadBytes(storageRef, poster).then((snapshot) => {
            console.log('Uploaded a blob or file!');
        });
        const posterUrl = await getDownloadURL(storageRef);
        // Here you can submit the form data to your backend or handle it as needed
        const locPoint = new GeoPoint(position.lat, position.lng)
        const data = {
            eventName: eventName,
            poster: posterUrl,
            time: time,
            location: locPoint
        }

        await addDoc(collection(db, 'Events'), data)
       
        console.log({ eventName, posterUrl, time, position });
    };

    const handlePosterChange = (e) => {
        const file = e.target.files[0];
        setPoster(file);
    };

    const handleMapClick = (e) => {
        setPosition(e.latlng);
    };

    return (
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
                            style={{ display: 'none' }}
                            onChange={handlePosterChange}
                        />
                        <label htmlFor="poster">
                            <Button
                                variant="outlined"
                                component="span"
                                fullWidth
                                style={{ color: 'white', backgroundColor: 'green' }}
                            >
                                Upload Poster
                            </Button>
                        </label>
                        {poster && (
                            <Typography variant="body1" gutterBottom>
                                Poster uploaded: {poster.name}
                            </Typography>
                        )}
                    </Grid>
                    <Grid item xs={12}>
                        <TextField
                            fullWidth
                            label="Time"
                            variant="outlined"
                            value={time}
                            onChange={(e) => setTime(e.target.value)}
                        />
                    </Grid>
                    <Grid item xs={12}>
                        <MapContainer center={[51.505, -0.09]} zoom={13} style={{ height: '400px' }}>
                            <TileLayer
                                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                            />
                            {position && <Marker position={position}>
                                <Popup>You selected this location</Popup>
                            </Marker>}
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
                <Button type="submit" fullWidth variant="contained" color="primary" style={{ marginTop: '1rem'}}>
                    Create Event
                </Button>
            </form>
        </Container>
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
