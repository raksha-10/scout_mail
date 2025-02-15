import { createSlice } from "@reduxjs/toolkit";
const initialState = {
  user: null,
  token: null,
  organisation: null,
  otpUser: null, // Store user_id after signup to verify OTP
};
const authSlice = createSlice({
  name: "auth",
  initialState,
  reducers: {
    signupSuccess: (state, action) => {
      state.otpUser = action.payload; // Store user_id for OTP verification
    },
    otpVerifiedSuccess: (state, action) => {
      state.user = action.payload.user;
      state.token = action.payload.token;
      state.organisation = action.payload.organisation;
    },
    logout: (state) => {
      state.user = null;
      state.token = null;
      state.organisation = null;
      state.otpUser = null;
    },
  },
});
export const { signupSuccess, otpVerifiedSuccess, logout } = authSlice.actions;
export default authSlice.reducer;
