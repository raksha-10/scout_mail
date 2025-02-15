import React, { useState, useEffect } from "react";
import {
  TextField,
  Button,
  Box,
  Typography,
  InputLabel,
  Avatar,
  Grid2,
} from "@mui/material";
import CloudUploadIcon from "@mui/icons-material/CloudUpload";

const SettingProfile = () => {
  const [user, setUser] = useState({
    name: "",
    email: "",
    mobile: "",
    linkedin_url: "",
    image: "",
  });

  const userId = localStorage.getItem("id");

  useEffect(() => {
    fetch(`http://localhost:3001/api/v1/users/${userId}`)
      .then((response) => response.json())
      .then((data) => setUser(data.user))
      .catch((error) => console.error("Error fetching user data:", error));
  }, [userId]);

  const handleChange = (e) => {
    setUser({ ...user, [e.target.name]: e.target.value });
  };

  const handleSubmit = () => {
    fetch(`http://localhost:3001/api/v1/users/${userId}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ user }),
    })
      .then((response) => response.json())
      .then((data) => console.log("User updated successfully", data))
      .catch((error) => console.error("Error updating user:", error));
  };

  return (
    <Box sx={{ width: "100%" }}>
      <Box sx={{ width: "100%" }}>
        <Box
          className="organization-form"
          sx={{ border: "1px solid #ddd", p: 3, borderRadius: 2 }}
        >
          <Typography variant="h6" sx={{ mb: 2 }}>
            Profile
          </Typography>
          <Typography variant="subtitle2" sx={{ mb: 2 }}>
            Change your name, profile picture, role etc.
          </Typography>

          <Grid2 container spacing={2}>
            <Grid2 size={{ xs: 6, sm: 6 }}>
              <InputLabel>Full Name</InputLabel>
              <TextField
                fullWidth
                variant="outlined"
                placeholder="Full Name"
                name="name"
                value={user.name}
                onChange={handleChange}
                required
              />
            </Grid2>

            <Grid2 size={{ xs: 6, sm: 6 }}>
              <InputLabel>Email</InputLabel>
              <TextField
                fullWidth
                variant="outlined"
                placeholder="Email"
                name="email"
                value={user.email}
                onChange={handleChange}
                required
              />
            </Grid2>

            <Grid2 size={{ xs: 6, sm: 6 }}>
              <InputLabel>Phone Number</InputLabel>
              <TextField
                fullWidth
                variant="outlined"
                placeholder="Phone Number"
                name="mobile"
                value={user.mobile}
                onChange={handleChange}
                required
              />
            </Grid2>

            <Grid2 size={{ xs: 6, sm: 6 }}>
              <InputLabel>LinkedIn Profile</InputLabel>
              <TextField
                fullWidth
                variant="outlined"
                placeholder="LinkedIn Profile"
                name="linkedin_url"
                value={user.linkedin_url}
                onChange={handleChange}
                required
              />
            </Grid2>

            <Grid2
              size={{ xs: 6, sm: 6 }}
              sx={{ display: "flex", alignItems: "center" }}
            >
              <Avatar src={user.image} sx={{ width: 60, height: 60, mr: 2 }} />
              <Button
                variant="contained"
                component="label"
                startIcon={<CloudUploadIcon />}
                sx={{ backgroundColor: "white", color: "black" }}
              >
                Upload Profile Picture
                <input type="file" hidden />
              </Button>
            </Grid2>

            <Grid2 size={{ xs: 6, sm: 6 }}>
              <Button
                variant="contained"
                color="primary"
                sx={{ mt: 2 }}
                onClick={handleSubmit}
              >
                Update
              </Button>
            </Grid2>
          </Grid2>
        </Box>
      </Box>
    </Box>
  );
};

export default SettingProfile;
