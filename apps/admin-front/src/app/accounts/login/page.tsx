'use client'

import { Box } from '@chakra-ui/react'
import { useRouter } from 'next/navigation'

import LoginForm from '@/components/forms/LoginForm'
import { localStorageKeys, frontPaths } from '@/config/settings'

export default function LoginPage() {
  const router = useRouter()

  const onSuccessful = (accessToken: string, refreshToken: string): void => {
    localStorage.setItem(localStorageKeys.accessToken, accessToken)
    localStorage.setItem(localStorageKeys.refreshToken, refreshToken)
    router.push(frontPaths.home)
  }

  return (
    <Box mx="auto" width="100%" maxWidth="500px">
      <LoginForm onSuccessful={onSuccessful} />
    </Box>
  )
}
