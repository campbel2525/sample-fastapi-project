import axios from 'axios';

import type {
  ApiResponse,
  ApiErrorResponse,
} from '@schemas/api/base-api-schemas';

const service = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  timeout: 5000,
});

service.interceptors.request.use(
  (config) => {
    const accessToken = localStorage.getItem('access_token');
    if (accessToken !== undefined) {
      config.headers['Authorization'] = 'Bearer ' + accessToken;
    }
    return config;
  },
  (error) => {
    Promise.reject(error);
  },
);

service.interceptors.response.use(
  (response): ApiResponse<Record<string, unknown>> => {
    console.log(response);

    const resultData = {
      data: response.data,
      status: response.status,
      success: true,
      message: '',
    };
    if (response.data.message) {
      resultData.message = response.data.message ?? '';
    }
    return resultData;
  },
  (error): ApiErrorResponse => {
    const resultData = {
      data: null,
      status: error.response.status,
      success: false,
      message: '',
    };
    console.log(error);

    // if (resultData.status >= 500) {
    //   vm.$router.push({
    //     name: 'Error500'
    //   })
    // }
    if (error.response.status === 422 && error.response.data?.detail) {
      resultData.data = error.response.data?.detail;
      console.log(error.response.data);
    }
    if (error.response.data.message) {
      resultData.message = error.response.data.message ?? '';
    }
    return resultData;
  },
);

export default service;
