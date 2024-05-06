'use client'

import { Flex, Spinner } from '@chakra-ui/react'

function Loading() {
  return (
    <Flex height="100vh" alignItems="center" justifyContent="center">
      <Spinner size="xl" color="blue.500" />
    </Flex>
  )
}

export default Loading
