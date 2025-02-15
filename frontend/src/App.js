import './App.css';
import Signup from "./components/Signup";
import Signin from "./components/Signin";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import OtpVerification from './components/OtpVerification';
import Dashboard from "./components/Dashboard/SettingOrganisation";
import Profile from './components/Profile';
import Setting from './components/Setting/Setting';
import SettingOrganisations from './components/Dashboard/SettingOrganisation';
import SettingProfile from './components/Setting/SettingProfile';
import SettingUsers from './components/Setting/SettingUser';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/signup" element={<Signup />} />
        <Route path="/signin" element={<Signin />} />
        <Route path="/dashboard/*" element={<Dashboard />} />
        <Route path="/otpVerification/:userId" element={<OtpVerification />} />
        <Route path="/settings/*" element={<Setting />}>
          <Route path="settingOrganisations" element={<SettingOrganisations />} />
          <Route path="settingProfile" element={<SettingProfile />} />
          <Route path="settingUsers" element={<SettingUsers />} />
        </Route>
        {/* <Route path="/profile" element={<Profile />} /> */}
        <Route path="/*" element={<Signup />} />
      </Routes>
    </Router>
  );
}

export default App;
