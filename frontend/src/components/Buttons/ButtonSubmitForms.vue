<template>
  <v-card-actions>
    <v-btn @click="submitForms" color="grey darken-3" block>
      {{ text }}
    </v-btn>
  </v-card-actions>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      require: true,
    },
  },
  methods: {
    submitForms() {
      this.$emit("submit-forms");
    },
  },
};
</script>
