import { useRouter } from 'next/navigation'

import { meApi, refreshTokenApi } from '@/api/account-api'
import { localStorageKeys, loginPagePath } from '@/config/settings'

export const loginCheck = async (
  router: ReturnType<typeof useRouter>
): Promise<void> => {
  const accountMeResult = await meApi()
  if (accountMeResult.success) {
    return
  }

  const accountRefreshResult = await refreshTokenApi()
  if (
    accountRefreshResult.data?.access_token &&
    accountRefreshResult.data?.refresh_token
  ) {
    localStorage.setItem(
      localStorageKeys.accessToken,
      accountRefreshResult.data.access_token
    )
    localStorage.setItem(
      localStorageKeys.refreshToken,
      accountRefreshResult.data.refresh_token
    )

    return
  }

  localStorage.removeItem(localStorageKeys.accessToken)
  localStorage.removeItem(localStorageKeys.refreshToken)
  router.push(loginPagePath)
}
