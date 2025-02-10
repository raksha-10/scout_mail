import React from 'react';
import './login.css';
import { useForm } from 'react-hook-form';
import { Login } from '../apiurls/service';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { useNavigate } from 'react-router-dom';
import img2 from '../../assets/images/img2.jpg';
import img5 from '../../assets/images/img5.jpg';

const LogInForm = () => {
  const navigate = useNavigate();
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm();

  const onSubmit = async (data) => {
    let payload = {
      user: {
        email: data.email,
        password: data.password,
      },
    };

    try {
      const response = await Login(payload);
      if (response.status === 200) {
        localStorage.setItem('authToken', response.token);
        console.log('User logged in successfully:', response);
        toast.success('Logged in successfully!');
        navigate('/');
      }
    } catch (err) {
      console.error('Error during login:', err);
      const errorMessage = 'Invalid email or password';
      toast.error(errorMessage);
    }
  };

  return (
    <>
      <div className="login-page" style={{ backgroundImage: `url(${img5})` }}>
        <form onSubmit={handleSubmit(onSubmit)} className="login-form" style={{ backgroundImage: `url(${img2})` }}>
          <h2>Log In</h2>
          <div>
            <label>Email</label>
            <input
              type="email"
              {...register("email", {
                required: "Email is required",
                pattern: {
                  value: /^[a-zA-Z0-9._%+-]+@[a-zAA-Z0-9.-]+\.[a-zA-Z]{2,4}$/,
                  message: "Invalid email format",
                },
              })}
            />
            {errors.email && <p style={{ color: "red" }}>{errors.email.message}</p>}
          </div>
          <div>
            <label>Password</label>
            <input
              type="password"
              {...register("password", {
                required: "Password is required",
                minLength: {
                  value: 6,
                  message: "Password must be at least 6 characters",
                },
              })}
            />
            {errors.password && <p style={{ color: "red" }}>{errors.password.message}</p>}
          </div>
          <button type="submit">Log In</button>

          <p>
            Don't have an account?{" "}
            <a href="#" onClick={(e) => { e.preventDefault(); navigate('/signup'); }}>
              Sign Up
            </a>
          </p>
        </form>

        <ToastContainer />
      </div>
    </>
  );
};

export default LogInForm;
