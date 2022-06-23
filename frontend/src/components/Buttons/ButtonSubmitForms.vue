<template>
  <v-card-actions>
    <v-btn @click="submitForms" color="grey darken-3" block>
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
