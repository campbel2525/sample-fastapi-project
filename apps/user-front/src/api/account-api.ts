import request from '@api/base-api';
import type {
  ApiResponse,
  ApiErrorResponse,
} from '@schemas/api/responses/base-response';
import type {
  AccountSignUpRequest,
  AccountSignInRequest,
} from '@schemas/api/requests/account-requests';
import type { TokenResponse } from '@schemas/api/requests/account-responses';

export const accountSignInApi = (
  data: AccountSignInRequest,
): Promise<ApiResponse<TokenResponse> | ApiErrorResponse> => {
  return request({
    url: `v1/accounts/sign-in`,
    method: 'post',
    data: data,
  });
};

export const accountSignUpApi = (
  data: AccountSignUpRequest,
): Promise<ApiResponse<TokenResponse> | ApiErrorResponse> => {
  return request({
    url: `v1/accounts/sign-up`,
    method: 'post',
    data: data,
  });
};

export const accountMeApi = (): Promise<
  ApiResponse<TokenResponse> | ApiErrorResponse
> => {
  return request({
    url: `v1/accounts/me`,
    method: 'get',
  });
};
