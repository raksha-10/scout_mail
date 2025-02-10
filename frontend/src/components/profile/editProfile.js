import Header from "../header/header";
import img5 from "../../assets/images/img5.jpg";
import img2_ from "../../assets/images/img2_.jpg";
import "./editProfile.css"

const EditProfile = () => {
  return (
    <>
      <Header />
      <div
        className="main-container"
        style={{ backgroundImage: `url(${img5})` }}
      >
        <form
          className="profile-form"
          style={{ backgroundImage: `url(${img2_})` }}
        >
          <h2>Edit Profile</h2>
          <div>
            <label>Name</label>
            <input type="text" />
          </div>
          <div>
            <label>Email</label>
            <input type="email" />
          </div>
          <div>
            <label>Password</label>
            <input type="password" />
          </div>
          <div>
            <label>New Password</label>
            <input type="password" />
          </div>
          <button type="submit">Submit</button>
        </form>
      </div>
    </>
  );
};

export default EditProfile;
