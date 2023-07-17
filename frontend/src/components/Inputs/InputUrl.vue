<template>
  <ValidationProvider
    :name="label"
    :rules="{
      regex: /https?:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/,
    }"
    v-slot="{ errors }"
  >
    <v-text-field v-model="url" :error-messages="errors" :label="label" />
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
  },
  computed: {
    url: {
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
