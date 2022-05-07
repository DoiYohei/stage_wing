<template>
  <v-card>
    <v-col md="10" offset-md="1">
      <v-card flat>
        <v-card-subtitle
          v-if="$vuetify.breakpoint.mdAndUp"
          class="text-center white--text"
        >
          <slot />
        </v-card-subtitle>
        <v-card-text>
          <v-text-field v-model="user.email" label="Email" />
          <v-text-field
            v-model="user.password"
            :append-icon="user.visible ? 'mdi-eye' : 'mdi-eye-off'"
            :type="user.visible ? 'text' : 'password'"
            label="Password"
            @click:append="user.visible = !user.visible"
          />
          <v-alert
            :value="user.isError"
            type="error"
            dense
            outlined
            class="mt-5 mb-1"
          >
            Email または Password が違います
          </v-alert>
        </v-card-text>
        <ButtonSubmitForms @submit-forms="submitForms">
          Log In
        </ButtonSubmitForms>
      </v-card>
    </v-col>
  </v-card>
</template>

<script>
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ButtonSubmitForms,
  },
  props: {
    value: {
      type: Object,
      require: true,
    },
  },
  computed: {
    user: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    submitForms() {
      this.$emit("submit-forms");
    },
  },
};
</script>
