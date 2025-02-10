import React from 'react';
import './signup.css';
import { useForm } from 'react-hook-form';
import { SignUp } from '../apiurls/service';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { useNavigate } from 'react-router-dom';
import img2 from '../../assets/images/img2.jpg';
import img5 from '../../assets/images/img5.jpg';


const SignupForm = () => {
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
        name: data.name,
      },
    };

    try {
      const response = await SignUp(payload);
      if (response.status === 200) {
        localStorage.setItem('authToken', response.token);
        toast.success('Signed up successfully!');
        navigate('/');
      }
    } catch (err) {
      toast.error('Email has already been taken.');
    }
  };

  return (
    <div className="signup-page" style={{ backgroundImage: `url(${img5})` }}>
      <form onSubmit={handleSubmit(onSubmit)} className="signup-form" style={{ backgroundImage: `url(${img2})` }}>
        <h2>Sign Up</h2>
        <div>
          <label>Name</label>
          <input type="text" {...register('name', { required: 'Name is required' })} />
          {errors.name && <p className="error">{errors.name.message}</p>}
        </div>
        <div>
          <label>Email</label>
          <input
            type="email"
            {...register('email', {
              required: 'Email is required',
            })}
          />
          {errors.email && <p className="error">{errors.email.message}</p>}
        </div>
        <div>
          <label>Password</label>
          <input
            type="password"
            {...register('password', { required: 'Password is required' })}
          />
          {errors.password && <p className="error">{errors.password.message}</p>}
        </div>
        <button type="submit">Sign Up</button>
        <p>
          Already have an account?{" "}
          <a href="#" onClick={(e) => { e.preventDefault(); navigate('/login'); }}>
            Log In
          </a>
        </p>
      </form>
      <ToastContainer />
    </div>
  );
};

export default SignupForm;
