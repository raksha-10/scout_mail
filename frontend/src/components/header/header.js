import {
  AppBar,
  Toolbar,
  Drawer,
  List,
  ListItem,
  ListItemText,
  Button,
  IconButton,
  Divider,
  Box,
} from "@mui/material";
import { Link } from "react-router-dom";
import { useState, useEffect } from "react";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import { ShowOrganisation } from "../apiurls/service";
import burger from "../../assets/images/burger.png";
import profile from "../../assets/images/profile.png";


const HeaderAndSideNav = () => {
  const isLoggedIn = localStorage.getItem("user") !== null;
  const userId = localStorage.getItem("userId");
  const [organisations, setOrganisations] = useState([]);
  const [open, setOpen] = useState(true);

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
      <AppBar position="fixed" sx={{ zIndex: 1300 }}>
        <Toolbar style={{ height: "40px", backgroundColor: "#6e58f1" }}>
          <IconButton onClick={() => setOpen(!open)}>
            <img src={burger} alt="menu icon" width="24" height="24" />
          </IconButton>
          <IconButton
            component={Link}
            to="/editProfile"
            style={{ position: "absolute", right: "0", padding: "20px" }}
          >
            <img src={profile} width="35" height="35" />
          </IconButton>
          <Box>
            {isLoggedIn ? (
              <>
                <Button
                  color="inherit"
                  component={Link}
                  to="/signup"
                  style={{ marginRight: 10 }}
                >
                  Signup
                </Button>
                <Button
                  color="inherit"
                  component={Link}
                  to="/login"
                  style={{ marginRight: 10 }}
                >
                  Login
                </Button>
              </>
            ) : null}
          </Box>
        </Toolbar>
      </AppBar>
      <Box sx={{ display: "flex" }}>
        <Drawer
          variant="persistent"
          anchor="left"
          open={open}
          sx={{
            width: open ? 250 : 0,
            transition: "width 0.3s",
            flexShrink: 0,
          }}
        >
          <Box sx={{ marginTop: "70px", width: 190, p: 2 }}>
            {!isLoggedIn ? (
              <>
                <List>
                  <ListItem button component={Link} to="/">
                    <ListItemText primary="Dashboard" />
                  </ListItem>
                  <ListItem button component={Link} to="/createOrganisation">
                    <ListItemText primary="Create Organisation" />
                  </ListItem>
                  <FormControl variant="standard" sx={{ m: 1, minWidth: 120 }}>
                    <InputLabel id="demo-simple-select-standard-label organisation-select-label">Organisation</InputLabel>
                    <Select
                      labelId="demo-simple-select-standard-label organisation-select-label"
                      id="demo-simple-select-standard organisation-select"
                    >
                      <MenuItem value="">
                        <em>None</em>
                      </MenuItem>
                      {organisations.map((organisation) => (
                        <MenuItem key={organisation.id} value={organisation.id}>
                          {organisation.name}
                        </MenuItem>
                      ))}
                    </Select>
                  </FormControl>
                  <ListItem button component={Link} to="/inviteUser">
                    <ListItemText primary="Invite User" />
                  </ListItem>
                  <ListItem button component={Link} to="/login">
                    <ListItemText primary="Logout" />
                  </ListItem>
                </List>
              </>
            ) : (
              <List>
                <ListItem button component={Link} to="/signup">
                  <ListItemText primary="Signup" />
                </ListItem>
                <ListItem button component={Link} to="/login">
                  <ListItemText primary="Login" />
                </ListItem>
              </List>
            )}
            <Divider />
          </Box>
        </Drawer>
        <Box component="main" sx={{ flexGrow: 1, p: 3 }}>
          {/* Main content goes here */}
        </Box>
      </Box>
    </>
  );
};

export default HeaderAndSideNav;
