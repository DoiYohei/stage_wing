<template>
  <ValidationProvider
    name="Password"
    rules="max:128|min:8|required"
    v-slot="{ errors }"
  >
    <v-text-field
      v-model="password"
      :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
      :error-messages="errors"
      :type="visible ? 'text' : 'password'"
      hint="最低8文字です"
      label="Password（必須）"
      prefix="*"
      counter
      @click:append="visible = !visible"
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
  data() {
    return {
      visible: false,
    };
  },
  computed: {
    password: {
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
