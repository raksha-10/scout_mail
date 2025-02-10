// import React from 'react';
// import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
// import SignupForm from './components/signup/signup';
// import LogInForm from './components/login/login';
// const App = () => {
//   return (
//     <Router>
//         <Routes>
//           <Route path="/login" element={<LogInForm/>} />
//           <Route path="/signup" element={<SignupForm/>} />
//         </Routes>
//     </Router>
//   );
// };
// export default App;


import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import  axios from "axios";
import DashBoard from './components/dashboard/dashboard';
import { useEffect, useState } from 'react';
import SignupForm from './components/signup/signup';
import LogInForm from './components/login/login';
import OrganisationForm from './components/organisation/createOrganisation';
import InviteUser from './components/inviteUser/inviteUser';
import EditProfile from './components/profile/editProfile'

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<DashBoard />} />
        <Route path="/signup" element={<SignupForm />} />
        <Route path="/login" element={<LogInForm />} />
        <Route path="/createOrganisation" element={<OrganisationForm />} />
        <Route path="/inviteUser" element={<InviteUser />} />
        <Route path="/editProfile" element={<EditProfile />} />
      </Routes>
    </Router>
  );
};

export default App;