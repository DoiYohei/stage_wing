<template>
  <div>
    <h1>Log In</h1>
    <v-container>
      <v-row>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="email" label="Email" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field
            v-model="password"
            :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
            :type="visible ? 'text' : 'password'"
            label="Password"
            hint="最低8文字です"
            counter
            @click:append="visible = !visible"
          />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="logIn">Log In</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: "",
      password: "",
      visible: false,
    };
  },
  methods: {
    logIn() {
      const formData = new FormData();
      formData.append("email", this.email);
      formData.append("password", this.password);
      this.$store.dispatch("login", formData);
    },
  },
};
</script>
