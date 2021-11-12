<template>
  <div>
    <h1>Log In</h1>
    <v-container>
      <v-row>
        <v-col md="2" offset-md="5">
          <div>Bandの方はこちら</div>
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="bandEmail" label="Email" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field
            v-model="bandPassword"
            :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
            :type="visible ? 'text' : 'password'"
            label="Password"
            hint="最低8文字です"
            counter
            @click:append="visible = !visible"
          />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="logInBand">Log In</v-btn>
        </v-col>
      </v-row>
      <v-row>
        <v-col md="2" offset-md="5">
          <div>一般の方はこちら</div>
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="audienceEmail" label="Email" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field
            v-model="audiencePassword"
            :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
            :type="visible ? 'text' : 'password'"
            label="Password"
            hint="最低8文字です"
            counter
            @click:append="visible = !visible"
          />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="logInAudience">Log In</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      bandEmail: "",
      bandPassword: "",
      audienceEmail: "",
      audiencePassword: "",
      visible: false,
    };
  },
  methods: {
    logInBand() {
      const formData = new FormData();
      formData.append("email", this.bandEmail);
      formData.append("password", this.bandPassword);
      this.$store.dispatch("loginBand", formData);
    },
    logInAudience() {
      const formData = new FormData();
      formData.append("email", this.audienceEmail);
      formData.append("password", this.audiencePassword);
      this.$store.dispatch("loginAudience", formData);
    },
  },
};
</script>
