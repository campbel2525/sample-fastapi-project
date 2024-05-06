import type { User } from '@/types/models'

// accounts
export type TokenResponse = {
  access_token: string
  refresh_token: string
}

export type AccountMeResponse = User
