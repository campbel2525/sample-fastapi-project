export type ApiResponse<T> = {
  data: T;
  status: number;
  success: boolean;
  message: string;
};

export type ApiErrorResponse = {
  data: null | __ValidationError;
  status: number;
  success: boolean;
  message: string;
};

type __ValidationError = {
  type: string;
  loc: string[];
  msg: string;
  input: Record<string, unknown>;
  url: string;
};
