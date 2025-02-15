import React, { useState } from "react";
import {
  TextField,
  Button,
  Grid2,
  Typography,
  Paper,
  Link,
  InputLabel,
} from "@mui/material";
import { useNavigate, useParams } from "react-router-dom";

import { otpVerifiedSuccess } from "../redux/authSlice";  // Correct

import { useDispatch,useSelector } from "react-redux";


const OtpVerification = () => {
  const [otp, setOtp] = useState("");
  const [error, setError] = useState("");
  const dispatch = useDispatch();






  const navigate = useNavigate();
  const otpUser = useSelector((state) => state.auth.otpUser);

  const userId= useParams()

  const handleChange = (e) => {
    setOtp(e.target.value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!otpUser?.user_id) {
      alert("User ID not found. Please sign up again.");
      navigate("/signup");
      return;
    }
    try {
      const response = await fetch("http://localhost:3001/verify_otp", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ user_id: otpUser.user_id, otp }),
      });
      const data = await response.json();
      if (response.ok) {
        dispatch(
          otpVerifiedSuccess({
            user: data.user,
            token: data.token,
            organisation: data.organisation,
          })
        );
        // localStorage.setItem("token", data.token);
        // localStorage.setItem("user", JSON.stringify(data.user));
        // localStorage.setItem("organisation", JSON.stringify(data.organisation));
        alert("Account activated successfully!");
        navigate("/dashboard");
      } else {
        alert(data.error || "OTP verification failed.");
      }
    } catch (error) {
      console.error("Error verifying OTP:", error);
      alert("Something went wrong. Please try again.");
    }
  };

  return (
    <Grid2 container component="main" sx={{ height: "100vh" }}>
      {/* Left Side */}
      <Grid2
        size={{ xs: 12, sm: 4 }}
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
            Confirm OTP for Scout
          </Typography>
        </div>
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
            OTP Verification
          </Typography>
          {error && (
            <Typography color="error" align="center">
              {error}
            </Typography>
          )}
          <form onSubmit={handleSubmit}>
            <InputLabel>Enter OTP code</InputLabel>
            <TextField
              fullWidth
              label="OTP"
              name="otp"
              variant="outlined"
              margin="normal"
              value={otp}
              onChange={handleChange}
            />
            <Button
              type="submit"
              variant="contained"
              fullWidth
              sx={{ mt: 2, backgroundColor: "#4B0082", color: "white" }}
            >
              Verify OTP
            </Button>
          </form>
          <Typography align="center" sx={{ mt: 2 }}>
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
        </Paper>
      </Grid2>
    </Grid2>
  );
};

export default OtpVerification;
