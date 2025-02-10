import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3001',
  timeout: 10000,
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const SignUp =(payload)=>{
  return api.post('/signup',payload)
}

export const Login =(payload)=>{
  return api.post('/login',payload)
}

export const Organisation = (userId, payload) => {
  return api.post(`/api/v1/users/${userId}/organisations`, payload);
};

export const ShowOrganisation = (userId, payload) => {
  return api.get(`/api/v1/users/${userId}/organisations`, payload);
};