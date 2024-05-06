import request from '@/api/base-api'
import type { User } from '@/types/models'
import type { UserUpdateRequest } from '@/types/requests/user-requests'
import type { ApiResponse } from '@/types/responses/base-responses'
import type { UserIndexResponse } from '@/types/responses/user-responses'

export const indexApi = async (): Promise<ApiResponse<UserIndexResponse>> => {
  try {
    const result = await request({
      url: `v1/users`,
      method: 'get',
    })
    return result.data
  } catch (error) {
    return Promise.reject({
      message: 'API request failed',
      error: error,
    })
  }
}

export const retrieveApi = async (id: number): Promise<ApiResponse<User>> => {
  try {
    const result = await request({
      url: `v1/users/${id}`,
      method: 'get',
    })
    return result.data
  } catch (error) {
    return Promise.reject({
      message: 'API request failed',
      error: error,
    })
  }
}

export const updateApi = async (
  id: number,
  data: UserUpdateRequest
): Promise<ApiResponse<User>> => {
  try {
    const result = await request({
      url: `v1/users/${id}`,
      method: 'put',
      data: data,
    })
    return result.data
  } catch (error) {
    return Promise.reject({
      message: 'API request failed',
      error: error,
    })
  }
}

export const destroyApi = async (id: number): Promise<ApiResponse<null>> => {
  try {
    const result = await request({
      url: `v1/users/${id}`,
      method: 'delete',
    })
    return result.data
  } catch (error) {
    return Promise.reject({
      message: 'API request failed',
      error: error,
    })
  }
}
