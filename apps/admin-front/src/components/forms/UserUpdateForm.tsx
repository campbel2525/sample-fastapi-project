'use client'

import { Table, Tbody, Td, Tr, Checkbox, Input, Button } from '@chakra-ui/react'
import { Box } from '@chakra-ui/react'
import { useState } from 'react'
import React from 'react'

import { updateApi, destroyApi } from '@/api/user-api'
import ErrorMessage from '@/components/messages/ErrorMessage'
import ValidationErrorMessages from '@/components/messages/ValidationErrorMessages'
import type { User } from '@/types/models'
import type { UserUpdateRequest } from '@/types/requests/user-requests'
import type { validationErrorDetail } from '@/types/responses/base-responses'

type Props = {
  user: User
  onUpdateSuccessful: () => void
  onDestroySuccessful: () => void
}

export default function UserUpdateForm({
  user,
  onUpdateSuccessful,
  onDestroySuccessful,
}: Props) {
  const [errorMessage, setErrorMessage] = useState<string>('')
  const [validationErrors, setValidationErrors] = useState<validationErrorDetail[]>([])
  const [inputData, setInputData] = useState<UserUpdateRequest>({
    email: user.email,
    name: user.name,
    is_active: user.is_active,
    password: null,
  })

  const handle = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()

    const result = await updateApi(user.id, inputData)
    if (!result.success) {
      setValidationErrors(result.validationErrors ?? [])
      setErrorMessage(result.errorMessage || '')
      return
    }
    onUpdateSuccessful()
  }

  const handleUserDestroy = async () => {
    const result = await destroyApi(user.id)
    if (!result.success) {
      setValidationErrors(result.validationErrors ?? [])
      setErrorMessage(result.errorMessage || '')
      return
    }
    onDestroySuccessful()
  }

  return (
    <>
      {user && (
        <>
          <form onSubmit={handle}>
            <Table variant="simple">
              <Tbody>
                <Tr>
                  <Td>id</Td>
                  <Td>{user.id}</Td>
                </Tr>
                <Tr>
                  <Td>Email</Td>
                  <Td>
                    <Input
                      value={inputData.email}
                      onChange={(e) =>
                        setInputData({ ...inputData, email: e.target.value })
                      }
                    />
                  </Td>
                </Tr>
                <Tr>
                  <Td>名前</Td>
                  <Td>
                    <Input
                      value={inputData.name}
                      onChange={(e) =>
                        setInputData({ ...inputData, name: e.target.value })
                      }
                    />
                  </Td>
                </Tr>
                <Tr>
                  <Td>アクティブ状態</Td>
                  <Td>
                    <Checkbox
                      isChecked={inputData.is_active}
                      onChange={(e) =>
                        setInputData({ ...inputData, is_active: e.target.checked })
                      }
                    ></Checkbox>
                  </Td>
                </Tr>
                <Tr>
                  <Td>パスワード</Td>
                  <Td>
                    <Input
                      type="password"
                      value={inputData.password || ''}
                      onChange={(e) =>
                        setInputData({ ...inputData, password: e.target.value })
                      }
                    />
                  </Td>
                </Tr>
                <Tr>
                  <Td>作成日</Td>
                  <Td>{user.created_at}</Td>
                </Tr>
                <Tr>
                  <Td>更新日</Td>
                  <Td>{user.updated_at}</Td>
                </Tr>
              </Tbody>
            </Table>

            <Box
              p={8}
              maxWidth="400px"
              mx="auto"
              display="flex"
              justifyContent="center"
            >
              <Button width="full" mt={4} mr={2} type="submit">
                修正
              </Button>
              <Button
                width="full"
                mt={4}
                ml={2}
                type="button"
                onClick={handleUserDestroy}
              >
                削除
              </Button>
            </Box>
          </form>

          <Box p={8} maxWidth="400px">
            {validationErrors.length > 0 && (
              <ValidationErrorMessages validationErrors={validationErrors} />
            )}
            {errorMessage && <ErrorMessage message={errorMessage} />}
          </Box>
        </>
      )}
    </>
  )
}
