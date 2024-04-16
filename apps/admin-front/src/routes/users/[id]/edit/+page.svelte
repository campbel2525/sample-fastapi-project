<script lang="ts">
  import { userRetrieveApi, userUpdateApi, userDestroyApi } from '@api/user-api';
  import ValidateError from '@components/ValidateError.svelte';
  import {urls } from '@config/settings';
  import { goto } from '$app/navigation';
  import ErrorMessage from '@components/messages/ErrorMessage.svelte';
  import Header from '@components/Header.svelte';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { session } from '@stores/stores';

  $: id = $page.params.id;

  let params = {
    email: null,
    password: null,
    is_active: null,
    name: null,
  };
  let validationErrors = [];
  let errorMessage = '';
  let user = null;

  async function userRetrieve() {
    const result = await userRetrieveApi(id);
    if (!result.success) {
      if (result.status === 422) {
        validationErrors = result.data;
      }
      if (result.message !== "") {
        errorMessage = result.message;
      }
      return;
    }

    user = result.data;
    params = {
      email: user.email,
      password: null,
      is_active: user.is_active,
      name: user.name,
    };
  }

  onMount(async () => {
    await userRetrieve();
  });

  async function userUpdate() {
    const result = await userUpdateApi(id, params);
    if (!result.success) {
      if (result.status === 422) {
        validationErrors = result.data;
      }
      if (result.message !== "") {
        errorMessage = result.message;
      }
      return;
    }
  }

  async function userDestroy() {
    const result = await userDestroyApi(id);
    if (!result.success) {
      if (result.status === 422) {
        validationErrors = result.data;
      }
      if (result.message !== "") {
        errorMessage = result.message;
      }
      return;
    }

    goto(urls.users);
  }
</script>

{#if $session.isLogin}

  <Header />

  <div class="container">
    <h3 class="" id="title1">
      <small>ユーザー詳細</small>
    </h3>

    <div>
      <ErrorMessage message={errorMessage}/>

      {#if user !== null}
        <table class="table">
          <tbody>
            <tr>
              <th>id</th>
              <td>{user.id}</td>
            </tr>
            <tr>
              <th>email</th>
              <td>
                <input type="email" class="form-control" id="input-email" placeholder="name@example.com" bind:value={params.email}>
              </td>
            </tr>
            <tr>
              <th>password 更新する場合のみ入力</th>
              <td>
                <input type="password" class="form-control" id="input-password" placeholder="pasword" bind:value={params.password}>
              </td>
            </tr>
            <tr>
              <th>is_active</th>
              <td>
                <input class="form-check-input" type="checkbox" id="input-is_active" bind:checked={params.is_active}>
                <!-- <label class="form-check-label" for="flexCheckIndeterminate">
                  Indeterminate checkbox
                </label> -->
              </td>
            </tr>
            <tr>
              <th>name</th>
              <td>
                <input type="text" class="form-control" id="input-name" placeholder="campbel" bind:value={params.name}>
              </td>
            </tr>
            <tr>
              <th>created_at</th>
              <td>{user.created_at}</td>
            </tr>
            <tr>
              <th>updated_at</th>
              <td>{user.updated_at}</td>
            </tr>
          </tbody>
        </table>
        <div class=text-center>
          <button class="btn btn-primary" on:click={userUpdate}>編集する</button>
          <button class="btn btn-sm btn-danger" on:click={userDestroy}>削除する</button>
        </div>
      {/if}

      <ValidateError errors={validationErrors}/>
    </div>
  </div>
{/if}
