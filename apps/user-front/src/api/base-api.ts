import type { AxiosResponse, AxiosError } from 'axios'
import axios from 'axios'

import { localStorageKeys } from '@/config/settings'
import type { ApiResponse } from '@/types/responses/base-responses'

const service = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 5000,
})

service.interceptors.request.use(
  (config) => {
    config.headers = config.headers || {}
    const accessToken = localStorage.getItem(localStorageKeys.accessToken)
    if (accessToken !== undefined) {
      config.headers['Authorization'] = 'Bearer ' + accessToken
    }
    return config
  },
  (error: AxiosError) => {
    Promise.reject(error)
  }
)

service.interceptors.response.use(
  (response): AxiosResponse<ApiResponse<Record<string, unknown>>> => {
    // eslint-disable-next-line no-console
    console.log(response)

    const data = {
      data: response.data,
      validationErrors: null,
      status: response.status,
      success: true,
      message: '',
      errorMessage: '',
    }
    if (response.data.message) {
      data.message = response.data.message ?? ''
    }

    return {
      data,
      status: response.status,
      statusText: response.statusText,
      headers: response.headers,
      config: response.config,
    }
  },
  (error): AxiosResponse<ApiResponse<null>> => {
    // eslint-disable-next-line no-console
    console.log(error)

    if (error.response === undefined) {
      const data = {
        data: null,
        validationErrors: null,
        status: 0,
        success: false,
        message: '',
        errorMessage: '',
      }
      return {
        data: data,
        status: data.status,
        statusText: 'Error',
        headers: {},
        config: error.config || { headers: {} },
      }
    }

    const data = {
      data: null,
      validationErrors: null,
      status: error.response.status,
      success: false,
      message: '',
      errorMessage: '',
    }

    if (error.response.status === 422 && error.response.data?.detail) {
      data.validationErrors = error.response.data?.detail
    }

    if (error.response.data.message) {
      data.message = error.response.data.message ?? ''
    }

    return {
      data: data,
      status: error.response.status,
      statusText: error.response.statusText,
      headers: error.response.headers,
      config: error.config,
    }
  }
)

export default service
