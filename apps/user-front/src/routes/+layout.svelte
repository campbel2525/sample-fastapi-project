<script lang="ts">
  import { accountMeApi } from '@api/account-api';
  import { goto } from '$app/navigation';
  import { localStorageKey } from '@config/settings';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { session } from '@stores/stores';
  import { urls, NO_SIGN_IN_CHECK_URLS } from '@config/settings';

  onMount(async () => {
    const pathname = $page.url.pathname;
    const accessToken = localStorage.getItem(localStorageKey.accessToken);
    if (!accessToken) {
      session.set({ meData: null, isLogin: false });
      localStorage.removeItem(localStorageKey.accessToken);
      localStorage.removeItem(localStorageKey.refreshToken);

      if (pathname !== urls.signUp && pathname !== urls.signIn) {
        if (!NO_SIGN_IN_CHECK_URLS.includes(pathname)) {
          goto(urls.signIn);
        }
      }
      return;
    }

    const result = await accountMeApi();
    if (!result.success) {
      session.set({ meData: null, isLogin: false });
      localStorage.removeItem(localStorageKey.accessToken);
      localStorage.removeItem(localStorageKey.refreshToken);

      if (!NO_SIGN_IN_CHECK_URLS.includes(pathname)) {
        goto(urls.signIn);
      }
    } else {
      session.set({ meData: result.data, isLogin: true});
      if (pathname === urls.signUp || pathname === urls.signIn) {
        goto(urls.home);
      }
    }
  });
</script>

<slot />
