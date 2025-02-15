import React, { useState } from "react";
import {
  Menu,
  MenuItem,
  Box,
  Avatar,
  Typography,
  ListItemIcon,
  ListItemText
} from "@mui/material";
import SettingsIcon from "@mui/icons-material/Settings";
import BusinessIcon from "@mui/icons-material/Business";
import LogoutIcon from "@mui/icons-material/Logout";

import { AccountCircle } from "@mui/icons-material";
import { useNavigate, Routes, Route } from "react-router-dom";
import Settings from "../Setting/Setting";
import Organization from "./Organisation";

import "./Dashboard.css";

const SettingOrganisation = () => {
  const [anchorEl, setAnchorEl] = useState(null);
  const navigate = useNavigate(); // Navigation hook

  const handleMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleNavigation = (path) => {
    navigate(path); // Navigate to the selected page
    handleMenuClose();
  };

  const user = {
    name: "Sibananda",
    email: "sibananda.k@geitpl.com",
    profilePic: "", // You can add a profile pic URL
    activeLeads: 888,
    totalLeads: 1250,
    emailCredits: 1501,
    totalCredits: 2500,
  };

  return (
    <div className="dashboard">
      {/* Sidebar */}
      <aside className="sidebar"></aside>

      {/* Main Content */}
      <div className="main-content">
        <header className="header">
          <AccountCircle
            sx={{ height: "40px", width: "40px" }}
            className="user-icon"
            onClick={handleMenuOpen}
          />
          <Menu
            anchorEl={anchorEl}
            open={Boolean(anchorEl)}
            onClose={handleMenuClose}
          >
            <div
              style={{ padding: "10px", display: "flex", alignItems: "center", width: "300px", height: "60px" }}
            >
              <Avatar src="/profile.jpg" alt="User" />
              <div style={{ marginLeft: "10px" }}>
                <Typography variant="subtitle1">John Doe</Typography>
                <Typography variant="body2" color="textSecondary">
                  johndoe@example.com
                </Typography>
              </div>
            </div>
            <MenuItem onClick={() => handleNavigation("/dashboard/settings")}>
              <ListItemIcon>
                <SettingsIcon fontSize="small" />
              </ListItemIcon>
              <ListItemText primary="Settings" />
            </MenuItem>

            <MenuItem
              onClick={() => handleNavigation("/dashboard/organization")}
            >
              <ListItemIcon>
                <BusinessIcon fontSize="small" />
              </ListItemIcon>
              <ListItemText primary="Organization" />
            </MenuItem>

            <MenuItem onClick={() => handleNavigation("/signin")}>
              <ListItemIcon>
                <LogoutIcon fontSize="small" />
              </ListItemIcon>
              <ListItemText primary="Logout" />
            </MenuItem>
          </Menu>
        </header>

        <Box p={3}>
          <Routes>
            <Route path="/settings" element={<Settings />} />
            <Route path="/organization" element={<Organization />} />
          </Routes>
        </Box>
      </div>
    </div>
  );
};

export default SettingOrganisation;
