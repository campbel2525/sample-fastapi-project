'use client'

import { FormControl, FormLabel, Input, Button } from '@chakra-ui/react'
import { Box } from '@chakra-ui/react'
import { useState } from 'react'
import React from 'react'

import { loginApi } from '@/api/account-api'
import ErrorMessage from '@/components/messages/ErrorMessage'
import ValidationErrorMessages from '@/components/messages/ValidationErrorMessages'
import type { LoginRequest } from '@/types/requests/account-requests'
import type { validationErrorDetail } from '@/types/responses/base-responses'

type Props = {
  // eslint-disable-next-line no-unused-vars
  onSuccessful: (accessToken: string, refreshToken: string) => void
}

export default function LoginForm({ onSuccessful }: Props) {
  const [errorMessage, setErrorMessage] = useState<string>('')
  const [validationErrors, setValidationErrors] = useState<validationErrorDetail[]>([])
  const [inputData, setInputData] = useState<LoginRequest>({
    email: '',
    password: '',
  })

  const handle = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    const result = await loginApi(inputData)
    if (!result.success) {
      setValidationErrors(result.validationErrors ?? [])
      setErrorMessage(result.errorMessage || '')
      return
    }

    if (result.data) {
      onSuccessful(result.data.access_token, result.data.refresh_token)
    }
  }

  return (
    <Box p={8} maxWidth="100%" width="100%">
      <p>sample user</p>
      <p>user1@example.com</p>
      <p>test1234</p>

      <Box maxWidth="100%">
        <form onSubmit={handle}>
          <FormControl id="email">
            <FormLabel htmlFor="email">Email</FormLabel>
            <Input
              type="email"
              value={inputData.email}
              onChange={(e) => setInputData({ ...inputData, email: e.target.value })}
            />
          </FormControl>
          <FormControl id="password">
            <FormLabel htmlFor="password">Password</FormLabel>
            <Input
              type="password"
              value={inputData.password}
              onChange={(e) => setInputData({ ...inputData, password: e.target.value })}
            />
          </FormControl>
          <Button width="full" mt={4} type="submit">
            ログイン
          </Button>
        </form>
      </Box>

      <Box p={8} maxWidth="400px">
        {validationErrors.length > 0 && (
          <ValidationErrorMessages validationErrors={validationErrors} />
        )}
        {errorMessage && <ErrorMessage message={errorMessage} />}
      </Box>
    </Box>
  )
}
