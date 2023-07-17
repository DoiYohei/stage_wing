<template>
  <v-card-text>
    <ValidationObserver v-slot="{ handleSubmit }">
      <ValidationProvider
        name="コメント"
        rules="max:1000|required"
        v-slot="{ errors }"
      >
        <v-textarea
          v-model="comment"
          :error-messages="errors"
          :label="label"
          row-height="6"
          auto-grow
          dense
          outlined
        />
        <v-card-actions class="pt-0 px-0">
          <v-spacer />
          <v-btn @click="handleSubmit(submitForm)" color="grey darken-3">
            {{ btnText }}
          </v-btn>
        </v-card-actions>
      </ValidationProvider>
    </ValidationObserver>
  </v-card-text>
</template>

<script>
import { ValidationObserver, ValidationProvider } from "vee-validate";

export default {
  components: {
    ValidationObserver,
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
    btnText: {
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
