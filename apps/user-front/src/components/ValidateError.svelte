<script lang="ts">
  export let errors = [];
</script>

{#each errors as error}
  <div class="alert alert-danger" role="alert">
    {error.loc[1]}: {error.msg}
  </div>
{/each}
