<script lang="ts">
  export let message = '';
</script>

{#if message}
  <div class="alert alert-danger" role="alert">
    {message}
  </div>
{/if}
