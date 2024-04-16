<script lang="ts">
  import { userIndexApi } from '@api/user-api';
  import ValidateError from '@components/ValidateError.svelte';
  import ErrorMessage from '@components/messages/ErrorMessage.svelte';
  import Header from '@components/Header.svelte';
  import { onMount } from 'svelte';
  import { session } from '@stores/stores';

  let validationErrors = [];
  let errorMessage = '';
  let users = [];

  async function userIndex() {
    const result = await userIndexApi();
    if (!result.success) {
      if (result.status === 422) {
        validationErrors = result.data;
      }
      if (result.message !== "") {
        errorMessage = result.message;
      }
      return;
    }

    users = result.data.data;
  }

  onMount(async () => {
    await userIndex();
  });
</script>

{#if $session.isLogin}
  <Header />

  <div class="container">
    <h3 class="" id="title1">
      <small>ユーザー一覧</small>
    </h3>

    <div>
      <ErrorMessage message={errorMessage}/>

      <div class="row">
        {#each users as user}
          <div class="col-3">
            <div class="my-2">
              <div class="card">
                <div class="card-body">
                  <h5 class="card-title">{user.name}</h5>
                  <a href="/users/{user.id}" class="btn btn-primary">詳細を見る</a>
                </div>
              </div>
            </div>
          </div>
        {/each}
      </div>

      <ValidateError errors={validationErrors}/>
    </div>
  </div>

{/if}
