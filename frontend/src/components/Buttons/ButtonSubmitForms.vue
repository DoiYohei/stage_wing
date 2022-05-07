<template>
  <v-card-actions>
    <v-btn
      @click="submitForms"
      :disabled="invalid"
      color="grey darken-3"
      width="100%"
    >
      <slot />
    </v-btn>
  </v-card-actions>
</template>

<script>
export default {
  props: {
    invalid: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    submitForms() {
      this.$emit("submit-forms");
    },
  },
};
</script>
