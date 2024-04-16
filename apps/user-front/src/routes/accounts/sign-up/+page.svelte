<script lang="ts">
  import {accountSignUpApi} from '@api/account-api';
  import ValidateError from '@components/ValidateError.svelte';
  import ErrorMessage from '@components/messages/ErrorMessage.svelte';
  import { localStorageKey, urls } from '@config/settings';
  import { goto } from '$app/navigation';
  import { session } from '@stores/stores';

  let params = {
    email: '',
    password: '',
    name: '',
  };
  let validationErrors = [];
  let errorMessage = '';

  async function login() {
    const result = await accountSignUpApi(params);
    if (!result.success) {
      if (result.status === 422) {
        validationErrors = result.data;
      }
      if (result.message !== "") {
        errorMessage = result.message;
      }
      return;
    }
    localStorage.setItem(localStorageKey.accessToken, result.data.access_token);
    localStorage.setItem(localStorageKey.refreshToken, result.data.refresh_token);
    goto(urls.home);
  }

</script>

{#if !session.isLogin}

  <div class="container">
    <h2 class="text-center" id="title1">
      <img src="/favicon.png" alt="logo">
    </h2>
    <h3 class="text-center" id="title2">
      {import.meta.env.VITE_APP_NAME}
    </h3>

    <h3 class="text-center" id="title2">
      <small>sign up</small>
    </h3>

    <ErrorMessage message={errorMessage}/>

    <div>
      <!-- <div class="mb-3 w-75 mx-auto">
        sample account<br>
        email: user1@example.com<br>
        password: test1234
      </div> -->

      <div class="mb-3 w-75 mx-auto">
        <label for="input1" class="form-label">Email address</label>
        <input type="email" class="form-control" id="input1" placeholder="name@example.com" bind:value={params.email}>
      </div>
      <div class="mb-3 w-75 mx-auto">
        <label for="input2" class="form-label">password</label>
        <input type="password" class="form-control" id="input2" placeholder="password" bind:value={params.password}>
      </div>
      <div class="mb-3 w-75 mx-auto">
        <label for="input3" class="form-label">name</label>
        <input type="text" class="form-control" id="input3" placeholder="campbel" bind:value={params.name}>
      </div>

      <ValidateError errors={validationErrors}/>

      <div class="text-center">
        <button type="button" class="btn btn-primary" on:click={login}>
          Sign Up
        </button>
        <a href="{urls.signIn}" type="button" class="btn btn-sm btn-primary">Click here for sign in page</a>
      </div>
    </div>
  </div>
{/if}
