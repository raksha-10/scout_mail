import {
  TextField,
  Button,
  Box,
  Grid2,
  Typography,
  InputLabel,
  MenuItem,
  Select,
} from "@mui/material";
import { useEffect, useState } from "react";

function SettingOrganisations() {
  const [organisation, setOrganisation] = useState({
    name: "",
    email: "",
    mobile: "",
    location: "",
    linkedin_url: "",
    twitter_url: "",
    facebook_url: "",
    tax_id: "",
    organisation_type_id: "",
  });

  const [domainOptions, setDomainOptions] = useState([]);
  // const organisationId = 41; // Assuming fixed organisation ID for now
  const baseUrl = "http://localhost:3001"; // Replace with actual base URL
  const authToken = localStorage.getItem("token")
  const organisationId = localStorage.getItem("organisation_id");
  const organisation_types = localStorage.getItem("organisation_name");

  // Fetch Organisation and User Data
  useEffect(() => {
    fetch(`${baseUrl}/api/v1/organisations/${organisationId}`, {
      headers: {
        Authorization: `Bearer ${authToken}`,
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.organisation) {
          setOrganisation(data.organisation);
        }
      })
      .catch((error) => console.error("Error fetching organisation:", error));
    // Fetch domain options (Replace with actual API for domain list)
    fetch(`${baseUrl}/api/v1/organisation_types`)
      .then((response) => response.json())
      .then((data) => {
        setDomainOptions(data.organisation_types || []);
      })
      .catch((error) => console.error("Error fetching domain options:", error));
  }, []);

  // Handle Form Input Change
  const handleChange = (e) => {
    setOrganisation({ ...organisation, [e.target.name]: e.target.value });
  };

  // Handle Form Submission
  const handleSubmit = () => {
    fetch(`${baseUrl}/api/v1/organisations/${organisationId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ organisation }),
    })
      .then((response) => response.json())
      .then((data) => {
        alert(data.message || "Organisation updated successfully!");
      })
      .catch((error) => console.error("Error updating organisation:", error));
  };

  return (
    <Box sx={{ width: "100%" }}>
      <Box sx={{ width: "100%" }}>
        <Box sx={{ border: "1px solid #ddd", p: 3, borderRadius: 2 }}>
          <Typography variant="h6" sx={{ mb: 2 }}>
            Organization
          </Typography>
          <Typography variant="subtitle2" sx={{ mb: 2 }}>
            Organization Details
          </Typography>
          <Grid2 container spacing={2}>
            <Grid2 size={{ xs: 6, sm: 6, md: 6 }}>
              <InputLabel>Organization Name</InputLabel>
              <TextField
                fullWidth
                name="name"
                variant="outlined"
                placeholder="Organization Name"
                value={organisation.name}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 6, sm: 6, md: 6 }}>
              <InputLabel>Email</InputLabel>
              <TextField
                fullWidth
                name="email"
                variant="outlined"
                placeholder="Email"
                value={organisation.email}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 6, sm: 6, md: 6 }}>
              <InputLabel>Phone Number</InputLabel>
              <TextField
                fullWidth
                name="mobile"
                variant="outlined"
                placeholder="Phone Number"
                value={organisation.mobile}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 6, sm: 6, md: 6 }}>
              <InputLabel>Domain</InputLabel>
              <Select
                fullWidth
                name="organisation_type_id"
                value={organisation.organisation_type_id}
                onChange={handleChange}
                required
                sx={{ mb: 1 }}
              >
                {domainOptions.map((option) => (
                  <MenuItem key={option.id} value={option.id}>
                    {option.name}
                  </MenuItem>
                ))}
              </Select>
            </Grid2>
            <Grid2 size={{ xs: 6, sm: 6, md: 6 }}>
              <InputLabel>Address</InputLabel>
              <TextField
                fullWidth
                name="location"
                variant="outlined"
                placeholder="Address"
                value={organisation.location}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 6, sm: 6, md: 6 }}>
              <InputLabel>Tax ID</InputLabel>
              <TextField
                fullWidth
                name="tax_id"
                variant="outlined"
                placeholder="Tax ID"
                value={organisation.tax_id}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 4, sm: 4, md: 4 }}>
              <InputLabel>LinkedIn URL</InputLabel>
              <TextField
                fullWidth
                name="linkedin_url"
                variant="outlined"
                placeholder="LinkedIn URL"
                value={organisation.linkedin_url}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 4, sm: 4, md: 4 }}>
              <InputLabel>Twitter URL</InputLabel>
              <TextField
                fullWidth
                name="twitter_url"
                variant="outlined"
                placeholder="Twitter URL"
                value={organisation.twitter_url}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
            <Grid2 size={{ xs: 4, sm: 4, md: 4 }}>
              <InputLabel>Facebook URL</InputLabel>
              <TextField
                fullWidth
                name="facebook_url"
                variant="outlined"
                placeholder="Facebook URL"
                value={organisation.facebook_url}
                onChange={handleChange}
                required
                sx={{ mb: 1, "& .MuiInputBase-root": { height: "40px" } }}
              />
            </Grid2>
          </Grid2>
          <Button
            variant="contained"
            color="primary"
            sx={{ mt: 2 }}
            onClick={handleSubmit}
          >
            Update
          </Button>
        </Box>
      </Box>
    </Box>
  );
}

export default SettingOrganisations;
