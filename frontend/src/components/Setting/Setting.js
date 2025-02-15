import { Tabs, Tab } from "@mui/material";
// import SettingOrganisation from "./SettingOrganisations";
import SettingProfile from "./SettingProfile";
import { Box } from "@mui/material";
import { useState } from "react";
import SettingUsers from "./SettingUser";
import SettingOrganisations from "./SettingOrganisations";

function Setting() {
  const [selectButton, setSelectButton] = useState(0);
  const buttons = ["Organisations", "Profile", "Users"];
  const components = [SettingOrganisations, SettingProfile, SettingUsers];

  const Component = components[selectButton];
  const handleTabChange = (event, newValue) => {
    setSelectButton(newValue);
  }

  return (
    <Box sx={{ width: "100%" }}>
      <Tabs
        value={selectButton}
        onChange={handleTabChange}
        sx={{ marginLeft: "35px" }}
      >
        {" "}
        {buttons.map((button, index) => (
          <Tab
            key={index}
            label={button}
            value={index}
          />
        ))}
      </Tabs>
      <Component />
    </Box>
  );
}

export default Setting;

