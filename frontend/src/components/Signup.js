import React, { useState, useEffect } from "react";
import {
  TextField,
  Button,
  Box,
  Grid2,
  Typography,
  Paper,
  InputAdornment,
  IconButton,
  Link,
  InputLabel,
  Select,
  MenuItem,
} from "@mui/material";
import { Visibility, VisibilityOff } from "@mui/icons-material";
import { useNavigate } from "react-router-dom";
import { useDispatch } from "react-redux";
import { signupSuccess } from "../redux/authSlice";  // Correct


const SignupPage = () => {
  const [formData, setFormData] = useState({
    fullName: "",
    email: "",
    companyName: "",
    password: "",
    organisationType: "",
  });

  const [organisationTypes, setOrganisationTypes] = useState([]);
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const dispatch = useDispatch();







  // Fetch Organisation Types
  useEffect(() => {
    const fetchOrganisationTypes = async () => {
      try {
        const response = await fetch(
          "http://localhost:3001/api/v1/organisations/organisation_types"
        );
        const data = await response.json();
        setOrganisationTypes(data); // Set fetched data in state
      } catch (error) {
        console.error("Error fetching organisation types:", error);
      }
    };

    fetchOrganisationTypes();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };



  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    // Check if organisationType is set
    if (!formData.organisationType) {
      alert("Please select an organisation type.");
      setLoading(false);
      return;
    }

    const signupData = {
      user: {
        email: formData.email,
        password: formData.password,
        name: formData.fullName,
        organisation: formData.companyName,
        organisation_type_id: formData.organisationType, // Ensure this is an ID
      },
    };

    try {
      const response = await fetch(`http://localhost:3001/signup`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(signupData),
      });

      const data = await response.json();
     
      setLoading(false);

      if (response.ok) {
        localStorage.setItem("organisation", formData.companyName);

        dispatch(
          signupSuccess({ email: formData.email, user_id: data.user_id })
        );

        alert(data.message); // "OTP sent to email"
        navigate(`/otpVerification/${data.user_id}`);
        dispatch();
      } else {
        alert(data.error || "Signup failed");
      }
    } catch (error) {
      setLoading(false);
    }
  };


  return (
    <Grid2
      container
      component="main"
      sx={{ height: "100vh", position: "relative" }}
    >
      {/* Sign In Link in the Top Right Corner */}
      <Box sx={{ position: "absolute", top: 16, right: 16 }}>
        <Typography align="center">
          Already have an account?{" "}
          <Link
            onClick={() => navigate("/signin")}
            sx={{ cursor: "pointer" }}
            color="primary"
            underline="none"
          >
            Sign In
          </Link>
        </Typography>
      </Box>

      {/* Left Side */}
      <Grid2
        size={{ xs: 12, sm: 4 }}
        sx={{
          background: "url('/images/bg-blue.png')",
          backgroundSize: "cover",
          backgroundPosition: "center",
          backgroundRepeat: "no-repeat",
          color: "white",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          textAlign: "center",
          padding: 4,
        }}
      >
        <Typography variant="h5" sx={{ mt: 2, fontWeight: "bold" }}>
          Sign up for Scout
        </Typography>
      </Grid2>

      {/* Right Side */}
      <Grid2
        size={{ xs: 12, sm: 8 }}
        sx={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          backgroundColor: "#f8f6fc",
        }}
      >
        <Paper
          elevation={3}
          sx={{ padding: 4, maxWidth: 400, height: "70%" }}
        >
          <Typography
            variant="h5"
            align="left"
            gutterBottom
            sx={{
              fontFamily: "Inter",
              fontWeight: 700,
              fontSize: "24px",
              lineHeight: "29.05px",
            }}
          >
            Start your free 30-day trial
          </Typography>

          <Typography variant="body1" align="left" color="textSecondary">
            Unlimited cold emailing at scale with AI Warmups
          </Typography>

          <form onSubmit={handleSubmit}>
            {/* Full Name */}
            <InputLabel>Full Name</InputLabel>
            <TextField
              fullWidth
              name="fullName"
              variant="outlined"
              required
              onChange={handleChange}
              sx={{
                mb: 2,
                "& .MuiInputBase-root": {
                  height: "40px", // Set the height
                },
                borderRadius: "8px",
              }}
            />

            {/* Email Address */}
            <InputLabel>Email Address</InputLabel>
            <TextField
              fullWidth
              name="email"
              type="email"
              variant="outlined"
              required
              onChange={handleChange}
              sx={{
                mb: 2,
                "& .MuiInputBase-root": {
                  height: "40px", // Set the height
                },
                borderRadius: "8px",
              }}
            />

            {/* Create Password */}
            <InputLabel>Create Password</InputLabel>
            <TextField
              fullWidth
              name="password"
              type={showPassword ? "text" : "password"}
              variant="outlined"
              required
              onChange={handleChange}
              sx={{
                mb: 2,
                "& .MuiInputBase-root": {
                  height: "40px", // Set the height
                },
                borderRadius: "8px",
              }}
              slotProps={{
                input: {
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={() => setShowPassword((prev) => !prev)}
                        edge="end"
                      >
                        {!showPassword ? <VisibilityOff /> : <Visibility />}
                      </IconButton>
                    </InputAdornment>
                  ),
                },
              }}
            />

            {/* Company Name */}
            <InputLabel>Company Name</InputLabel>
            <TextField
              fullWidth
              name="companyName"
              variant="outlined"
              required
              onChange={handleChange}
              sx={{
                mb: 2,
                "& .MuiInputBase-root": {
                  height: "40px", // Set the height
                },
                borderRadius: "8px",
              }}
            />

            {/* Company Domain (Dropdown) */}
            <InputLabel>Company Domain</InputLabel>
            <Select
              name="organisationType"
              value={formData.organisationType}
              onChange={handleChange} // Updated
              variant="outlined"
              required
              fullWidth
              sx={{
                mb: 2,
                "& .MuiInputBase-root": { height: "40px" },
                borderRadius: "8px",
              }}
            >
              {organisationTypes.map((type) => (
                <MenuItem key={type.id} value={type.id}>
                  {type.name} {/* Store ID, display name */}
                </MenuItem>
              ))}
            </Select>

            {/* Submit Button */}
            <Button
              type="submit"
              variant="contained"
              fullWidth
              sx={{
                mt: 2,
                "& .MuiInputBase-root": {
                  height: "40px", // Set the height
                },
                backgroundColor: "#4B0082",
                color: "white",
                borderRadius: "8px",
                padding: "10px",
              }}
              disabled={loading}
            >
              {loading ? "Signing Up..." : "Sign Up"}
            </Button>
          </form>
        </Paper>
      </Grid2>
    </Grid2>
  );
};

export default SignupPage;
