export type ApiResponse<T> = {
  data: null | T
  validationErrors: null | validationErrorDetail[]
  success: boolean
  message: string
  errorMessage: string
  status: number
}

export type validationErrorDetail = {
  type: string
  loc: string[]
  msg: string
  input: Record<string, unknown>
  url: string
}
