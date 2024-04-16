import request from '@api/base-api';
import type {
  ApiResponse,
  ApiErrorResponse,
} from '@schemas/api/responses/base-response';
import type { UserIndexResponse } from '@schemas/api/requests/user-responses';
import type { UserResource } from '@schemas/api/resources/user-resources';
import type { UserUpdateRequest } from '@schemas/api/requests/user-requests';

export const userIndexApi = (): Promise<
  ApiResponse<UserIndexResponse> | ApiErrorResponse
> => {
  return request({
    url: `v1/users`,
    method: 'get',
  });
};

export const userRetrieveApi = (
  id: number,
): Promise<ApiResponse<UserResource> | ApiErrorResponse> => {
  return request({
    url: `v1/users/${id}`,
    method: 'get',
  });
};

export const userUpdateApi = (
  id: number,
  data: UserUpdateRequest,
): Promise<ApiResponse<UserResource> | ApiErrorResponse> => {
  return request({
    url: `v1/users/${id}`,
    method: 'put',
    data: data,
  });
};

export const userDestroyApi = (
  id: number,
): Promise<ApiResponse<null> | ApiErrorResponse> => {
  return request({
    url: `v1/users/${id}`,
    method: 'delete',
  });
};
