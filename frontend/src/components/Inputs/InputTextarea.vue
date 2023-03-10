<template>
  <ValidationProvider :name="label" :rules="`max:${max}`" v-slot="{ errors }">
    <v-textarea
      v-model="content"
      :error-messages="errors"
      :label="label"
      background-color="grey darken-4"
      auto-grow
      outlined
    />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider } from "vee-validate";

export default {
  components: {
    ValidationProvider,
  },
  props: {
    value: {
      type: String,
      require: true,
    },
    label: {
      type: String,
      require: true,
    },
    max: {
      type: String,
      require: true,
    },
  },
  computed: {
    content: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
};
</script>
