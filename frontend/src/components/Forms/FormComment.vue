<template>
  <v-card-text>
    <ValidationProvider
      name="コメント"
      rules="max: 1000|required"
      v-slot="{ errors }"
    >
      <v-textarea
        v-model="comment"
        :error-messages="errorMessage"
        :label="label"
        row-height="6"
        auto-grow
        dense
        outlined
      />
      <v-card-actions class="pt-0 px-0">
        <v-spacer />
        <v-btn @click="submitForm(errors)" color="grey darken-3">
          <slot />
        </v-btn>
      </v-card-actions>
    </ValidationProvider>
  </v-card-text>
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
  data() {
    return {
      errorMessage: "",
    };
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
    submitForm(errors) {
      if (errors.length) {
        return (this.errorMessage = errors);
      } else {
        this.errorMessage = "";
        this.$emit("submit-form");
      }
    },
  },
};
</script>
