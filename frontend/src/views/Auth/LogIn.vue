<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">Login</v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.mdAndUp">
      <v-col xl="4" offset-xl="2">
        <v-card>
          <v-col cols="10" offset="1">
            <v-card-subtitle>アーティストの方</v-card-subtitle>
            <FormLogin :post-forms="logInBand" />
          </v-col>
        </v-card>
      </v-col>
      <v-col xl="4">
        <v-card>
          <v-col cols="10" offset="1">
            <v-card-subtitle>一般の方</v-card-subtitle>
            <FormLogin :post-forms="logInAudience" />
          </v-col>
        </v-card>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.smAndDown">
      <v-col sm="10" offset-sm="1">
        <v-card>
          <v-card-text>
            <v-tabs v-model="tabs" fixed-tabs>
              <v-tab>アーティストの方</v-tab>
              <v-tab>一般の方</v-tab>
            </v-tabs>
          </v-card-text>
          <v-col cols="10" offset="1">
            <v-tabs-items v-model="tabs">
              <v-tab-item>
                <FormLogin :post-forms="logInBand" />
              </v-tab-item>
              <v-tab-item>
                <FormLogin :post-forms="logInAudience" />
              </v-tab-item>
            </v-tabs-items>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import FormLogin from "@/components/Forms/FormLogin";

export default {
  components: {
    FormLogin,
  },
  data() {
    return {
      tabs: 0,
      formData: null,
    };
  },
  methods: {
    logInBand(email, password) {
      this.createFormData(email, password);
      this.$store.dispatch("loginBand", this.formData);
    },
    logInAudience(email, password) {
      this.createFormData(email, password);
      this.$store.dispatch("loginAudience", this.formData);
    },
    createFormData(email, password) {
      this.formData = new FormData();
      this.formData.append("email", email);
      this.formData.append("password", password);
    },
  },
};
</script>
