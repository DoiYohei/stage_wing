<template>
  <v-container>
    <CardPageTitle :title="pageTitle" />
    <v-row v-if="$vuetify.breakpoint.mdAndUp">
      <v-col xl="4" offset-xl="2">
        <FormAuth v-model="band" @submit-forms="submitBand">
          <template #card-title>
            <v-card-subtitle class="text-center">
              {{ band.cardTitle }}
            </v-card-subtitle>
          </template>
          <template #btn-text>{{ btnText }}</template>
        </FormAuth>
      </v-col>
      <v-col xl="4">
        <FormAuth v-model="audience" @submit-forms="submitAudience">
          <template #card-title>
            <v-card-subtitle class="text-center">
              {{ audience.cardTitle }}
            </v-card-subtitle>
          </template>
          <template #btn-text>{{ btnText }}</template>
        </FormAuth>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.smAndDown">
      <v-col sm="8" offset-sm="2">
        <v-card>
          <v-card-text>
            <v-tabs v-model="tabs" fixed-tabs>
              <v-tab>{{ band.cardTitle }}</v-tab>
              <v-tab>{{ audience.cardTitle }}</v-tab>
            </v-tabs>
            <v-tabs-items v-model="tabs">
              <v-tab-item>
                <FormAuth v-model="band" @submit-forms="submitBand">
                  <template #btn-text>{{ btnText }}</template>
                </FormAuth>
              </v-tab-item>
              <v-tab-item>
                <FormAuth v-model="audience" @submit-forms="submitAudience">
                  <template #btn-text>{{ btnText }}</template>
                </FormAuth>
              </v-tab-item>
            </v-tabs-items>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import FormAuth from "@/components/Forms/FormAuth";

export default {
  components: {
    CardPageTitle,
    FormAuth,
  },
  data() {
    return {
      tabs: 0,
      band: {
        image: require("@/assets/img/no-band-img.jpg"),
        inputImage: null,
        name: "",
        email: "",
        password: "",
        cardTitle: "アーティストの方",
        nameLabel: "Band Name",
        isError: false,
        errorMessage: "",
      },
      audience: {
        image: require("@/assets/img/no-audience-img.jpeg"),
        inputImage: null,
        name: "",
        email: "",
        password: "",
        cardTitle: "一般の方",
        nameLabel: "Name",
        isError: false,
        errorMessage: "",
      },
    };
  },
  computed: {
    pageTitle() {
      return this.$route.name === "Signup" ? "アカウント作成" : "ログイン";
    },
    errorText() {
      return `${this.pageTitle}できませんでした。`;
    },
    btnText() {
      return this.$route.name == "Signup" ? "Sign Up" : "Log In";
    },
  },
  methods: {
    async submitBand() {
      try {
        let res;
        const formData = new FormData();
        formData.append("email", this.band.email);
        formData.append("password", this.band.password);
        if (this.$route.name === "Signup") {
          formData.append("name", this.band.name);
          formData.append("image", this.band.inputImage);
          formData.append("profile", this.band.profile);
          formData.append("website", this.band.website);
          formData.append("twitter", this.band.twitter);
          res = await this.$axios.post("/bands", formData);
        } else {
          res = await this.$axios.post("/bands/sign_in", formData);
        }
        const userType = "bands";
        this.$store.dispatch("setAuthData", { res, userType });
      } catch (error) {
        if (error.response) this.band.isError = true;
        this.band.errorMessage = this.errorText;
      }
    },
    async submitAudience() {
      let res;
      const formData = new FormData();
      formData.append("email", this.audience.email);
      formData.append("password", this.audience.password);
      try {
        if (this.$route.name === "Signup") {
          formData.append("name", this.audience.name);
          formData.append("image", this.audience.inputImage);
          res = await this.$axios.post("/audiences", formData);
        } else {
          res = await this.$axios.post("/audiences/sign_in", formData);
        }
        const userType = "audiences";
        this.$store.dispatch("setAuthData", { res, userType });
      } catch (error) {
        if (error.response) this.audience.isError = true;
        this.audience.errorMessage = this.errorText;
      }
    },
  },
};
</script>
