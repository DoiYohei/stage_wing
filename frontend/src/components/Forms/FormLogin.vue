<template>
  <v-card flat>
    <v-card-text>
      <v-text-field v-model="email" label="Email" />
    </v-card-text>
    <v-card-text>
      <v-text-field
        v-model="password"
        :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
        :type="visible ? 'text' : 'password'"
        label="Password"
        hint="最低8文字です"
        counter
        @click:append="visible = !visible"
      />
    </v-card-text>
    <v-card-text>
      <v-btn @click="submitForms">Log In</v-btn>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  props: {
    postForms: {
      type: Function,
      require: true,
    },
  },
  data() {
    return {
      email: "",
      password: "",
      visible: false,
    };
  },
  methods: {
    submitForms() {
      this.postForms(this.email, this.password);
    },
  },
};
</script>
