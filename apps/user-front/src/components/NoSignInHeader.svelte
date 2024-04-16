<script lang="ts">
  import {
    Collapse,
    NavbarToggler,
    NavbarBrand,
    Nav,
    Navbar,
    NavItem,
    NavLink,
    Dropdown,
    DropdownToggle,
    DropdownMenu,
    DropdownItem
  } from '@sveltestrap/sveltestrap';
  import {  urls } from '@config/settings';

  let isOpen = false;

  function handleUpdate(event) {
    isOpen = event.detail.isOpen;
  }


</script>

<Navbar color="light" light expand="md" container="md">
  <NavbarBrand href="/">{import.meta.env.VITE_APP_NAME}</NavbarBrand>
  <NavbarToggler on:click={() => (isOpen = !isOpen)} />
  <Collapse {isOpen} navbar expand="md" on:update={handleUpdate}>
    <Nav class="ms-auto" navbar>
      <!-- <NavItem>
        <NavLink href="#components/">Components</NavLink>
      </NavItem> -->
      <NavItem>
        <NavLink href="https://github.com/campbel2525/project-sample">GitHub</NavLink>
      </NavItem>
      <Dropdown nav inNavbar>
        <DropdownToggle nav caret>Menu</DropdownToggle>
        <DropdownMenu end>
          <DropdownItem>
            <a href="{urls.signUp}" class="link">sign up</a>
          </DropdownItem>
          <DropdownItem>
            <a href="{urls.signIn}" class="link">sign in</a>
          </DropdownItem>

          <!-- <DropdownItem>Option 2</DropdownItem>
          <DropdownItem divider />
          <DropdownItem>Reset</DropdownItem> -->
        </DropdownMenu>
      </Dropdown>
    </Nav>
  </Collapse>
</Navbar>

<style>
  .link {
    text-decoration: none;
    color: inherit;
  }
</style>
