<script lang="ts">
  import { userRetrieveApi } from '@api/user-api';
  import ValidateError from '@components/ValidateError.svelte';
  import ErrorMessage from '@components/messages/ErrorMessage.svelte';
  import Header from '@components/Header.svelte';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { session } from '@stores/stores';

  $: id = $page.params.id;

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
  }

  onMount(async () => {
    await userRetrieve();
  });
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
              <td>{user.email}</td>
            </tr>
            <tr>
              <th>is_active</th>
              <td>{user.is_active}</td>
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
          <a href="/users/{user.id}/edit" class="btn btn-primary">修正ページへ</a>
        </div>
      {/if}

      <ValidateError errors={validationErrors}/>
    </div>
  </div>
{/if}
