<template>
  <v-container>
    <CardPageTitle :title="pageTitle" data-jest="page-title" />
    <v-row v-if="$vuetify.breakpoint.mdAndUp">
      <v-col xl="4" offset-xl="2">
        <FormAuth
          v-model="band"
          @submit-forms="submitBand"
          @reset-password="resetBandPassword"
        >
          <template #card-title>
            <v-card-subtitle class="text-center">
              {{ band.cardTitle }}
            </v-card-subtitle>
          </template>
        </FormAuth>
      </v-col>
      <v-col xl="4">
        <FormAuth
          v-model="audience"
          @submit-forms="submitAudience"
          @reset-password="resetAudiencePassword"
        >
          <template #card-title>
            <v-card-subtitle class="text-center">
              {{ audience.cardTitle }}
            </v-card-subtitle>
          </template>
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
                <FormAuth
                  v-model="band"
                  @submit-forms="submitBand"
                  @reset-password="resetBandPassword"
                />
              </v-tab-item>
              <v-tab-item>
                <FormAuth
                  v-model="audience"
                  @submit-forms="submitAudience"
                  @reset-password="resetAudiencePassword"
                />
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
import { mapActions } from "vuex";

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
        website: "",
        twitter: "",
        cardTitle: "アーティストの方",
        nameLabel: "Band Name",
        isError: false,
        errorMessage: "",
        resetEmail: "",
        resetDialog: false,
        resetError: false,
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
        resetEmail: "",
        resetDialog: false,
        resetError: false,
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
  },
  watch: {
    "band.resetDialog"(newValue) {
      if (!newValue) {
        this.band.resetEmail = "";
        this.band.resetError = false;
      }
    },
    "audience.resetDialog"(newValue) {
      if (!newValue) {
        this.audience.resetEmail = "";
        this.audience.resetError = false;
      }
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
          res = await this.$axios.post("/bands", formData);
        } else {
          res = await this.$axios.post("/bands/sign_in", formData);
        }
        const userType = "bands";
        this.setAuthData({ res, userType });
      } catch (error) {
        this.band.isError = true;
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
        this.setAuthData({ res, userType });
      } catch (error) {
        this.audience.isError = true;
        this.audience.errorMessage = this.errorText;
      }
    },
    async resetBandPassword() {
      try {
        const formData = new FormData();
        formData.append("email", this.band.resetEmail);
        await this.$axios.post("/bands/password", formData);
        this.band.resetDialog = false;
        this.showResult("パスワード再設定のためのメールを送信しました。");
      } catch (error) {
        this.band.resetError = true;
      }
    },
    async resetAudiencePassword() {
      try {
        const formData = new FormData();
        formData.append("email", this.audience.resetEmail);
        await this.$axios.post("/audiences/password", formData);
        this.audience.resetDialog = false;
        this.showResult("パスワード再設定のためのメールを送信しました。");
      } catch (error) {
        this.audience.resetError = true;
      }
    },
    ...mapActions(["setAuthData", "showResult"]),
  },
};
</script>
