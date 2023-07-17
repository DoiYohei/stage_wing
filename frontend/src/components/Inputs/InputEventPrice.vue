<template>
  <ValidationProvider name="チケット料金" rules="integer" v-slot="{ errors }">
    <v-text-field
      v-model="price"
      :error-messages="errors"
      label="チケット料金（半角数字）"
      prefix="¥"
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
      type: [Number, String],
      require: true,
    },
  },
  computed: {
    price: {
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
