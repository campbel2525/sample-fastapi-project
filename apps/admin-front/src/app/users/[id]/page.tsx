'use client'

import { Box } from '@chakra-ui/react'
import { Table, Tbody, Td, Tr } from '@chakra-ui/react'
import { Button } from '@chakra-ui/react'
import { useParams } from 'next/navigation'
import { useRouter } from 'next/navigation'
import React, { useEffect, useState } from 'react'

import { retrieveApi } from '@/api/user-api'
import Loading from '@/components/Loading'
import ErrorMessage from '@/components/messages/ErrorMessage'
import ValidationErrorMessages from '@/components/messages/ValidationErrorMessages'
import { frontPaths } from '@/config/settings'
import type { User } from '@/types/models'
import type { ApiResponse } from '@/types/responses/base-responses'
import type { validationErrorDetail } from '@/types/responses/base-responses'
import { loginCheck } from '@/utils/auth'

export default function UserDetailPage() {
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

  if (!result) {
    return <Loading />
  }

  return (
    <>
      {result.data && (
        <>
          <Table variant="simple">
            <Tbody>
              <Tr>
                <Td>id</Td>
                <Td>{result.data.id}</Td>
              </Tr>
              <Tr>
                <Td>Email</Td>
                <Td>{result.data.email}</Td>
              </Tr>
              <Tr>
                <Td>名前</Td>
                <Td>{result.data.name}</Td>
              </Tr>
              <Tr>
                <Td>アクティブ状態</Td>
                <Td>{result.data.is_active ? '有効' : '無効'}</Td>
              </Tr>
              <Tr>
                <Td>作成日</Td>
                <Td>{result.data.created_at}</Td>
              </Tr>
              <Tr>
                <Td>更新日</Td>
                <Td>{result.data.updated_at}</Td>
              </Tr>
            </Tbody>
          </Table>

          <Box p={8} maxWidth="400px" mx="auto" display="flex" justifyContent="center">
            <Button
              colorScheme="blue"
              onClick={() => {
                if (result.data) {
                  router.push(`${frontPaths.users}/${result.data.id}/edit`)
                }
              }}
            >
              編集へ
            </Button>
          </Box>
        </>
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
