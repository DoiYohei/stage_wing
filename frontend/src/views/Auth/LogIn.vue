<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="#121212" flat>
          <v-card-title class="pb-0">
            <v-spacer />
            LOGIN
            <v-spacer />
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.mdAndUp">
      <v-col xl="4" offset-xl="2">
        <FormLogin v-model="band" @submit-forms="logInBand">
          <template>アーティストの方</template>
        </FormLogin>
      </v-col>
      <v-col xl="4">
        <FormLogin v-model="audience" @submit-forms="logInAudience">
          <template>一般の方</template>
        </FormLogin>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.smAndDown">
      <v-col sm="8" offset-sm="2">
        <v-card>
          <v-card-text>
            <v-tabs v-model="tabs" fixed-tabs>
              <v-tab>アーティストの方</v-tab>
              <v-tab>一般の方</v-tab>
            </v-tabs>
            <v-tabs-items v-model="tabs">
              <v-tab-item>
                <FormLogin v-model="band" @submit-forms="logInBand" />
              </v-tab-item>
              <v-tab-item>
                <FormLogin v-model="audience" @submit-forms="logInAudience" />
              </v-tab-item>
            </v-tabs-items>
          </v-card-text>
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
      band: {
        email: "",
        password: "",
        visible: false,
        isError: false,
      },
      audience: {
        email: "",
        password: "",
        visible: false,
        isError: false,
      },
    };
  },
  methods: {
    async logInBand() {
      const formData = new FormData();
      formData.append("email", this.band.email);
      formData.append("password", this.band.password);
      const res = await this.$store.dispatch("loginBand", formData);
      if (!res) this.band.isError = true;
    },
    async logInAudience() {
      const formData = new FormData();
      formData.append("email", this.audience.email);
      formData.append("password", this.audience.password);
      const res = await this.$store.dispatch("loginAudience", formData);
      if (!res) this.audience.isError = true;
    },
  },
};
</script>
