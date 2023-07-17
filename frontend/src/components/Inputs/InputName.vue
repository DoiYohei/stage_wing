<template>
  <ValidationProvider
    :name="label"
    :rules="`max:${max}|required`"
    v-slot="{ errors }"
  >
    <v-text-field
      v-model="name"
      :error-messages="errors"
      :label="`${label}（必須）`"
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
    name: {
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
