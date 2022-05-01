<template>
  <v-card-text>
    <v-textarea
      v-model="comment"
      :label="label"
      row-height="6"
      auto-grow
      dense
      hide-details
      outlined
    />
    <v-card-actions class="px-0">
      <v-spacer />
      <v-btn @click="submitForm" color="grey darken-3"><slot /></v-btn>
    </v-card-actions>
  </v-card-text>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      require: true,
    },
    label: {
      type: String,
      require: true,
    },
  },
  computed: {
    comment: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    submitForm() {
      this.$emit("submit-form");
    },
  },
};
</script>
