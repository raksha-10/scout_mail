import React from "react";
import Header from "../header/header";
import img5 from "../../assets/images/img5.jpg";
import img2_ from "../../assets/images/img2_.jpg"
import { useForm } from "react-hook-form";
import { SignUp } from "../apiurls/service";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { useNavigate } from "react-router-dom";
import "./inviteUser.css"
import { FormControlLabel, Radio, RadioGroup } from "@mui/material";
import { ShowOrganisation } from "../apiurls/service";
import { useState, useEffect } from "react";


const InviteUser = () =>{
  const navigate = useNavigate();
  const userId = localStorage.getItem("userId");
  const [organisations, setOrganisations] = useState([]);
  const {
    register,
    formState: { errors },
  } = useForm();

  const onSubmit = async (data) => {
    let payload = {
      user: {
        email: data.email,
        password: data.password,
        name: data.name,
      },
    };

    try {
      const response = await SignUp(payload);
      if (response.status === 200) {
        localStorage.setItem("authToken", response.token);
        toast.success("Signed up successfully!");
        navigate("/");
      }
    } catch (err) {
      toast.error("Email has already been taken.");
    }
  };
  
  useEffect(() => {
    if (userId) {
      const fetchOrganisations = async () => {
        try {
          const response = await ShowOrganisation(userId);
          setOrganisations(response.data);
        } catch (error) {
          console.error("Error fetching organisations:", error);
        }
      };

      fetchOrganisations();
    }
  }, [userId]);

  return (
    <>
      <Header />
      <div
        className="main-container"
        style={{ backgroundImage: `url(${img5})` }}
      >
        <form
          className="inviteUser-form"
          style={{ backgroundImage: `url(${img2_})` }}
        >
          <h2>Invite User</h2>
          <div>
            <label>Name</label>
            <input
              type="text"
              {...register("name", { required: "Name is required" })}
            />
            {errors.name && <p className="error">{errors.name.message}</p>}
          </div>
          <div>
            <label>Email</label>
            <input
              type="email"
              {...register("email", {
                required: "Email is required",
              })}
            />
            {errors.email && <p className="error">{errors.email.message}</p>}
          </div>
          <div>
            <label>Password</label>
            <input
              type="password"
              {...register("password", { required: "Password is required" })}
            />
            {errors.password && (
              <p className="error">{errors.password.message}</p>
            )}
          </div>
          <h4>User Role</h4>
          <RadioGroup
            aria-labelledby="demo-radio-buttons-group-label"
            defaultValue="Admin"
            name="radio-buttons-group"
          >
            <FormControlLabel value="Admin" control={<Radio />} label="Admin" />
            <FormControlLabel
              value="Full Admin"
              control={<Radio />}
              label="Full Admin"
            />
            <FormControlLabel
              value="Limited Full Admin"
              control={<Radio />}
              label="Limited Full Admin"
            />
            <FormControlLabel value="Read-only user" control={<Radio />} label="Read-only user" />
          </RadioGroup>
          <button type="submit">Send Invite</button>
        </form>
        <ToastContainer />
      </div>
    </>
  );
}

export default InviteUser;