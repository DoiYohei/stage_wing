<template>
  <ValidationProvider name="場所" rules="max:50" v-slot="{ errors }">
    <v-text-field v-model="place" :error-messages="errors" label="場所" />
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
    place: {
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
