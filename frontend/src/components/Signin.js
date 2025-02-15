import React, { useState } from "react";
import {
  TextField,
  Button,
  Grid2,
  Typography,
  Paper,
  InputAdornment,
  IconButton,
  Link,
  InputLabel,
} from "@mui/material";
import { Visibility, VisibilityOff } from "@mui/icons-material";
import { useNavigate } from "react-router-dom";

const SignIn = () => {
  const [formData, setFormData] = useState({
    email: "",
    password: "",
  });

  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError(""); // Clear previous errors

    try {
      const response = await fetch("http://localhost:3001/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ user: formData }),
      });

      const data = await response.json();

      if (response.ok) {
        localStorage.setItem("token", data.token);
        localStorage.setItem("id", data.user.id);
        localStorage.setItem("name", data.user.name);
        localStorage.setItem("email", data.user.email);
        localStorage.setItem("organisation_id", data.organisation.id);
        localStorage.setItem("organisation_name", data.organisation.name);
        navigate("/dashboard"); // Redirect to dashboard after login
      } else {
        setError(data.message || "Invalid email or password");
      }
    } catch (error) {
      setError("Something went wrong. Please try again.");
    }
  };

  const togglePasswordVisibility = () => {
    setShowPassword((prev) => !prev);
  };

  return (
    <Grid2 container component="main" sx={{ height: "100vh", width: "vw" }}>
      {/* Left Section */}
      <Grid2
        size={{ xs: 10, sm: 8 }}
        sx={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          backgroundColor: "#f8f6fc",
        }}
      >
        <Paper elevation={3} sx={{ padding: 4, width: "80%", maxWidth: 400 }}>
          <Typography
            variant="h5"
            align="left"
            gutterBottom
            sx={{
              mt: 2,
              fontFamily: "Inter",
              fontWeight: "700",
              fontSize: "24px",
              lineHeight: "29.05px",
            }}
          >
            Sign in
          </Typography>
          {error && (
            <Typography color="error" align="center" sx={{ mt: 1 }}>
              {error}
            </Typography>
          )}
          <form onSubmit={handleSubmit}>
            <InputLabel>Email</InputLabel>
            <TextField
              fullWidth
              name="email"
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

            <InputLabel>Password</InputLabel>
            <TextField
              fullWidth
              name="password"
              variant="outlined"
              type={showPassword ? "text" : "password"} // Toggle type
              required
              value={formData.password} // Fix: Bind state
              onChange={handleChange} // Fix: Handle change
              sx={{
                mb: 2,
                "& .MuiInputBase-root": {
                  height: "40px",
                },
                borderRadius: "8px",
              }}
              InputProps={{
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={togglePasswordVisibility}
                      edge="end"
                      aria-label="toggle password visibility"
                    >
                      {!showPassword ? <VisibilityOff /> : <Visibility />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
            />

            <Grid2 container justifyContent="space-between">
              <Grid2 item>
                <Link href="#" color="error" underline="none">
                  Forgot Password?
                </Link>
              </Grid2>
            </Grid2>
            <Button
              type="submit"
              variant="contained"
              fullWidth
              sx={{ mt: 2, backgroundColor: "#4B0082", color: "white" }}
            >
              Login
            </Button>
          </form>
          <Typography align="center" sx={{ mt: 2 }}>
            New to Scout?{" "}
            <Link
              onClick={() => navigate("/signup")}
              sx={{ cursor: "pointer" }}
              color="primary"
              underline="none"
            >
              Sign up
            </Link>
          </Typography>
        </Paper>
      </Grid2>

      {/* Right Section */}
      <Grid2
        size={{ xs: 10, sm: 4 }}
        sx={{
          background:
            "radial-gradient(67.35% 50% at 50% 50%, #472567 3.6%, #000000 35.1%, #472567 94.6%)",
          color: "white",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          textAlign: "center",
          padding: 4,
        }}
      >
        <div>
          <Typography variant="h5" sx={{ mt: 2, fontWeight: "bold" }}>
            Sign in to Scout
          </Typography>
          <Typography variant="body1" sx={{ mt: 2 }}>
            Always land in your lead's inbox with unlimited sender accounts, so
            you can focus on closing deals.
          </Typography>
        </div>
      </Grid2>
    </Grid2>
  );
};

export default SignIn;
