import React from "react";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Button,
  MenuItem,
  Typography,
} from "@mui/material";

const NewUser = ({ open, handleClose }) => {
  return (
    <Dialog open={open} onClose={handleClose} fullWidth maxWidth="sm">
      <DialogTitle fontWeight="bold">New User</DialogTitle>
      <DialogContent>
        <Typography variant="subtitle2" color="gray" mb={2}>
          Lorum ipsum fill detail
        </Typography>

        <TextField fullWidth label="Full Name" margin="dense" />
        <TextField fullWidth label="Enter Email" margin="dense" />
        <TextField fullWidth label="Phone Number" margin="dense" />
        <TextField select fullWidth label="Role" margin="dense">
          <MenuItem value="Admin">Admin</MenuItem>
          <MenuItem value="Sales Executive">Sales Executive</MenuItem>
          <MenuItem value="Manager">Manager</MenuItem>
          <MenuItem value="Content Creator">Content Creator</MenuItem>
        </TextField>
      </DialogContent>

      <DialogActions>
        <Button onClick={handleClose} color="secondary">
          Cancel
        </Button>
        <Button variant="contained" color="primary">
          Submit
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default NewUser;
