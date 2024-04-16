import { writable } from 'svelte/store';

export const session = writable({
  meData: null,
  isLogin: false,
});
