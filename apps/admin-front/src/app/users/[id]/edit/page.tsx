'use client'

import { Box } from '@chakra-ui/react'
import { useParams } from 'next/navigation'
import { useRouter } from 'next/navigation'
import React, { useEffect, useState } from 'react'

import { retrieveApi } from '@/api/user-api'
import UserUpdateForm from '@/components/forms/UserUpdateForm'
import Loading from '@/components/Loading'
import ErrorMessage from '@/components/messages/ErrorMessage'
import ValidationErrorMessages from '@/components/messages/ValidationErrorMessages'
import { frontPaths } from '@/config/settings'
import type { User } from '@/types/models'
import type { ApiResponse } from '@/types/responses/base-responses'
import type { validationErrorDetail } from '@/types/responses/base-responses'
import { loginCheck } from '@/utils/auth'

export default function UserUpdatePage() {
  const router = useRouter()
  const params = useParams()
  const id = params.id

  const [errorMessage, setErrorMessage] = useState<string>('')
  const [validationErrors, setValidationErrors] = useState<validationErrorDetail[]>([])
  const [result, setResult] = useState<ApiResponse<User>>()

  const fetchData = async (id: number) => {
    const result = await retrieveApi(id)
    setValidationErrors(result.validationErrors ?? [])
    setErrorMessage(result.errorMessage || '')
    setResult(result)
  }

  useEffect(() => {
    const performAsyncOperations = async () => {
      await loginCheck(router)
      if (id) {
        await fetchData(Number(id))
      }
    }

    performAsyncOperations()
  }, [id, router])

  const onUpdateSuccessful = (): void => {
    router.push(`${frontPaths.users}/${id}`)
  }

  const onDestroySuccessful = (): void => {
    router.push(`${frontPaths.users}`)
  }

  if (!result) {
    return <Loading />
  }

  return (
    <>
      {result?.data && (
        <UserUpdateForm
          user={result.data}
          onUpdateSuccessful={onUpdateSuccessful}
          onDestroySuccessful={onDestroySuccessful}
        />
      )}

      <Box p={8} maxWidth="400px">
        {validationErrors.length > 0 && (
          <ValidationErrorMessages validationErrors={validationErrors} />
        )}
        {errorMessage && <ErrorMessage message={errorMessage} />}
      </Box>
    </>
  )
}
