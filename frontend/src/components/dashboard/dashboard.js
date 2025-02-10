import Header from "../header/header";
import "./dashboard.css";
import img5 from "../../assets/images/img5.jpg";

const DashBoard = () => {
  const isLoggedIn = localStorage.getItem("user") !== null;

  return (
    <>
      <Header />
      <div
        className="main-container"
        style={{ backgroundImage: `url(${img5})` }}
      >
        {isLoggedIn ? (
          <h1>Welcome Back, User! 🎉</h1>
        ) : (
          <h1>Welcome to Scout App</h1>
        )}
      </div>
    </>
  );
};

export default DashBoard;
