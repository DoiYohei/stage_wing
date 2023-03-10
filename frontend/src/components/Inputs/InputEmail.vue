<template>
  <ValidationProvider name="Email" rules="email|required" v-slot="{ errors }">
    <v-text-field
      v-model="email"
      :error-messages="errors"
      label="Email（必須）"
      prefix="*"
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
  },
  computed: {
    email: {
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
