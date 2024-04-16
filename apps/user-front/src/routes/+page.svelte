<script lang="ts">
  import Header from '@components/Header.svelte';
  import NoSignInHeader from '@components/NoSignInHeader.svelte';
  import { session } from '@stores/stores';
  import { urls } from '@config/settings';
</script>

{#if $session.isLogin}
  <Header />
{:else}
  <NoSignInHeader />
{/if}

<div class="container">

  <div class=mt-5>
    <p>このページはユーザー画面です</p>
    <p>サーバーは fastapi、フロントは svelte の spa でユーザー管理アプリを作ってみました</p>
    <p>ユーザー管理はどんなプロジェクトでも使用すると思うので何なにかプロジェクトを作る際にはこのリポジトリを参考にしてみてください</p>
    <p>サンプルのため最低限の機能になります</p>
    <p>
      <a href="https://github.com/campbel2525/project-sample" target="_blank">詳しくはこちら</a>
    </p>
    <p>
      <a href="{urls.signUp}">ユーザー画面はこちら</a>
    </p>
    <p>
      <a href="{urls.signUp}">sign up</a>
    </p>
    <p>
      <a href="{urls.signIn}">sign in</a>
    </p>
  </div>

  <div class=mt-5>
    <p>This page is a user screen</p>
    <p>I created a user management app using spa with fastapi as the server and svelte as the front.</p>
    <p>I think user management will be used in any project, so please refer to this repository when creating a project.</p>
    <p>Since it is a sample, it will have the minimum functionality.</p>
    <p>
      <a href="https://github.com/campbel2525/project-sample" target="_blank">Click here for details</a>
    </p>
    <p>
      <a href="{urls.signUp}">sign up</a>
    </p>
    <p>
      <a href="{urls.signIn}">sign in</a>
    </p>
  </div>
</div>
