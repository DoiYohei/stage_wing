<template>
  <v-footer
    color="transparent"
    padless
    :absolute="$route.path === '/' && $vuetify.breakpoint.mdAndUp"
    class="text-center grey--text text--lighten-1"
  >
    <v-col cols="12">{{ new Date().getFullYear() }}. Stage Wing</v-col>
  </v-footer>
</template>
