import { Box, IconButton, Tooltip } from '@mui/material';
import { Delete, Edit, Preview } from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { toast } from 'sonner';
import { addDoc, collection, deleteDoc, doc, getDocs, updateDoc } from 'firebase/firestore'
import { db } from "../../config/firebase";
import MarkerEditModal from '../../components/modals/MarkerEditModal'
import FlexBetween from '../../components/FlexBetween';

const MarkerActions = ({ params, snackbarShowMessage }) => {
  const {marker_id: id, imageUrl, userid, formattedTime, description, address} = params.row;
  const navigate = useNavigate();


  // console.log("description of the row in markers Action?>>>", description);






  

//   const handleEdit = () => { 
//     console.log("edit");

//   const promise = () => new Promise((resolve) => setTimeout(() => resolve({ name: 'Sonner' }), 2000));

// toast.promise(promise, {
//   loading: 'Loading...',
//   success: (data) => {
//     return `${data.name} toast has been added`;
//   },
//   error: 'Error',
// });


   
  
//   }

   const handleDelete = async () => { 
    console.log("document individual id", id);
    console.log("description individual", description);

    // const deleteVal =  doc(db,"Markers",id)
    // console.log("selected doc?", deleteVal);
    // const deleteAction = await deleteDoc(deleteVal)
    // toast.promise(
    //   deleteAction, {
    //     loading: 'Deleting...',
    //     success: <b>Marker sucessfully deleted!</b>,
    //     error: <b>Could not delete marker</b>,
    //   }
    // )

    try {
    console.log("document id", id);

      const deleteVal = doc(db, "Markers", id);
         console.log("selected doc?", deleteVal);
      await deleteDoc(deleteVal);
  
      //need to refactor this properly later
      const promise = () => new Promise((resolve) => setTimeout(() => resolve({ name: 'Sonner' }), 2000));

      toast.promise(promise, {
        loading: 'Loading...',
        success: 'Marker deleted sucessfully',
        error: 'Error',
      });
      
    } catch (error) {
      toast.error('Could not delete marker');
      console.error('Error:', error);
    }




    }


  return (
    <Box display='flex' gap={2}>
      {/* <Tooltip title="View marker details">
        <IconButton>
          <Preview />
        </IconButton>
      </Tooltip> */}
      <Tooltip title="Edit  marker">

      <IconButton>
      {/* <MarkerEditModal/> */}
      <MarkerEditModal params={params}/>
        </IconButton>


      </Tooltip>
      <Tooltip title="Delete marker">
        <IconButton
        onClick={handleDelete}
        >
          <Delete />
        </IconButton>
      </Tooltip>
    </Box>
  );
};

export default MarkerActions;
