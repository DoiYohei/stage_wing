<template>
  <v-card-actions>
    <v-btn color="grey darken-3" width="100%" @click="submitForms">
      <slot />
    </v-btn>
  </v-card-actions>
</template>

<script>
export default {
  methods: {
    submitForms() {
      this.$emit("submit-forms");
    },
  },
};
</script>
