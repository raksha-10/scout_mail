import Header from "../header/header";
import "./createOrganisation.css";
import { useForm } from "react-hook-form";
import { Organisation } from "../apiurls/service";
import { toast, ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import img2_ from "../../assets/images/img2_.jpg";
import img5 from "../../assets/images/img5.jpg";

const OrganisationForm = () => {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  const onSubmit = async (data) => {
    let payload = { name: data.name };

    try {
      const response = await Organisation(payload);
      if (response.status === 200) {
        console.log("Organisation created successfully!", response);
        toast.success("Organisation created successfully!");
      }
    } catch (err) {
      console.error("Something went wrong. Please try again.", err);
      toast.error("Organisation has already been taken.");
    }
  };

  return (
    <>
      <Header />
      <div
        className="main-container"
        style={{ backgroundImage: `url(${img5})` }}
      >
        <form
          onSubmit={handleSubmit(onSubmit)}
          className="organisation-form"
          style={{ backgroundImage: `url(${img2_})` }}
        >
          <h2>Create Organisation</h2>
          <div>
            <label>Organisation Name</label>
            <input
              type="text"
              {...register("name", {
                required: "Organisation name is required",
              })}
            />
            {errors.name && (
              <p style={{ color: "red" }}>{errors.name.message}</p>
            )}
          </div>
          <button type="submit">Create</button>
        </form>
      </div>
      <ToastContainer />
    </>
  );
};

export default OrganisationForm;
